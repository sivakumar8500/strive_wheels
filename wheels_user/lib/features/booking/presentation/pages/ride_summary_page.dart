import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/services/route_condition_service.dart';
import '../../../driver_search/presentation/bloc/driver_search_bloc.dart';
import '../../../driver_search/presentation/pages/driver_search_page.dart';
import '../../data/models/fare_estimate_model.dart';
import '../../domain/entities/corporate_aligned_vehicle_entity.dart';
import '../../domain/entities/fare_estimate_entity.dart';
import '../../domain/entities/vehicle_type_entity.dart';
import '../../domain/usecases/get_fare_estimate_usecase.dart';

class _VehicleMovementProfile {
  final Offset baseOffset;
  final double headingDegrees;
  final double speedFactor;

  const _VehicleMovementProfile({
    required this.baseOffset,
    required this.headingDegrees,
    required this.speedFactor,
  });
}

/// Ride Summary / Schedule page shown after selecting a vehicle and tapping Book Now.
/// Displays map overview, distance/duration/fare, pickup/drop details, and a confirm button.
class RideSummaryPage extends StatefulWidget {
  final String pickupTitle;
  final String pickupAddress;
  final String dropTitle;
  final String dropAddress;
  final LatLng pickupLatLng;
  final LatLng dropLatLng;
  final VehicleTypeEntity selectedVehicle;
  final String routeDistance;
  final String routeDuration;
  final List<LatLng> routePoints;
  final String bookingMode;
  final bool isCorporate;
  final int? riderId;
  final int? vehicleId;
  final CorporateAlignedVehicleEntity? corporateVehicle;

  const RideSummaryPage({
    super.key,
    required this.pickupTitle,
    required this.pickupAddress,
    required this.dropTitle,
    required this.dropAddress,
    required this.pickupLatLng,
    required this.dropLatLng,
    required this.selectedVehicle,
    this.routeDistance = '—',
    this.routeDuration = '—',
    this.routePoints = const [],
    this.bookingMode = 'INSTANT',
    this.isCorporate = false,
    this.riderId,
    this.vehicleId,
    this.corporateVehicle,
  });

  @override
  State<RideSummaryPage> createState() => _RideSummaryPageState();
}

class _RideSummaryPageState extends State<RideSummaryPage> {
  GoogleMapController? _mapController;

  late DateTime _selectedDate;
  bool _isScheduledRide = false;
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _instantNotification = true;

  String? _corporateCompanyName;
  String? _corporateEmployeeCode;
  String? _corporateSpendingLimit;
  int? _corporateCompanyId;

  // Fare & Route condition state
  FareEstimateEntity? _fareEstimate;
  RouteConditionResult? _routeConditions;
  bool _isLoadingFare = true;
  String? _fareError;

  Timer? _markerAnimTimer;
  double _markerAnimAngle = 0.0;
  final Map<String, BitmapDescriptor> _customMarkerIcons = {};

  static const List<_VehicleMovementProfile> _dummyVehicleProfiles = [
    _VehicleMovementProfile(
      baseOffset: Offset(0.0015, 0.0010),
      headingDegrees: 45.0,
      speedFactor: 1.0,
    ),
    _VehicleMovementProfile(
      baseOffset: Offset(-0.0016, 0.0018),
      headingDegrees: 140.0,
      speedFactor: 1.2,
    ),
    _VehicleMovementProfile(
      baseOffset: Offset(0.0020, -0.0014),
      headingDegrees: 250.0,
      speedFactor: 0.9,
    ),
    _VehicleMovementProfile(
      baseOffset: Offset(-0.0012, -0.0016),
      headingDegrees: 320.0,
      speedFactor: 1.1,
    ),
    _VehicleMovementProfile(
      baseOffset: Offset(0.0006, 0.0024),
      headingDegrees: 85.0,
      speedFactor: 0.8,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _loadCorporateInfo();
    _fetchFareEstimate();
    _initDynamicVehicleMarkers();
  }

  void _loadCorporateInfo() {
    if (!widget.isCorporate) return;
    final prefs = sl.isRegistered<SharedPreferences>() ? sl<SharedPreferences>() : null;
    if (prefs != null) {
      _corporateCompanyName = prefs.getString('corporate_company_name');
      _corporateEmployeeCode = prefs.getString('corporate_employee_code');
      _corporateSpendingLimit = prefs.getString('corporate_spending_limit');
      _corporateCompanyId = prefs.getInt('corporate_company_id');
    }
  }

  @override
  void dispose() {
    _markerAnimTimer?.cancel();
    super.dispose();
  }

  void _initDynamicVehicleMarkers() {
    _startMarkerAnimationTimer();
    _generateCustomMarkerIcons();
  }

  void _startMarkerAnimationTimer() {
    _markerAnimTimer?.cancel();
    _markerAnimTimer = Timer.periodic(const Duration(milliseconds: 1500), (timer) {
      if (mounted) {
        setState(() {
          _markerAnimAngle = (_markerAnimAngle + 0.2) % (2 * pi);
        });
      }
    });
  }

  Future<void> _generateCustomMarkerIcons() async {
    try {
      final bikeIcon = await _loadAssetBitmapDescriptor(
        'assets/images/nav_bike_marker.png',
        targetWidth: 40,
        fallbackIcon: Icons.two_wheeler_rounded,
        badgeColor: const Color(0xFFDCFCE7),
        borderColor: const Color(0xFF16A34A),
        iconColor: const Color(0xFF15803D),
      );

      final autoIcon = await _loadAssetBitmapDescriptor(
        'assets/images/nav_auto_marker.png',
        targetWidth: 45,
        fallbackIcon: Icons.electric_rickshaw_rounded,
        badgeColor: const Color(0xFFFEF3C7),
        borderColor: const Color(0xFFD97706),
        iconColor: const Color(0xFFB45309),
      );

      final carIcon = await _loadAssetBitmapDescriptor(
        'assets/images/nav_car_marker.png',
        targetWidth: 40,
        fallbackIcon: Icons.directions_car_rounded,
        badgeColor: const Color(0xFFDBEAFE),
        borderColor: const Color(0xFF2563EB),
        iconColor: const Color(0xFF1D4ED8),
      );

      final vanIcon = await _loadAssetBitmapDescriptor(
        'assets/images/nav_van_marker.png',
        targetWidth: 50,
        fallbackIcon: Icons.airport_shuttle_rounded,
        badgeColor: const Color(0xFFF3E8FF),
        borderColor: const Color(0xFF9333EA),
        iconColor: const Color(0xFF7E22CE),
      );

      final tempoIcon = await _loadAssetBitmapDescriptor(
        'assets/images/nav_tempo_marker.png',
        targetWidth: 48,
        fallbackIcon: Icons.local_shipping_rounded,
        badgeColor: const Color(0xFFFEF9C3),
        borderColor: const Color(0xFFCA8A04),
        iconColor: const Color(0xFFA16207),
      );

      final truckIcon = await _loadAssetBitmapDescriptor(
        'assets/images/nav_truck_marker.png',
        targetWidth: 55,
        fallbackIcon: Icons.local_shipping_rounded,
        badgeColor: const Color(0xFFFFEDD5),
        borderColor: const Color(0xFFEA580C),
        iconColor: const Color(0xFFC2410C),
      );

      if (mounted) {
        setState(() {
          _customMarkerIcons['BIKE'] = bikeIcon;
          _customMarkerIcons['AUTO'] = autoIcon;
          _customMarkerIcons['CAB'] = carIcon;
          _customMarkerIcons['MINI_VAN'] = vanIcon;
          _customMarkerIcons['TEMPO'] = tempoIcon;
          _customMarkerIcons['TRUCK'] = truckIcon;
        });
      }
    } catch (e) {
      debugPrint('Error generating custom vehicle marker icons in RideSummaryPage: $e');
    }
  }

  Future<BitmapDescriptor> _loadAssetBitmapDescriptor(
    String assetPath, {
    int targetWidth = 40,
    required IconData fallbackIcon,
    required Color badgeColor,
    required Color borderColor,
    required Color iconColor,
  }) async {
    try {
      final ByteData data = await rootBundle.load(assetPath);
      final ui.Codec codec = await ui.instantiateImageCodec(
        data.buffer.asUint8List(),
        targetWidth: targetWidth,
      );
      final ui.FrameInfo fi = await codec.getNextFrame();
      final ByteData? resizedData = await fi.image.toByteData(format: ui.ImageByteFormat.png);

      if (resizedData != null) {
        return BitmapDescriptor.bytes(resizedData.buffer.asUint8List());
      }
    } catch (e) {
      debugPrint('Error loading asset marker $assetPath: $e');
    }

    return _createVehicleMarkerBitmap(
      icon: fallbackIcon,
      badgeColor: badgeColor,
      borderColor: borderColor,
      iconColor: iconColor,
    );
  }

  Future<BitmapDescriptor> _createVehicleMarkerBitmap({
    required IconData icon,
    required Color badgeColor,
    required Color borderColor,
    required Color iconColor,
  }) async {
    try {
      final pictureRecorder = ui.PictureRecorder();
      final canvas = Canvas(pictureRecorder);

      final paintShadow = Paint()
        ..color = Colors.black.withValues(alpha: 0.25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
      canvas.drawCircle(const Offset(27, 27), 24, paintShadow);

      final paintBg = Paint()..color = badgeColor;
      canvas.drawCircle(const Offset(27, 27), 22, paintBg);

      final paintBorder = Paint()
        ..color = borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5;
      canvas.drawCircle(const Offset(27, 27), 22, paintBorder);

      final textPainter = TextPainter(textDirection: TextDirection.ltr);
      textPainter.text = TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontSize: 24,
          fontFamily: icon.fontFamily,
          package: icon.fontPackage,
          color: iconColor,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(27 - textPainter.width / 2, 27 - textPainter.height / 2),
      );

      final img = await pictureRecorder.endRecording().toImage(54, 54);
      final data = await img.toByteData(format: ui.ImageByteFormat.png);
      if (data != null) {
        return BitmapDescriptor.bytes(data.buffer.asUint8List());
      }
    } catch (_) {}
    return BitmapDescriptor.defaultMarker;
  }

  BitmapDescriptor _getMarkerDescriptorForVehicle(VehicleTypeEntity? vehicle) {
    if (vehicle == null) {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
    }
    final code = vehicle.code.toUpperCase();
    if (code.contains('BIKE') || code.contains('TWO') || code.contains('SCOOT')) {
      return _customMarkerIcons['BIKE'] ??
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
    } else if (code.contains('AUTO') || code.contains('RICKSHAW')) {
      return _customMarkerIcons['AUTO'] ??
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
    } else if (code.contains('VAN') || code.contains('TRAVELLER')) {
      return _customMarkerIcons['MINI_VAN'] ??
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet);
    } else if (code.contains('TEMPO') || code.contains('PARCEL') || code.contains('GOODS')) {
      return _customMarkerIcons['TEMPO'] ??
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);
    } else if (code.contains('TRUCK') || code.contains('CARGO')) {
      return _customMarkerIcons['TRUCK'] ??
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose);
    }
    return _customMarkerIcons['CAB'] ??
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
  }

  double get _parsedDistanceKm {
    final clean = widget.routeDistance.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(clean) ?? 9.25;
  }

  int get _parsedDurationMins {
    final clean = widget.routeDuration.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(clean) ?? 20;
  }

  Future<void> _fetchFareEstimate() async {
    final distanceKm = _parsedDistanceKm;
    final durationMins = _parsedDurationMins;

    RouteConditionResult? conditions;
    if (sl.isRegistered<RouteConditionService>()) {
      try {
        conditions = await sl<RouteConditionService>().analyzeRouteConditions(
          pickupLat: widget.pickupLatLng.latitude,
          pickupLng: widget.pickupLatLng.longitude,
          dropLat: widget.dropLatLng.latitude,
          dropLng: widget.dropLatLng.longitude,
        );
        if (mounted) {
          setState(() {
            _routeConditions = conditions;
          });
        }
      } catch (e) {
        debugPrint('Error fetching route conditions: $e');
      }
    }

    final weatherStr = conditions?.weather.apiKey ?? 'CLEAR';
    final trafficLevelStr = conditions?.traffic.apiKey ?? 'LOW';
    final effectiveBookingMode = distanceKm > 80.0 ? 'ONE_WAY' : widget.bookingMode;
    final serviceModeStr = widget.isCorporate ? 'CORPORATE' : 'NORMAL';

    try {
      // Try injected use case first
      if (sl.isRegistered<GetFareEstimateUseCase>()) {
        final estimate = await sl<GetFareEstimateUseCase>()(
          vehicleTypeId: widget.selectedVehicle.id,
          pickupLat: widget.pickupLatLng.latitude,
          pickupLng: widget.pickupLatLng.longitude,
          dropLat: widget.dropLatLng.latitude,
          dropLng: widget.dropLatLng.longitude,
          distanceKm: distanceKm,
          durationMins: durationMins,
          serviceMode: serviceModeStr,
          bookingMode: effectiveBookingMode,
          tripType: 'ONE_WAY',
          couponCode: 'string',
          isAc: true,
          isOutstation: false,
          vehicleAgeYears: 2,
          weather: weatherStr,
          trafficLevel: trafficLevelStr,
          companyId: widget.isCorporate ? _corporateCompanyId : null,
        );
        if (mounted) {
          setState(() {
            _fareEstimate = estimate;
            _isLoadingFare = false;
          });
        }
        return;
      }
    } catch (_) {}

    // Direct Dio fallback
    try {
      final dio = Dio();
      final response = await dio.post(
        '${ApiConstants.baseUrl}${ApiConstants.fareEstimate}',
        data: {
          'service_mode': serviceModeStr,
          'company_id': widget.isCorporate ? (_corporateCompanyId ?? 1) : 1,
          'booking_mode': effectiveBookingMode,
          'trip_type': 'ONE_WAY',
          'vehicle_type_id': widget.selectedVehicle.id,
          'pickup_lat': widget.pickupLatLng.latitude,
          'pickup_lng': widget.pickupLatLng.longitude,
          'drop_lat': widget.dropLatLng.latitude,
          'drop_lng': widget.dropLatLng.longitude,
          'distance_km': distanceKm,
          'duration_mins': durationMins,
          'return_drop_lat': 0,
          'return_drop_lng': 0,
          'waiting_duration_mins': 0,
          'coupon_code': 'string',
          'is_ac': true,
          'is_outstation': false,
          'vehicle_age_years': 2,
          'weather': weatherStr,
          'traffic_level': trafficLevelStr,
        },
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
          },
          sendTimeout: const Duration(seconds: 12),
          receiveTimeout: const Duration(seconds: 12),
        ),
      );
      if (response.statusCode == 200 && response.data != null) {
        final raw = response.data is Map ? response.data as Map : {};
        final dataMap = raw['data'];
        if (dataMap != null) {
          final model = FareEstimateModel.fromJson(
              Map<String, dynamic>.from(dataMap as Map));
          if (mounted) {
            setState(() {
              _fareEstimate = model.toEntity();
              _isLoadingFare = false;
            });
          }
          return;
        }
      }
    } catch (e) {
      debugPrint('Fare estimate error: $e');
    }

    if (mounted) {
      setState(() {
        _isLoadingFare = false;
        _fareError = 'Could not fetch fare';
      });
    }
  }

  // Display helpers ──────────────────────────────────────────────────────────
  bool get _showScheduleOptions =>
      widget.bookingMode == 'ONE_WAY' || widget.bookingMode == 'ROUND_TRIP';

  String get _displayDistance {
    if (_fareEstimate != null) {
      return '${_fareEstimate!.estimatedDistanceKm.toStringAsFixed(1)} km';
    }
    return widget.routeDistance;
  }

  String get _displayDuration {
    if (_fareEstimate != null) {
      return '${_fareEstimate!.estimatedDurationMins} mins';
    }
    return widget.routeDuration;
  }

  String get _displayFare {
    if (_fareEstimate != null) {
      return '₹${_fareEstimate!.estimatedFare.toStringAsFixed(0)}';
    }
    if (_fareError != null) return 'N/A';
    return '…';
  }

  List<DateTime> _get5Days() {
    final today = DateTime.now();
    return List.generate(5, (i) => today.add(Duration(days: i)));
  }

  void _confirmRide() {
    final distanceKm = _parsedDistanceKm;
    final effectiveBookingMode = distanceKm > 80.0 ? 'ONE_WAY' : widget.bookingMode;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider<DriverSearchBloc>(
          create: (_) => sl<DriverSearchBloc>(),
          child: DriverSearchPage(
            vehicleTypeId: widget.selectedVehicle.id,
            pickupLat: widget.pickupLatLng.latitude,
            pickupLng: widget.pickupLatLng.longitude,
            pickupAddress: widget.pickupAddress.isNotEmpty ? widget.pickupAddress : widget.pickupTitle,
            dropLat: widget.dropLatLng.latitude,
            dropLng: widget.dropLatLng.longitude,
            dropAddress: widget.dropAddress.isNotEmpty ? widget.dropAddress : widget.dropTitle,
            serviceMode: widget.isCorporate ? 'CORPORATE' : 'NORMAL',
            bookingMode: effectiveBookingMode,
            tripType: 'ONE_WAY',
            paymentMethod: widget.isCorporate ? 'CORPORATE_BILLING' : 'CASH',
            companyId: widget.isCorporate ? _corporateCompanyId : null,
            riderId: widget.riderId ?? widget.corporateVehicle?.riderId,
            vehicleId: widget.vehicleId ?? widget.corporateVehicle?.vehicleId,
            driverName: widget.corporateVehicle?.driverName,
            vehicleInfo: widget.corporateVehicle?.vehicleName,
            licensePlate: widget.corporateVehicle?.licensePlate,
            routeAlignment: widget.corporateVehicle?.alignmentLabel,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.cardDark : AppColors.cardLight;
    final bgColor = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final dividerColor = isDark ? AppColors.dividerDark : AppColors.dividerLight;
    final sectionBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9);

    final markers = <Marker>{
      Marker(
        markerId: const MarkerId('pickup'),
        position: widget.pickupLatLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: InfoWindow(title: widget.pickupTitle),
      ),
      Marker(
        markerId: const MarkerId('drop'),
        position: widget.dropLatLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(title: widget.dropTitle),
      ),
    };

    final markerIcon = _getMarkerDescriptorForVehicle(widget.selectedVehicle);
    final categoryName = widget.selectedVehicle.name;

    for (int i = 0; i < _dummyVehicleProfiles.length; i++) {
      final profile = _dummyVehicleProfiles[i];
      final headingRad = profile.headingDegrees * pi / 180.0;
      final oscillation =
          sin(_markerAnimAngle * profile.speedFactor + (i * 1.5)) * 0.0004;

      final deltaLat = oscillation * cos(headingRad);
      final deltaLng = oscillation * sin(headingRad);

      final lat = widget.pickupLatLng.latitude + profile.baseOffset.dx + deltaLat;
      final lng = widget.pickupLatLng.longitude + profile.baseOffset.dy + deltaLng;

      final isForward =
          cos(_markerAnimAngle * profile.speedFactor + (i * 1.5)) >= 0;
      final currentHeading =
          isForward ? profile.headingDegrees : (profile.headingDegrees + 180) % 360;

      markers.add(
        Marker(
          markerId: MarkerId('summary_dummy_vehicle_${widget.selectedVehicle.code}_$i'),
          position: LatLng(lat, lng),
          rotation: currentHeading,
          infoWindow: InfoWindow(
            title: '$categoryName Nearby #${i + 1}',
            snippet: 'Available near pickup location',
          ),
          icon: markerIcon,
          anchor: const Offset(0.5, 0.5),
        ),
      );
    }

    final polylines = <Polyline>{
      if (widget.routePoints.length >= 2)
        Polyline(
          polylineId: const PolylineId('summary_route'),
          points: widget.routePoints,
          color: AppColors.primaryBlue,
          width: 5,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
        ),
    };

    final midLat =
        (widget.pickupLatLng.latitude + widget.dropLatLng.latitude) / 2;
    final midLng =
        (widget.pickupLatLng.longitude + widget.dropLatLng.longitude) / 2;

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          // ── Top Bar ──────────────────────────────────────────────────
          Container(
            color: isDark ? AppColors.backgroundDark : Colors.white,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 8,
              bottom: 10,
              left: 8,
              right: 16,
            ),
            child: Row(
              children: [
                IconButton(
                  key: const Key('summary_back_button'),
                  icon: Icon(Icons.arrow_back_rounded, color: textPrimary),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'Strive',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                      Text(
                        'Schedule Ride',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
          ),

          // ── Scrollable Content ───────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                children: [
                  // ── Map View ──────────────────────────────────────────
                  Stack(
                    children: [
                      SizedBox(
                        height: 210,
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: LatLng(midLat, midLng),
                            zoom: 18.0,
                          ),
                          markers: markers,
                          polylines: polylines,
                          mapType: MapType.normal,
                          zoomControlsEnabled: false,
                          myLocationButtonEnabled: false,
                          compassEnabled: false,
                          buildingsEnabled: true,
                          onMapCreated: (ctrl) {
                            _mapController = ctrl;
                            Future.delayed(const Duration(milliseconds: 300),
                                () {
                              if (mounted && _mapController != null) {
                                final swLat =
                                    widget.pickupLatLng.latitude < widget.dropLatLng.latitude
                                        ? widget.pickupLatLng.latitude - 0.01
                                        : widget.dropLatLng.latitude - 0.01;
                                final swLng =
                                    widget.pickupLatLng.longitude < widget.dropLatLng.longitude
                                        ? widget.pickupLatLng.longitude - 0.01
                                        : widget.dropLatLng.longitude - 0.01;
                                final neLat =
                                    widget.pickupLatLng.latitude > widget.dropLatLng.latitude
                                        ? widget.pickupLatLng.latitude + 0.01
                                        : widget.dropLatLng.latitude + 0.01;
                                final neLng =
                                    widget.pickupLatLng.longitude > widget.dropLatLng.longitude
                                        ? widget.pickupLatLng.longitude + 0.01
                                        : widget.dropLatLng.longitude + 0.01;
                                _mapController!.animateCamera(
                                  CameraUpdate.newLatLngBounds(
                                    LatLngBounds(
                                      southwest: LatLng(swLat, swLng),
                                      northeast: LatLng(neLat, neLng),
                                    ),
                                    60.0,
                                  ),
                                );
                              }
                            });
                          },
                        ),
                      ),
                      Positioned(
                        right: 12,
                        bottom: 12,
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: cardBg,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.12),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.gps_fixed_rounded,
                            color: AppColors.primaryBlue,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // ── Distance / Duration / Fare ─────────────────────────
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 12),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: _isLoadingFare
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.primaryBlue,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'Calculating fare…',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Row(
                            children: [
                              _buildStatChip(
                                Icons.straighten_rounded,
                                'DISTANCE',
                                _displayDistance,
                                textPrimary,
                                textSecondary,
                              ),
                              Container(
                                  width: 1, height: 40, color: dividerColor),
                              _buildStatChip(
                                Icons.timer_rounded,
                                'DURATION',
                                _displayDuration,
                                textPrimary,
                                textSecondary,
                              ),
                              Container(
                                  width: 1, height: 40, color: dividerColor),
                              _buildStatChip(
                                Icons.currency_rupee_rounded,
                                'FARE',
                                _displayFare,
                                textPrimary,
                                textSecondary,
                                isFare: true,
                              ),
                            ],
                          ),
                  ),

                  // ── Pickup & Drop Card ─────────────────────────────────
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildLocationRow(
                          isPickup: true,
                          label: 'Pickup Point',
                          title: widget.pickupTitle,
                          address: widget.pickupAddress,
                          textPrimary: textPrimary,
                          textSecondary: textSecondary,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Column(
                            children: List.generate(
                              3,
                              (i) => Container(
                                width: 2,
                                height: 6,
                                margin:
                                    const EdgeInsets.symmetric(vertical: 2),
                                color: dividerColor,
                              ),
                            ),
                          ),
                        ),
                        _buildLocationRow(
                          isPickup: false,
                          label: 'Destination',
                          title: widget.dropTitle,
                          address: widget.dropAddress,
                          textPrimary: textPrimary,
                          textSecondary: textSecondary,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // ── Vehicle Info Card ──────────────────────────────────
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color:
                                AppColors.primaryBlue.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            _vehicleIcon(widget.selectedVehicle.code),
                            color: AppColors.primaryBlue,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.selectedVehicle.name,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: textPrimary,
                                ),
                              ),
                              Text(
                                'Up to ${widget.selectedVehicle.maxPassengers} passengers',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color:
                                AppColors.primaryBlue.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            widget.selectedVehicle.code,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryBlue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // ── Route Conditions (Traffic & Weather) Card ──────────
                  if (_routeConditions != null)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.traffic_rounded,
                                  color: AppColors.primaryBlue, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                'Route Conditions & Surge',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: textPrimary,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: _routeConditions!.totalSurgeMultiplier > 1.0
                                      ? const Color(0xFFFEF3C7)
                                      : const Color(0xFFDCFCE7),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '${_routeConditions!.totalSurgeMultiplier}x Multiplier',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: _routeConditions!.totalSurgeMultiplier > 1.0
                                        ? const Color(0xFFD97706)
                                        : const Color(0xFF16A34A),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _buildFareRow(
                              'Weather: ${_routeConditions!.weather.label}',
                              '${_routeConditions!.weatherMultiplier}x',
                              textPrimary,
                              textSecondary,
                              dividerColor),
                          _buildFareRow(
                              'Traffic Level: ${_routeConditions!.traffic.label}',
                              '${_routeConditions!.trafficMultiplier}x',
                              textPrimary,
                              textSecondary,
                              dividerColor),
                        ],
                      ),
                    ),
                  const SizedBox(height: 12),

                  // ── Fare Breakdown Card (shown when API responds) ──────
                  if (!_isLoadingFare && _fareEstimate != null)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.receipt_long_rounded,
                                  color: AppColors.primaryBlue, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                'Fare Breakdown',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: textPrimary,
                                ),
                              ),
                              const Spacer(),
                              if (_fareEstimate!.surgeMultiplier > 1)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFEF3C7),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    '${_fareEstimate!.surgeMultiplier}x Surge',
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFFD97706),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _buildFareRow('Base Fare',
                              '₹${_fareEstimate!.baseFare.toStringAsFixed(0)}',
                              textPrimary, textSecondary, dividerColor),
                          _buildFareRow(
                              'Distance Charge (${_fareEstimate!.estimatedDistanceKm.toStringAsFixed(1)} km)',
                              '₹${_fareEstimate!.distanceCharge.toStringAsFixed(0)}',
                              textPrimary, textSecondary, dividerColor),
                          _buildFareRow(
                              'Time Charge (${_fareEstimate!.estimatedDurationMins} mins)',
                              '₹${_fareEstimate!.timeCharge.toStringAsFixed(0)}',
                              textPrimary, textSecondary, dividerColor),
                          if (_fareEstimate!.waitingCharge > 0)
                            _buildFareRow(
                                'Waiting Charge',
                                '₹${_fareEstimate!.waitingCharge.toStringAsFixed(0)}',
                                textPrimary, textSecondary, dividerColor),
                          if (_fareEstimate!.discountAmount > 0)
                            _buildFareRow(
                                'Discount',
                                '- ₹${_fareEstimate!.discountAmount.toStringAsFixed(0)}',
                                textPrimary,
                                const Color(0xFF16A34A),
                                dividerColor,
                                isDiscount: true),
                          Divider(color: dividerColor, height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total Estimate',
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: textPrimary,
                                ),
                              ),
                              Text(
                                '₹${_fareEstimate!.estimatedFare.toStringAsFixed(0)}',
                                style: GoogleFonts.inter(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryBlue,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 12),

                  // ── Corporate Account & Direct Billing Card ──
                  if (widget.isCorporate) ...[
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark ? const Color(0xFF334155) : const Color(0xFFBFDBFE),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: (isDark ? Colors.black : AppColors.primaryBlue).withValues(alpha: 0.06),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryBlue.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.business_rounded,
                                  color: AppColors.primaryBlue,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _corporateCompanyName ?? 'Corporate Company',
                                      style: GoogleFonts.inter(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: textPrimary,
                                      ),
                                    ),
                                    if (_corporateEmployeeCode != null && _corporateEmployeeCode!.isNotEmpty)
                                      Text(
                                        'Employee ID: $_corporateEmployeeCode',
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          color: textSecondary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDCFCE7),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'VERIFIED',
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF15803D),
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Divider(height: 1),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.account_balance_rounded, size: 16, color: AppColors.primaryBlue),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Payment Method:',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                'Corporate Direct Billing',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF0038A8),
                                ),
                              ),
                            ],
                          ),
                          if (_corporateSpendingLimit != null && _corporateSpendingLimit!.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Monthly Limit Allowance:',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: textSecondary,
                                  ),
                                ),
                                Text(
                                  '₹$_corporateSpendingLimit',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF16A34A),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (widget.corporateVehicle != null) ...[
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFF10B981),
                            width: 1.4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF10B981).withValues(alpha: 0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF10B981).withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.route_rounded, size: 14, color: Color(0xFF10B981)),
                                      const SizedBox(width: 4),
                                      Text(
                                        widget.corporateVehicle!.alignmentLabel,
                                        style: GoogleFonts.inter(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF10B981),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryBlue.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '${widget.corporateVehicle!.seats} Seats',
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primaryBlue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '${widget.corporateVehicle!.vehicleName} • ${widget.corporateVehicle!.licensePlate}',
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.person, size: 14, color: Color(0xFF64748B)),
                                const SizedBox(width: 4),
                                Text(
                                  'Driver: ${widget.corporateVehicle!.driverName}',
                                  style: GoogleFonts.inter(fontSize: 12, color: textSecondary),
                                ),
                                const SizedBox(width: 10),
                                const Icon(Icons.star_rounded, size: 14, color: Color(0xFFF59E0B)),
                                const SizedBox(width: 2),
                                Text(
                                  widget.corporateVehicle!.driverRating.toStringAsFixed(1),
                                  style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: textSecondary),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ],

                  // ── Pick Date & Time (shown for ONE_WAY and ROUND_TRIP) ────
                  if (_showScheduleOptions) ...[
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_month_rounded,
                                color: AppColors.primaryBlue,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Pick Date & Time',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: textPrimary,
                                ),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () => setState(
                                    () => _isScheduledRide = !_isScheduledRide),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _isScheduledRide
                                        ? AppColors.primaryBlue
                                            .withValues(alpha: 0.12)
                                        : sectionBg,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: _isScheduledRide
                                          ? AppColors.primaryBlue
                                          : dividerColor,
                                    ),
                                  ),
                                  child: Text(
                                    _isScheduledRide ? 'Schedule' : 'Ride Now',
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: _isScheduledRide
                                          ? AppColors.primaryBlue
                                          : textSecondary,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // Day Selector
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: _get5Days().map((date) {
                              final isSelected =
                                  date.day == _selectedDate.day &&
                                      date.month == _selectedDate.month;
                              const dayNames = [
                                'Mon', 'Tue', 'Wed', 'Thu',
                                'Fri', 'Sat', 'Sun'
                              ];
                              return GestureDetector(
                                key: Key('day_selector_${date.day}'),
                                onTap: () =>
                                    setState(() => _selectedDate = date),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: 52,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.primaryBlue
                                        : sectionBg,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.primaryBlue
                                          : dividerColor,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        dayNames[date.weekday - 1],
                                        style: GoogleFonts.inter(
                                          fontSize: 11,
                                          color: isSelected
                                              ? Colors.white
                                                  .withValues(alpha: 0.8)
                                              : textSecondary,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${date.day}',
                                        style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: isSelected
                                              ? Colors.white
                                              : textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 14),

                          Text(
                            'Select Time',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: textSecondary,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Time Display Row
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: sectionBg,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  '${_selectedTime.hourOfPeriod == 0 ? 12 : _selectedTime.hourOfPeriod}:${_selectedTime.minute.toString().padLeft(2, '0')}',
                                  style: GoogleFonts.inter(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: textPrimary,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildAmPmChip('AM',
                                        _selectedTime.period == DayPeriod.am),
                                    const SizedBox(height: 2),
                                    _buildAmPmChip('PM',
                                        _selectedTime.period == DayPeriod.pm),
                                  ],
                                ),
                                const Spacer(),
                                GestureDetector(
                                  key: const Key('time_edit_button'),
                                  onTap: () async {
                                    final picked = await showTimePicker(
                                      context: context,
                                      initialTime: _selectedTime,
                                    );
                                    if (picked != null) {
                                      setState(() => _selectedTime = picked);
                                    }
                                  },
                                  child: Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? const Color(0xFF1E293B)
                                          : const Color(0xFFE2E8F0),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.edit_rounded,
                                        color: textSecondary, size: 18),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  // ── Notifications & Terms ──────────────────────────────
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        if (_showScheduleOptions) ...[
                          Row(
                            children: [
                              GestureDetector(
                                key: const Key('instant_notification_toggle'),
                                onTap: () => setState(() =>
                                    _instantNotification = !_instantNotification),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 150),
                                  width: 22,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    color: _instantNotification
                                        ? AppColors.primaryBlue
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: _instantNotification
                                          ? AppColors.primaryBlue
                                          : dividerColor,
                                      width: 2,
                                    ),
                                  ),
                                  child: _instantNotification
                                      ? const Icon(Icons.check,
                                          color: Colors.white, size: 14)
                                      : null,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Instant notification',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: textPrimary,
                                  ),
                                ),
                              ),
                              Icon(Icons.notifications_none_rounded,
                                  color: textSecondary, size: 22),
                            ],
                          ),
                          const SizedBox(height: 14),
                        ],
                        _buildTermRow(
                            Icons.check_circle_outline_rounded,
                            'Take number halting (per day 3 free)',
                            textSecondary),
                        _buildTermRow(
                            Icons.check_circle_outline_rounded,
                            'Driver beta',
                            textSecondary),
                        _buildTermRow(
                            Icons.check_circle_outline_rounded,
                            'Driver alwence',
                            textSecondary),
                        _buildTermRow(
                            Icons.check_circle_outline_rounded,
                            'Toll charges',
                            textSecondary),
                        _buildTermRow(
                            Icons.info_outline_rounded,
                            'Terms and conditions',
                            AppColors.primaryBlue,
                            isLink: true),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),

      // ── Confirm Button ─────────────────────────────────────────────────
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 12,
          bottom: MediaQuery.of(context).padding.bottom + 12,
        ),
        decoration: BoxDecoration(
          color: isDark ? AppColors.backgroundDark : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            key: const Key('confirm_schedule_button'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: _confirmRide,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _isScheduledRide
                      ? 'Confirm Schedule'
                      : 'Confirm Ride',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_rounded,
                    color: Colors.white, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAmPmChip(String label, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primaryBlue : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: isActive
              ? Colors.white
              : (Theme.of(context).brightness == Brightness.dark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight),
        ),
      ),
    );
  }

  Widget _buildStatChip(
    IconData icon,
    String label,
    String value,
    Color textPrimary,
    Color textSecondary, {
    bool isFare = false,
  }) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.primaryBlue, size: 18),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: textSecondary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: isFare ? 11 : 14,
              fontWeight: FontWeight.bold,
              color: textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationRow({
    required bool isPickup,
    required String label,
    required String title,
    required String address,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 12,
          height: 12,
          margin: const EdgeInsets.only(top: 2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isPickup ? AppColors.primaryBlue : AppColors.accentOrange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: textSecondary,
                ),
              ),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textPrimary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (address.isNotEmpty && address != title)
                Text(
                  address,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTermRow(
    IconData icon,
    String text,
    Color color, {
    bool isLink = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: color,
                decoration: isLink ? TextDecoration.underline : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFareRow(
    String label,
    String value,
    Color textPrimary,
    Color textSecondary,
    Color dividerColor, {
    bool isDiscount = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: textSecondary,
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDiscount ? const Color(0xFF16A34A) : textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  IconData _vehicleIcon(String code) {
    final upper = code.toUpperCase();
    if (upper.contains('BIKE') || upper.contains('SCOOT')) {
      return Icons.two_wheeler_rounded;
    }
    if (upper.contains('AUTO')) return Icons.electric_rickshaw_rounded;
    if (upper.contains('VAN') || upper.contains('TEMPO')) {
      return Icons.airport_shuttle_rounded;
    }
    if (upper.contains('BUS')) return Icons.directions_bus_rounded;
    return Icons.local_taxi_rounded;
  }
}
