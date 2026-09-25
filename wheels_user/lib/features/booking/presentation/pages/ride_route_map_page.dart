import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/network/api_constants.dart';

import '../../data/models/vehicle_type_model.dart';
import '../../domain/entities/corporate_aligned_vehicle_entity.dart';
import '../../domain/entities/vehicle_type_entity.dart';
import '../../domain/usecases/get_corporate_aligned_vehicles_usecase.dart';
import '../../domain/usecases/get_vehicle_types_usecase.dart';
import 'ride_summary_page.dart';
import '../../../../core/widgets/app_map_widget.dart';

class _VehicleMovementProfile {
  final Offset baseOffset;
  final double headingDegrees;
  final double speedFactor;

  const _VehicleMovementProfile({
    required this.baseOffset,
    required this.headingDegrees,
    this.speedFactor = 1.0,
  });
}

/// Detailed Ride Route Map Page with native Google Maps street view, turn-by-turn routing,
/// brand-themed draggable bottom sheet with swipe-down dismissal, and ride selection.
class RideRouteMapPage extends StatefulWidget {
  final String pickupTitle;
  final String pickupAddress;
  final String dropTitle;
  final String dropAddress;
  final LatLng pickupLatLng;
  final LatLng dropLatLng;
  final String bookingMode;
  final bool isCorporate;
  final Dio? dio;
  final List<VehicleTypeEntity>? initialVehicleTypes;
  final GetVehicleTypesUseCase? getVehicleTypesUseCase;
  final GetCorporateAlignedVehiclesUseCase? getCorporateAlignedVehiclesUseCase;

  const RideRouteMapPage({
    super.key,
    required this.pickupTitle,
    required this.pickupAddress,
    required this.dropTitle,
    required this.dropAddress,
    this.pickupLatLng = const LatLng(17.4483, 78.3915),
    this.dropLatLng = const LatLng(17.4938, 78.3995),
    this.bookingMode = 'INSTANT',
    this.isCorporate = false,
    this.dio,
    this.initialVehicleTypes,
    this.getVehicleTypesUseCase,
    this.getCorporateAlignedVehiclesUseCase,
  });

  @override
  State<RideRouteMapPage> createState() => _RideRouteMapPageState();
}

class _RideRouteMapPageState extends State<RideRouteMapPage> {
  GoogleMapController? _mapController;
  int _selectedVehicleIndex = 0;
  double _sheetPosition = 0.65;
  MapType _currentMapType = MapType.normal;

  late final Dio _dio;
  CancelToken? _cancelToken;
  List<LatLng> _routePoints = [];
  String _routeDurationText = '~18 min';
  String _routeDistanceText = '7.8 km';

  List<VehicleTypeEntity> _vehicleTypes = [];
  bool _isLoadingVehicles = true;

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

  static const List<VehicleTypeEntity> _fallbackVehicleTypes = [
    VehicleTypeEntity(
      id: 1,
      code: 'CAB',
      name: 'Cab (Sedan / Hatchback)',
      description: 'Comfortable AC rides for up to 4 passengers',
      maxPassengers: 4,
      maxWeightKg: 0,
    ),
    VehicleTypeEntity(
      id: 2,
      code: 'AUTO',
      name: 'Auto Rickshaw',
      description: 'Affordable doorstep rides for everyday commute',
      maxPassengers: 3,
      maxWeightKg: 0,
    ),
    VehicleTypeEntity(
      id: 3,
      code: 'BIKE',
      name: 'Bike Taxi',
      description: 'Fastest way to beat traffic solo',
      maxPassengers: 1,
      maxWeightKg: 0,
    ),
    VehicleTypeEntity(
      id: 4,
      code: 'MINI_VAN',
      name: 'Mini Van / Tempo Traveller',
      description: 'Group travel with ample luggage space',
      maxPassengers: 8,
      maxWeightKg: 500,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _dio = widget.dio ?? Dio();
    _cancelToken = CancelToken();
    _fetchRoutePolyline();
    _fetchVehicleTypes();
    if (widget.isCorporate) {
      _fetchCorporateAlignedVehicles();
    }
    _initDynamicVehicleMarkers();
  }

  /// Fetches active vehicle types from the API or injected usecase
  Future<void> _fetchVehicleTypes() async {
    if (widget.initialVehicleTypes != null &&
        widget.initialVehicleTypes!.isNotEmpty) {
      if (mounted) {
        setState(() {
          _vehicleTypes = widget.initialVehicleTypes!;
          _isLoadingVehicles = false;
        });
      }
      return;
    }

    try {
      if (widget.getVehicleTypesUseCase != null) {
        final types = await widget.getVehicleTypesUseCase!();
        if (types.isNotEmpty && mounted) {
          setState(() {
            _vehicleTypes = types;
            _isLoadingVehicles = false;
          });
          return;
        }
      } else if (sl.isRegistered<GetVehicleTypesUseCase>()) {
        final types = await sl<GetVehicleTypesUseCase>()();
        if (types.isNotEmpty && mounted) {
          setState(() {
            _vehicleTypes = types;
            _isLoadingVehicles = false;
          });
          return;
        }
      }

      final response = await _dio.get(
        '${ApiConstants.baseUrl}${ApiConstants.vehicleTypes}',
        cancelToken: _cancelToken,
        options: Options(
          headers: {'accept': 'application/json'},
          sendTimeout: const Duration(seconds: 8),
          receiveTimeout: const Duration(seconds: 8),
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data is Map ? response.data : {};
        final list = data['data'] as List<dynamic>? ?? [];
        final parsed = list.map((item) {
          final m = Map<String, dynamic>.from(item as Map);
          return VehicleTypeModel.fromJson(m).toEntity();
        }).toList();

        if (parsed.isNotEmpty && mounted) {
          setState(() {
            _vehicleTypes = parsed;
            _isLoadingVehicles = false;
          });
          return;
        }
      }
    } catch (e) {
      debugPrint('Error loading vehicle types: $e');
    }

    if (mounted) {
      setState(() {
        _vehicleTypes = _fallbackVehicleTypes;
        _isLoadingVehicles = false;
      });
    }
  }

  String _getDefaultSubtitle(VehicleTypeEntity vehicle) {
    if (vehicle.description != null && vehicle.description!.trim().isNotEmpty) {
      return vehicle.description!;
    }
    final upper = vehicle.code.toUpperCase();
    if (upper.contains('BIKE')) return 'Quick & affordable solo ride';
    if (upper.contains('AUTO')) return 'Doorstep pickup for daily commutes';
    if (upper.contains('CAB')) return 'Comfortable AC sedan ride';
    if (upper.contains('VAN')) return 'Ideal for groups & luggage';
    if (upper.contains('TEMPO')) return 'Parcel & goods transport';
    if (upper.contains('BUS')) return 'Spacious group transport';
    if (upper.contains('TRUCK')) return 'Heavy cargo & logistics';
    return 'Fast & reliable ride';
  }

  List<CorporateAlignedVehicleEntity> _corporateAlignedVehicles = [];
  bool _isLoadingCorporateVehicles = false;

  Future<void> _fetchCorporateAlignedVehicles() async {
    if (!widget.isCorporate) return;
    setState(() {
      _isLoadingCorporateVehicles = true;
    });

    try {
      if (widget.getCorporateAlignedVehiclesUseCase != null) {
        final list = await widget.getCorporateAlignedVehiclesUseCase!(
          pickupLat: widget.pickupLatLng.latitude,
          pickupLng: widget.pickupLatLng.longitude,
          dropAddress: widget.dropAddress,
        );
        if (mounted) {
          setState(() {
            _corporateAlignedVehicles = list;
            _isLoadingCorporateVehicles = false;
          });
        }
        return;
      } else if (sl.isRegistered<GetCorporateAlignedVehiclesUseCase>()) {
        final list = await sl<GetCorporateAlignedVehiclesUseCase>()(
          pickupLat: widget.pickupLatLng.latitude,
          pickupLng: widget.pickupLatLng.longitude,
          dropAddress: widget.dropAddress,
        );
        if (mounted) {
          setState(() {
            _corporateAlignedVehicles = list;
            _isLoadingCorporateVehicles = false;
          });
        }
        return;
      }
    } catch (e) {
      debugPrint('Error loading corporate aligned vehicles: $e');
    }

    if (mounted) {
      setState(() {
        _isLoadingCorporateVehicles = false;
      });
    }
  }

  void _bookCorporateVehicle(CorporateAlignedVehicleEntity corpVehicle) {
    VehicleTypeEntity matchedVehicle = _vehicleTypes.firstWhere(
      (v) => v.id == corpVehicle.vehicleTypeId,
      orElse: () => _vehicleTypes.isNotEmpty
          ? _vehicleTypes.first
          : const VehicleTypeEntity(
              id: 1,
              code: 'CAB',
              name: 'Cab',
              description: 'Corporate Aligned Cab',
              maxPassengers: 4,
              maxWeightKg: 0,
            ),
    );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RideSummaryPage(
          pickupTitle: widget.pickupTitle,
          pickupAddress: widget.pickupAddress,
          dropTitle: widget.dropTitle,
          dropAddress: widget.dropAddress,
          pickupLatLng: widget.pickupLatLng,
          dropLatLng: widget.dropLatLng,
          selectedVehicle: matchedVehicle,
          routeDistance: _routeDistanceText,
          routeDuration: _routeDurationText,
          routePoints: _routePoints,
          bookingMode: widget.bookingMode,
          isCorporate: true,
          riderId: corpVehicle.riderId,
          vehicleId: corpVehicle.vehicleId,
          corporateVehicle: corpVehicle,
        ),
      ),
    );
  }

  void _bookVehicle(VehicleTypeEntity vehicle) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RideSummaryPage(
          pickupTitle: widget.pickupTitle,
          pickupAddress: widget.pickupAddress,
          dropTitle: widget.dropTitle,
          dropAddress: widget.dropAddress,
          pickupLatLng: widget.pickupLatLng,
          dropLatLng: widget.dropLatLng,
          selectedVehicle: vehicle,
          routeDistance: _routeDistanceText,
          routeDuration: _routeDurationText,
          routePoints: _routePoints,
          bookingMode: widget.bookingMode,
          isCorporate: widget.isCorporate,
        ),
      ),
    );
  }

  void _showVehicleDetailsModal(
      BuildContext context, VehicleTypeEntity vehicle) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.cardDark : AppColors.cardLight;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final dividerColor =
        isDark ? AppColors.dividerDark : AppColors.dividerLight;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (modalContext) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 16,
              bottom: MediaQuery.of(modalContext).padding.bottom + 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF475569)
                          : const Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: _buildVehicleImage(
                              vehicle, true, textSecondary,
                              iconSize: 28),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            vehicle.name,
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF1E293B)
                                  : const Color(0xFFEEF2F6),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              vehicle.code,
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryBlue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Divider(color: dividerColor),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF1E293B)
                              : const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: dividerColor),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.people_alt_rounded,
                                    size: 15, color: AppColors.primaryBlue),
                                const SizedBox(width: 6),
                                Text(
                                  'Passengers',
                                  style: GoogleFonts.inter(
                                      fontSize: 12, color: textSecondary),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${vehicle.maxPassengers} Max',
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF1E293B)
                              : const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: dividerColor),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.scale_rounded,
                                    size: 15, color: AppColors.primaryBlue),
                                const SizedBox(width: 6),
                                Text(
                                  'Max Cargo',
                                  style: GoogleFonts.inter(
                                      fontSize: 12, color: textSecondary),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              vehicle.maxWeightKg > 0
                                  ? '${vehicle.maxWeightKg.toInt()} kg'
                                  : 'Standard',
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'About this ride',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _getDefaultSubtitle(vehicle),
                  style: GoogleFonts.inter(
                      fontSize: 13, color: textSecondary, height: 1.4),
                ),
                const SizedBox(height: 16),
                _buildPerkRow(
                    Icons.check_circle_rounded,
                    'Doorstep pickup with verified driver',
                    textSecondary),
                const SizedBox(height: 8),
                _buildPerkRow(
                    Icons.gps_fixed_rounded,
                    'Real-time GPS ride tracking & SOS',
                    textSecondary),
                const SizedBox(height: 8),
                _buildPerkRow(
                    Icons.payments_outlined,
                    'Digital UPI, Card & Cash payment options',
                    textSecondary),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    key: const Key('modal_book_now_button'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(modalContext).pop();
                      _bookVehicle(vehicle);
                    },
                    child: Text(
                      'Book ${vehicle.name}',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPerkRow(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primaryBlue),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.inter(fontSize: 12, color: color),
          ),
        ),
      ],
    );
  }

  void _initDynamicVehicleMarkers() {
    _startMarkerAnimationTimer();
    _generateCustomMarkerIcons();
  }

  void _startMarkerAnimationTimer() {
    _markerAnimTimer?.cancel();
    _markerAnimTimer =
        Timer.periodic(const Duration(milliseconds: 1500), (timer) {
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
      debugPrint('Error generating custom vehicle marker icons: $e');
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
      final ByteData? resizedData =
          await fi.image.toByteData(format: ui.ImageByteFormat.png);

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

  Set<Marker> _buildMarkersForSelectedVehicle(
      VehicleTypeEntity? selectedVehicle) {
    final markers = <Marker>{
      Marker(
        markerId: const MarkerId('pickup_marker'),
        position: widget.pickupLatLng,
        infoWindow: InfoWindow(
          title: widget.pickupTitle,
          snippet: widget.pickupAddress,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
      Marker(
        markerId: const MarkerId('drop_marker'),
        position: widget.dropLatLng,
        infoWindow: InfoWindow(
          title: widget.dropTitle,
          snippet: widget.dropAddress,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    };

    if (selectedVehicle == null) return markers;

    final markerIcon = _getMarkerDescriptorForVehicle(selectedVehicle);
    final categoryName = selectedVehicle.name;

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
          markerId: MarkerId('dummy_vehicle_${selectedVehicle.code}_$i'),
          position: LatLng(lat, lng),
          rotation: currentHeading,
          infoWindow: InfoWindow(
            title: '$categoryName Nearby #${i + 1}',
            snippet: 'Moving near pickup location',
          ),
          icon: markerIcon,
          anchor: const Offset(0.5, 0.5),
        ),
      );
    }

    return markers;
  }

  Widget _buildVehicleImage(
    VehicleTypeEntity vehicle,
    bool isSelected,
    Color textSecondary, {
    double iconSize = 26,
  }) {
    final rawUrl = vehicle.iconUrl?.trim();
    if (rawUrl != null && rawUrl.isNotEmpty) {
      final String fullUrl = (rawUrl.startsWith('http://') || rawUrl.startsWith('https://'))
          ? rawUrl
          : (rawUrl.startsWith('/')
              ? '${ApiConstants.baseUrl}$rawUrl'
              : '${ApiConstants.baseUrl}/$rawUrl');

      return Image.network(
        fullUrl,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return _buildStaticFallbackVehicleImage(
            vehicle.code,
            isSelected,
            textSecondary,
            iconSize: iconSize,
          );
        },
      );
    }

    return _buildStaticFallbackVehicleImage(
      vehicle.code,
      isSelected,
      textSecondary,
      iconSize: iconSize,
    );
  }

  Widget _buildStaticFallbackVehicleImage(
    String code,
    bool isSelected,
    Color textSecondary, {
    double iconSize = 26,
  }) {
    final upper = code.toUpperCase();
    String? assetPath;
    IconData fallbackIcon = Icons.directions_car_rounded;

    if (upper.contains('BIKE') || upper.contains('TWO') || upper.contains('SCOOT')) {
      assetPath = 'assets/images/nav_bike_marker.png';
      fallbackIcon = Icons.two_wheeler_rounded;
    } else if (upper.contains('AUTO') || upper.contains('RICKSHAW')) {
      assetPath = 'assets/images/nav_auto_marker.png';
      fallbackIcon = Icons.electric_rickshaw_rounded;
    } else if (upper.contains('VAN') || upper.contains('TRAVELLER')) {
      assetPath = 'assets/images/nav_van_marker.png';
      fallbackIcon = Icons.airport_shuttle_rounded;
    } else if (upper.contains('TEMPO') || upper.contains('PARCEL') || upper.contains('GOODS')) {
      assetPath = 'assets/images/nav_tempo_marker.png';
      fallbackIcon = Icons.local_shipping_rounded;
    } else if (upper.contains('TRUCK') || upper.contains('CARGO')) {
      assetPath = 'assets/images/nav_truck_marker.png';
      fallbackIcon = Icons.local_shipping_rounded;
    } else if (upper.contains('CAB') ||
        upper.contains('CAR') ||
        upper.contains('PRIORITY')) {
      assetPath = 'assets/images/nav_car_marker.png';
      fallbackIcon = Icons.directions_car_rounded;
    }

    if (assetPath != null) {
      return Image.asset(
        assetPath,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => Icon(
          fallbackIcon,
          color: isSelected ? AppColors.primaryBlue : textSecondary,
          size: iconSize,
        ),
      );
    }

    return Icon(
      fallbackIcon,
      color: isSelected ? AppColors.primaryBlue : textSecondary,
      size: iconSize,
    );
  }

  @override
  void dispose() {
    _markerAnimTimer?.cancel();
    _cancelToken?.cancel();
    super.dispose();
  }

  /// Fetches real road-accurate turn-by-turn geometry points from OSRM
  Future<void> _fetchRoutePolyline() async {
    _generateFallbackCurve();

    try {
      final url =
          '${ApiConstants.osrmRoute}/${widget.pickupLatLng.longitude},${widget.pickupLatLng.latitude};${widget.dropLatLng.longitude},${widget.dropLatLng.latitude}?overview=full&geometries=geojson';
      final response = await _dio.get(
        url,
        cancelToken: _cancelToken,
        options: Options(
          responseType: ResponseType.json,
          sendTimeout: const Duration(seconds: 4),
          receiveTimeout: const Duration(seconds: 4),
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data is Map ? response.data : {};
        final routes = data['routes'] as List<dynamic>?;
        if (routes != null && routes.isNotEmpty) {
          final firstRoute = routes.first as Map<String, dynamic>;
          final geometry = firstRoute['geometry'] as Map<String, dynamic>?;
          final coords = geometry?['coordinates'] as List<dynamic>?;
          final durationSeconds =
              (firstRoute['duration'] as num?)?.toDouble() ?? 0;
          final distanceMeters =
              (firstRoute['distance'] as num?)?.toDouble() ?? 0;

          if (coords != null && coords.isNotEmpty) {
            final List<LatLng> points = coords.map((c) {
              final lng = (c[0] as num).toDouble();
              final lat = (c[1] as num).toDouble();
              return LatLng(lat, lng);
            }).toList();

            final mins = (durationSeconds / 60).round();
            final km = (distanceMeters / 1000).toStringAsFixed(1);

            if (mounted) {
              setState(() {
                _routePoints = points;
                _routeDurationText = '~$mins min';
                _routeDistanceText = '$km km';
              });
              _fitRouteBounds();
            }
            return;
          }
        }
      }
    } catch (e) {
      debugPrint('OSRM routing fetch error: $e');
    }
  }

  /// Realistic curved path when network route geometry is unavailable
  void _generateFallbackCurve() {
    final pLat = widget.pickupLatLng.latitude;
    final pLng = widget.pickupLatLng.longitude;
    final dLat = widget.dropLatLng.latitude;
    final dLng = widget.dropLatLng.longitude;

    final points = <LatLng>[
      LatLng(pLat, pLng),
      LatLng(pLat + (dLat - pLat) * 0.25 + 0.002,
          pLng + (dLng - pLng) * 0.15 - 0.001),
      LatLng(pLat + (dLat - pLat) * 0.50 + 0.005,
          pLng + (dLng - pLng) * 0.45 - 0.003),
      LatLng(pLat + (dLat - pLat) * 0.75 + 0.003,
          pLng + (dLng - pLng) * 0.80 + 0.001),
      LatLng(dLat, dLng),
    ];

    if (mounted) {
      setState(() {
        _routePoints = points;
      });
    }
  }

  /// Recenter on the pickup location at high street-level zoom showing all landmarks and street names
  void _recenterNearPickup() {
    if (_mapController == null) return;
    _mapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: widget.pickupLatLng,
          zoom: 18.0,
        ),
      ),
    );
  }

  /// Fit both points and route on the map
  void _fitRouteBounds() {
    if (_mapController == null) return;
    final southWestLat =
        min(widget.pickupLatLng.latitude, widget.dropLatLng.latitude);
    final southWestLng =
        min(widget.pickupLatLng.longitude, widget.dropLatLng.longitude);
    final northEastLat =
        max(widget.pickupLatLng.latitude, widget.dropLatLng.latitude);
    final northEastLng =
        max(widget.pickupLatLng.longitude, widget.dropLatLng.longitude);

    _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(southWestLat - 0.005, southWestLng - 0.005),
          northeast: LatLng(northEastLat + 0.005, northEastLng + 0.005),
        ),
        80.0,
      ),
    );
  }

  /// Toggle between Google Street Map, Satellite / Hybrid, and Terrain
  void _toggleMapLayer() {
    setState(() {
      if (_currentMapType == MapType.normal) {
        _currentMapType = MapType.hybrid;
      } else if (_currentMapType == MapType.hybrid) {
        _currentMapType = MapType.terrain;
      } else {
        _currentMapType = MapType.normal;
      }
    });

    final typeName = _currentMapType == MapType.normal
        ? 'Street View'
        : (_currentMapType == MapType.hybrid ? 'Satellite View' : 'Terrain View');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$typeName Enabled'),
        duration: const Duration(seconds: 1),
        backgroundColor: AppColors.primaryBlue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.cardDark : AppColors.cardLight;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final dividerColor = isDark ? AppColors.dividerDark : AppColors.dividerLight;

    final selectedVehicle = _vehicleTypes.isNotEmpty
        ? _vehicleTypes[
            _selectedVehicleIndex.clamp(0, _vehicleTypes.length - 1)]
        : null;

    final markers = _buildMarkersForSelectedVehicle(selectedVehicle);

    final polylines = {
      Polyline(
        polylineId: const PolylineId('route_polyline'),
        points: _routePoints.isNotEmpty
            ? _routePoints
            : [widget.pickupLatLng, widget.dropLatLng],
        color: AppColors.primaryBlue,
        width: 6,
        jointType: JointType.round,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
      ),
    };

    final screenHeight = MediaQuery.of(context).size.height;
    final floatingButtonsBottom = screenHeight * _sheetPosition + 12;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: Stack(
        children: [
          // 1. Native Google Map View with Official Street View showing all roads, buildings, and names
          Positioned.fill(
            child: AppMapWidget(
              initialCameraPosition: CameraPosition(
                target: widget.pickupLatLng,
                zoom: 18.0,
                tilt: 45.0,
              ),
              buildingsEnabled: true,
              tiltGesturesEnabled: true,
              rotateGesturesEnabled: true,
              mapType: _currentMapType,
              markers: markers,
              polylines: polylines,
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
              compassEnabled: true,
              onMapCreated: (controller) {
                _mapController = controller;
                _fitRouteBounds();
              },
            ),
          ),

          // 2. Top Route Header with Circular Back Button & Route Capsule
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            right: 16,
            child: Row(
              children: [
                // Circular Themed Back Button
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: cardBg,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    key: const Key('map_back_button'),
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      Icons.arrow_back_rounded,
                      color: textPrimary,
                      size: 24,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(width: 10),

                // Route Info Capsule (Tap to fit entire route in view)
                Expanded(
                  child: GestureDetector(
                    onTap: _fitRouteBounds,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xFF16A34A),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        widget.pickupTitle,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: textPrimary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.accentOrange,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        widget.dropTitle,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: textPrimary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryBlue
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  _routeDurationText,
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryBlue,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _routeDistanceText,
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  color: textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Current Location Button (Beside top locations)
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: cardBg,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    key: const Key('map_recenter_button'),
                    padding: EdgeInsets.zero,
                    tooltip: 'Current Location',
                    icon: const Icon(
                      Icons.my_location_rounded,
                      color: AppColors.primaryBlue,
                      size: 22,
                    ),
                    onPressed: _recenterNearPickup,
                  ),
                ),
              ],
            ),
          ),

          // 3. Floating Map Layer Toggle Button (Glide smoothly above draggable bottom sheet)
          Positioned(
            right: 16,
            bottom: floatingButtonsBottom,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: cardBg,
                shape: BoxShape.circle,
                border: Border.all(
                  color: dividerColor,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                key: const Key('street_view_mode_button'),
                padding: EdgeInsets.zero,
                tooltip: 'Switch Map View',
                icon: Icon(
                  _currentMapType == MapType.normal
                      ? Icons.map_rounded
                      : Icons.layers_rounded,
                  color: AppColors.primaryBlue,
                  size: 22,
                ),
                onPressed: _toggleMapLayer,
              ),
            ),
          ),

          // 4. Draggable Bottom Sheet with Brand Theme (Slides down smoothly on swipe)
          NotificationListener<DraggableScrollableNotification>(
            onNotification: (notification) {
              setState(() {
                _sheetPosition = notification.extent;
              });
              return true;
            },
            child: DraggableScrollableSheet(
              initialChildSize: 0.65,
              minChildSize: 0.18,
              maxChildSize: 0.90,
              snap: true,
              snapSizes: const [0.18, 0.65, 0.90],
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(24)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 20,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: ListView(
                    controller: scrollController,
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 10,
                      bottom: MediaQuery.of(context).padding.bottom + 16,
                    ),
                    children: [
                      // Drag Handle Bar (Swipe down visual indicator)
                      Center(
                        child: Container(
                          width: 42,
                          height: 5,
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF64748B)
                                : const Color(0xFFCBD5E1),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Corporate Banner / Discount Ribbon Banner
                      if (widget.isCorporate) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isDark
                                  ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
                                  : [const Color(0xFF0038A8), const Color(0xFF002266)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.business_rounded, color: Colors.white, size: 16),
                              const SizedBox(width: 8),
                              Text(
                                'Corporate Ride • Company Billing',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ] else ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color:
                                AppColors.primaryBlue.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              'Saving ₹15 with special discount',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryBlue,
                              ),
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 12),

                      // Corporate Aligned Vehicles Section
                      if (widget.isCorporate) ...[
                        if (_isLoadingCorporateVehicles) ...[
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 14,
                                    height: 14,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryBlue),
                                  ),
                                  SizedBox(width: 8),
                                  Text('Checking aligned corporate vehicles...', style: TextStyle(fontSize: 12)),
                                ],
                              ),
                            ),
                          ),
                        ] else if (_corporateAlignedVehicles.isNotEmpty) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Aligned Route Vehicles',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: textPrimary,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF10B981).withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '${_corporateAlignedVehicles.length} Available',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF10B981),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ..._corporateAlignedVehicles.map((corpVehicle) {
                            return _buildCorporateVehicleCard(corpVehicle, isDark, textPrimary, textSecondary);
                          }),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(child: Divider(color: dividerColor)),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  'or select standard vehicle category',
                                  style: GoogleFonts.inter(fontSize: 11, color: textSecondary),
                                ),
                              ),
                              Expanded(child: Divider(color: dividerColor)),
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                      ],

                      // Vehicle Options Vertical List
                      if (_isLoadingVehicles)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryBlue,
                            ),
                          ),
                        )
                      else
                        Column(
                          children:
                              List.generate(_vehicleTypes.length, (index) {
                            final vehicle = _vehicleTypes[index];
                            final isSelected = _selectedVehicleIndex == index;

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedVehicleIndex = index;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 12),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primaryBlue.withValues(
                                          alpha: isDark ? 0.15 : 0.08)
                                      : (isDark
                                          ? const Color(0xFF1E293B)
                                          : const Color(0xFFF8FAFC)),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primaryBlue
                                        : dividerColor,
                                    width: isSelected ? 2.0 : 1.0,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    // Vehicle Icon / Avatar
                                    Container(
                                      width: 44,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? AppColors.primaryBlue
                                                .withValues(alpha: 0.12)
                                            : (isDark
                                                ? const Color(0xFF0F172A)
                                                : const Color(0xFFEDF2F7)),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(12),
                                        child: Padding(
                                          padding: const EdgeInsets.all(4),
                                          child: _buildVehicleImage(
                                              vehicle, isSelected, textSecondary,
                                              iconSize: 26),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),

                                    // Name, Subtitle, Capacity
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            vehicle.name,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.inter(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: textPrimary,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            _getDefaultSubtitle(vehicle),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.inter(
                                              fontSize: 12,
                                              color: textSecondary,
                                            ),
                                          ),
                                          const SizedBox(height: 3),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.person,
                                                size: 13,
                                                color: textSecondary,
                                              ),
                                              const SizedBox(width: 3),
                                              Text(
                                                '${vehicle.maxPassengers}',
                                                style: GoogleFonts.inter(
                                                  fontSize: 12,
                                                  color: textSecondary,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              if (vehicle.maxWeightKg > 0) ...[
                                                const SizedBox(width: 8),
                                                Icon(
                                                  Icons.scale_rounded,
                                                  size: 13,
                                                  color: textSecondary,
                                                ),
                                                const SizedBox(width: 3),
                                                Text(
                                                  '${vehicle.maxWeightKg.toInt()} kg',
                                                  style: GoogleFonts.inter(
                                                    fontSize: 12,
                                                    color: textSecondary,
                                                    fontWeight:
                                                        FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),

                                    // Right Side: No Price, Two Clickable Texts: "Book Now" & "View Details"
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // "Book Now" Clickable Action
                                        InkWell(
                                          key: Key('book_now_${vehicle.id}'),
                                          onTap: () {
                                            setState(() {
                                              _selectedVehicleIndex = index;
                                            });
                                            _bookVehicle(vehicle);
                                          },
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: AppColors.primaryBlue,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: AppColors.primaryBlue
                                                      .withValues(alpha: 0.25),
                                                  blurRadius: 4,
                                                  offset: const Offset(0, 1),
                                                ),
                                              ],
                                            ),
                                            child: Text(
                                              'Book Now',
                                              style: GoogleFonts.inter(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 6),

                                        // "View Details" Clickable Text
                                        InkWell(
                                          key: Key(
                                              'view_details_${vehicle.id}'),
                                          onTap: () => _showVehicleDetailsModal(
                                              context, vehicle),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 2, horizontal: 2),
                                            child: Text(
                                              'View Details',
                                              style: GoogleFonts.inter(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                color: isDark
                                                    ? const Color(0xFF60A5FA)
                                                    : AppColors.primaryBlue,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                      const SizedBox(height: 10),

                      // Payment & Offers Row
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF0F172A)
                              : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: dividerColor),
                        ),
                        child: Row(
                          children: [
                            // Rapido Wallet
                            Expanded(
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryBlue
                                          .withValues(alpha: 0.12),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.account_balance_wallet_rounded,
                                      color: AppColors.primaryBlue,
                                      size: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'Rapido Wallet',
                                              style: GoogleFonts.inter(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: textPrimary,
                                              ),
                                            ),
                                            Icon(
                                              Icons.chevron_right,
                                              size: 16,
                                              color: textSecondary,
                                            ),
                                          ],
                                        ),
                                        Text(
                                          'Low Balance: ₹0.0',
                                          style: GoogleFonts.inter(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xFFEF4444),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              height: 28,
                              width: 1,
                              color: dividerColor,
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                            ),

                            // Offers
                            InkWell(
                              onTap: () {},
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: AppColors.accentOrange
                                          .withValues(alpha: 0.15),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.local_offer_rounded,
                                      color: AppColors.accentOrange,
                                      size: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Offers',
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: textPrimary,
                                    ),
                                  ),
                                  Icon(
                                    Icons.chevron_right,
                                    size: 16,
                                    color: textSecondary,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Brand-Theme Action Button: "Book <Vehicle>"
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          key: const Key('confirm_ride_booking_button'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBlue,
                            foregroundColor: Colors.white,
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: selectedVehicle != null
                              ? () => _bookVehicle(selectedVehicle)
                              : null,
                          child: Text(
                            selectedVehicle != null
                                ? 'Book ${selectedVehicle.name}'
                                : 'Select a Vehicle',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCorporateVehicleCard(
    CorporateAlignedVehicleEntity corpVehicle,
    bool isDark,
    Color textPrimary,
    Color textSecondary,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: corpVehicle.isAligned
              ? const Color(0xFF10B981)
              : (isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
          width: corpVehicle.isAligned ? 1.5 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: corpVehicle.isAligned
                      ? const Color(0xFF10B981).withValues(alpha: 0.15)
                      : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      corpVehicle.isAligned ? Icons.route_rounded : Icons.directions_car_rounded,
                      size: 13,
                      color: corpVehicle.isAligned ? const Color(0xFF10B981) : textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      corpVehicle.alignmentLabel,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: corpVehicle.isAligned ? const Color(0xFF10B981) : textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${corpVehicle.seats} Seats',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${corpVehicle.vehicleName} • ${corpVehicle.licensePlate}',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(Icons.person, size: 13, color: textSecondary),
                        const SizedBox(width: 4),
                        Text(
                          corpVehicle.driverName,
                          style: GoogleFonts.inter(fontSize: 12, color: textSecondary),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.star_rounded, size: 13, color: Color(0xFFF59E0B)),
                        const SizedBox(width: 2),
                        Text(
                          corpVehicle.driverRating.toStringAsFixed(1),
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              InkWell(
                key: Key('book_corporate_vehicle_${corpVehicle.id}'),
                onTap: () => _bookCorporateVehicle(corpVehicle),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF059669), Color(0xFF10B981)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF10B981).withValues(alpha: 0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    'Book Route',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
