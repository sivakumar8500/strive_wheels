import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/customer_ws_controller.dart';
import '../../../../core/services/active_booking_service.dart';
import 'journey_complete_page.dart';
import '../../../../core/widgets/app_map_widget.dart';

enum TripPhase { navToPickup, driverArrived, inTransit, tripCompleted }

/// Live Trip Tracking Page matching reference UI design with real-time route progress & OTP state machine.
class LiveTripTrackingPage extends StatefulWidget {
  final String driverName;
  final double driverRating;
  final String vehicleInfo;
  final String pickupAddress;
  final String dropAddress;
  final LatLng pickupLatLng;
  final LatLng dropLatLng;
  final LatLng? initialRiderLatLng;
  final String arrivingMins;
  final String distanceMiles;
  final String etaTime;
  final String? startOtp;
  final String initialStatus;

  const LiveTripTrackingPage({
    super.key,
    this.driverName = 'Alexander Smith',
    this.driverRating = 4.9,
    this.vehicleInfo = 'Black Tesla Model S • KLY-1204',
    this.pickupAddress = '245 Market St, San Francisco',
    this.dropAddress = 'San Francisco International Airport (SFO)',
    this.pickupLatLng = const LatLng(17.4126, 78.3498),
    this.dropLatLng = const LatLng(17.4435, 78.3772),
    this.initialRiderLatLng,
    this.arrivingMins = '12 mins',
    this.distanceMiles = '2.4 miles',
    this.etaTime = '14:45',
    this.startOtp,
    this.initialStatus = 'RIDER_ACCEPTED',
  });

  @override
  State<LiveTripTrackingPage> createState() => _LiveTripTrackingPageState();
}

class _LiveTripTrackingPageState extends State<LiveTripTrackingPage>
    with SingleTickerProviderStateMixin {
  GoogleMapController? _mapController;
  late LatLng _currentVehiclePos;
  double _currentVehicleRotation = 0.0;

  List<LatLng> _routePoints = [];

  BitmapDescriptor? _carMarkerIcon;
  BitmapDescriptor? _pickupMarkerIcon;
  BitmapDescriptor? _dropMarkerIcon;

  double _remainingMilesVal = 2.4;
  int _remainingMinsVal = 12;

  TripPhase _phase = TripPhase.navToPickup;
  StreamSubscription? _wsSubscription;

  final Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
    _saveActiveBookingState();
    // Phase 1 Initial Node 123 (Rider Location) or Pickup ABC
    _currentVehiclePos = widget.initialRiderLatLng ??
        LatLng(widget.pickupLatLng.latitude - 0.005, widget.pickupLatLng.longitude - 0.005);

    if (widget.initialStatus == 'TRIP_STARTED') {
      _phase = TripPhase.inTransit;
    } else if (widget.initialStatus == 'DRIVER_ARRIVED' || widget.initialStatus == 'RIDER_ARRIVED') {
      _phase = TripPhase.driverArrived;
    } else {
      _phase = TripPhase.navToPickup;
    }

    // 1. Generate fallback curved street route immediately
    final targetDest = _phase == TripPhase.inTransit ? widget.dropLatLng : widget.pickupLatLng;
    _routePoints = _generateFallbackCurvePoints(_currentVehiclePos, targetDest, 35);
    if (_routePoints.length > 1) {
      _currentVehicleRotation = _calculateBearing(_routePoints[0], _routePoints[1]);
    }

    // 2. Load custom marker icons
    _loadCustomMarkerIcons();

    // 3. Fetch real road OSRM turn-by-turn geometry points
    _fetchRealRoadRoute();

    // 4. Listen to live WebSocket events (rider.location_updated, booking.arrived, booking.started, etc.)
    _setupWebSocketListener();

    // NOTE: No simulation timer — marker only moves from real WS location updates
  }

  void _saveActiveBookingState() {
    if (sl.isRegistered<ActiveBookingService>()) {
      sl<ActiveBookingService>().setActiveBooking(
        ActiveBookingData(
          bookingId: 'ER-9921-X4B',
          driverName: widget.driverName,
          driverRating: widget.driverRating,
          vehicleInfo: widget.vehicleInfo,
          pickupAddress: widget.pickupAddress,
          dropAddress: widget.dropAddress,
          pickupLatLng: widget.pickupLatLng,
          dropLatLng: widget.dropLatLng,
          initialRiderLatLng: widget.initialRiderLatLng,
          totalAmount: '₹124.00',
          startOtp: widget.startOtp,
          status: widget.initialStatus,
        ),
      );
    }
  }

  void _showCancelRideDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(
          'Cancel Active Trip?',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to cancel your ongoing trip with ${widget.driverName}?',
          style: GoogleFonts.poppins(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: Text(
              'Keep Trip',
              style: GoogleFonts.poppins(color: const Color(0xFF64748B)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogCtx).pop();
              if (sl.isRegistered<CustomerWSController>()) {
                sl<CustomerWSController>().cancelRide(bookingId: 'ER-9921-X4B');
              }
              if (sl.isRegistered<ActiveBookingService>()) {
                sl<ActiveBookingService>().clearActiveBooking();
              }
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Trip cancelled successfully'),
                  backgroundColor: Color(0xFFEF4444),
                ),
              );
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(
              'Yes, Cancel',
              style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _setupWebSocketListener() {
    if (sl.isRegistered<CustomerWSController>()) {
      _wsSubscription = sl<CustomerWSController>().bookingEventStream.listen((eventData) {
        final event = eventData['event']?.toString() ?? '';
        final data = eventData['data'] ?? {};
        if (!mounted) return;

        if (event == 'rider.location_updated' || event == 'rider.location') {
          final lat = (data['lat'] as num?)?.toDouble();
          final lng = (data['lng'] as num?)?.toDouble();
          if (lat != null && lng != null) {
            _onRiderLocationUpdate(LatLng(lat, lng));
          }
        } else if (event == 'booking.arrived' || event == 'rider.arrived' || event == 'booking.rider_arrived') {
          setState(() {
            _phase = TripPhase.driverArrived;
          });
          if (sl.isRegistered<ActiveBookingService>()) {
            sl<ActiveBookingService>().updateBookingStatus('DRIVER_ARRIVED');
          }
        } else if (event == 'booking.started' || event == 'rider.trip_started' || event == 'booking.trip_started') {
          setState(() {
            _phase = TripPhase.inTransit;
          });
          if (sl.isRegistered<ActiveBookingService>()) {
            sl<ActiveBookingService>().updateBookingStatus('TRIP_STARTED');
          }
          _fetchRealRoadRoute(from: _currentVehiclePos, to: widget.dropLatLng);
        } else if (event == 'booking.completed' || event == 'rider.trip_completed' || event == 'booking.trip_completed') {
          if (sl.isRegistered<ActiveBookingService>()) {
            sl<ActiveBookingService>().clearActiveBooking();
          }
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => JourneyCompletePage(
                driverName: widget.driverName,
                vehicleInfo: widget.vehicleInfo,
              ),
            ),
          );
        } else if (event == 'booking.cancelled' ||
            event == 'booking.rider_cancelled' ||
            event == 'ride.cancelled' ||
            event == 'booking.cancel_success') {
          // Rider cancelled — clear state and go to home
          if (sl.isRegistered<ActiveBookingService>()) {
            sl<ActiveBookingService>().clearActiveBooking();
          }
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Your ride was cancelled by the rider.'),
                backgroundColor: Color(0xFFEF4444),
                duration: Duration(seconds: 4),
              ),
            );
            Navigator.of(context).popUntil((route) => route.isFirst);
          }
        }
      });
    }
  }

  void _onRiderLocationUpdate(LatLng newPos) {
    final rotation = _calculateBearing(_currentVehiclePos, newPos);
    setState(() {
      _currentVehiclePos = newPos;
      _currentVehicleRotation = rotation;
    });

    _mapController?.animateCamera(CameraUpdate.newLatLng(newPos));

    final target = _phase == TripPhase.inTransit ? widget.dropLatLng : widget.pickupLatLng;
    _fetchRealRoadRoute(from: newPos, to: target);
  }

  /// Create custom dynamic high-resolution vehicle car cursor icon and location pin icons
  Future<void> _loadCustomMarkerIcons() async {
    try {
      final PictureRecorder pictureRecorder = PictureRecorder();
      final Canvas canvas = Canvas(pictureRecorder);
      const double size = 96.0;

      // Drop shadow
      final Paint shadowPaint = Paint()
        ..color = const Color(0x33000000)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
      canvas.drawCircle(const Offset(size / 2, size / 2 + 2), size / 2 - 6, shadowPaint);

      // White outer ring
      final Paint whitePaint = Paint()..color = Colors.white;
      canvas.drawCircle(const Offset(size / 2, size / 2), size / 2 - 6, whitePaint);

      // Inner primary blue circle
      final Paint bluePaint = Paint()..color = AppColors.primaryBlue;
      canvas.drawCircle(const Offset(size / 2, size / 2), size / 2 - 12, bluePaint);

      // Car Icon
      final TextPainter textPainter = TextPainter(textDirection: TextDirection.ltr);
      textPainter.text = TextSpan(
        text: String.fromCharCode(Icons.directions_car_rounded.codePoint),
        style: TextStyle(
          fontSize: 34.0,
          fontFamily: Icons.directions_car_rounded.fontFamily,
          package: Icons.directions_car_rounded.fontPackage,
          color: Colors.white,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(size / 2 - textPainter.width / 2, size / 2 - textPainter.height / 2),
      );

      final img = await pictureRecorder.endRecording().toImage(size.toInt(), size.toInt());
      final data = await img.toByteData(format: ImageByteFormat.png);
      if (data != null && mounted) {
        setState(() {
          _carMarkerIcon = BitmapDescriptor.fromBytes(data.buffer.asUint8List());
        });
      }
    } catch (e) {
      debugPrint('[LiveTripTrackingPage] Error creating car marker icon: $e');
    }
  }

  /// Fetches real road-accurate turn-by-turn geometry points from OSRM
  Future<void> _fetchRealRoadRoute({LatLng? from, LatLng? to}) async {
    final startPt = from ?? _currentVehiclePos;
    final endPt = to ?? (_phase == TripPhase.inTransit ? widget.dropLatLng : widget.pickupLatLng);

    try {
      final url =
          '${ApiConstants.osrmRoute}/${startPt.longitude},${startPt.latitude};${endPt.longitude},${endPt.latitude}?overview=full&geometries=geojson';

      final response = await _dio.get(
        url,
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

          final distanceMeters = (firstRoute['distance'] as num?)?.toDouble() ?? 0;
          final durationSecs = (firstRoute['duration'] as num?)?.toDouble() ?? 0;

          if (coords != null && coords.length >= 2) {
            final List<LatLng> fetchedPoints = coords.map((c) {
              final lng = (c[0] as num).toDouble();
              final lat = (c[1] as num).toDouble();
              return LatLng(lat, lng);
            }).toList();

            if (mounted) {
              setState(() {
                _routePoints = fetchedPoints;
                // Do NOT reset vehicle position — keep the real WS-updated position
                if (_routePoints.length > 1) {
                  _currentVehicleRotation =
                      _calculateBearing(_routePoints[0], _routePoints[1]);
                }
                if (distanceMeters > 0) {
                  _remainingMilesVal = distanceMeters / 1609.34;
                  _remainingMinsVal = max(1, (durationSecs / 60).round());
                }
              });

              _fitMapBounds();
              // No animation timer restart — real position from WebSocket only
            }
          }
        }
      }
    } catch (e) {
      debugPrint('[LiveTripTrackingPage] Failed OSRM route fetch: $e');
    }
  }

  /// Generates a realistic curved road fallback geometry when offline or loading
  List<LatLng> _generateFallbackCurvePoints(LatLng start, LatLng end, int steps) {
    List<LatLng> points = [];
    double midLat = (start.latitude + end.latitude) / 2 + 0.003;
    double midLng = (start.longitude + end.longitude) / 2 - 0.003;

    for (int i = 0; i <= steps; i++) {
      double t = i / steps;
      double lat = (1 - t) * (1 - t) * start.latitude +
          2 * (1 - t) * t * midLat +
          t * t * end.latitude;
      double lng = (1 - t) * (1 - t) * start.longitude +
          2 * (1 - t) * t * midLng +
          t * t * end.longitude;
      points.add(LatLng(lat, lng));
    }
    return points;
  }

  // Vehicle animation timer removed — rider position comes from real WebSocket events only
  // See _onRiderLocationUpdate() for real-time location handling

  /// Calculates bearing angle between start and end coordinates
  double _calculateBearing(LatLng start, LatLng end) {
    final startLat = start.latitude * (pi / 180.0);
    final startLng = start.longitude * (pi / 180.0);
    final endLat = end.latitude * (pi / 180.0);
    final endLng = end.longitude * (pi / 180.0);

    final dLng = endLng - startLng;
    final y = sin(dLng) * cos(endLat);
    final x = cos(startLat) * sin(endLat) -
        sin(startLat) * cos(endLat) * cos(dLng);

    final bearing = atan2(y, x) * (180.0 / pi);
    return (bearing + 360.0) % 360.0;
  }

  /// Fits camera view to show full route and markers with padding
  void _fitMapBounds() {
    if (_mapController == null || _routePoints.isEmpty) return;

    double minLat = _routePoints.first.latitude;
    double maxLat = _routePoints.first.latitude;
    double minLng = _routePoints.first.longitude;
    double maxLng = _routePoints.first.longitude;

    for (final point in _routePoints) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    final bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    _mapController?.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 70),
    );
  }

  @override
  void dispose() {
    _wsSubscription?.cancel();
    super.dispose();
  }

  String get _headerLabel {
    switch (_phase) {
      case TripPhase.navToPickup:
        return 'NAVIGATING TO PICKUP';
      case TripPhase.driverArrived:
        return 'DRIVER ARRIVED AT PICKUP';
      case TripPhase.inTransit:
        return 'EN ROUTE TO DESTINATION';
      case TripPhase.tripCompleted:
        return 'TRIP COMPLETED';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.cardBgDark : Colors.white;

    return Scaffold(
      backgroundColor: isDark ? AppColors.onboardingBgDark : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.onboardingBgDark : Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(
            Icons.menu_rounded,
            color: isDark ? AppColors.textPrimaryDark : AppColors.primaryBlue,
          ),
          onPressed: () {},
        ),
        title: Text(
          AppStrings.appName,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryBlue,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
        actions: [
          // Share Live Trip Pill Button
          Padding(
            padding: const EdgeInsets.only(right: 16, top: 10, bottom: 10),
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Live trip link copied to clipboard!')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              icon: const Icon(Icons.ios_share_rounded, color: Colors.white, size: 16),
              label: Text(
                'Share Live Trip',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Full Screen Google Map with Turn-by-Turn Road Route & Animated Moving Car Cursor
          AppMapWidget(
            initialCameraPosition: CameraPosition(
              target: widget.pickupLatLng,
              zoom: 18.0,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
              _fitMapBounds();
            },
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
            polylines: {
              Polyline(
                polylineId: const PolylineId('street_route'),
                points: _routePoints,
                color: _phase == TripPhase.inTransit ? AppColors.primaryBlue : const Color(0xFF10B981),
                width: 6,
                jointType: JointType.round,
                startCap: Cap.roundCap,
                endCap: Cap.roundCap,
              ),
            },
            markers: {
              // Pickup Location Marker Pin (ABC)
              Marker(
                markerId: const MarkerId('pickup'),
                position: widget.pickupLatLng,
                icon: _pickupMarkerIcon ??
                    BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                infoWindow: const InfoWindow(title: 'Pickup Location (ABC)'),
              ),
              // Dropoff Location Marker Pin (XYZ)
              Marker(
                markerId: const MarkerId('drop'),
                position: widget.dropLatLng,
                icon: _dropMarkerIcon ??
                    BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                infoWindow: const InfoWindow(title: 'Destination (XYZ)'),
              ),
              // Animated Moving Vehicle Car Marker (123 -> ABC -> XYZ)
              Marker(
                markerId: const MarkerId('moving_vehicle'),
                position: _currentVehiclePos,
                rotation: _currentVehicleRotation,
                anchor: const Offset(0.5, 0.5),
                flat: true,
                icon: _carMarkerIcon ??
                    BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
                infoWindow: InfoWindow(
                  title: widget.driverName,
                  snippet: '${_remainingMinsVal} mins (${_remainingMilesVal.toStringAsFixed(1)} mi)',
                ),
              ),
            },
          ),

          // Floating Top ETA Card
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardBgDark : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE8F1FF),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.navigation_rounded,
                      color: AppColors.primaryBlue,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _headerLabel,
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                            color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Text(
                              '$_remainingMinsVal mins',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${_remainingMilesVal.toStringAsFixed(1)} miles',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryBlue,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'ETA',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                          color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.etaTime,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Floating My Location / Center Vehicle Button
          Positioned(
            right: 16,
            bottom: 300,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardBgDark : Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(
                  Icons.my_location_rounded,
                  color: isDark ? AppColors.textPrimaryDark : const Color(0xFF1E293B),
                ),
                onPressed: () {
                  _mapController?.animateCamera(
                    CameraUpdate.newLatLng(_currentVehiclePos),
                  );
                },
              ),
            ),
          ),

          // Bottom Sheet Panel
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 24),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Top Drag Handle Pill
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Driver Details & Call/Chat Actions Row
                  Row(
                    children: [
                      // Driver Avatar with Rating Overlay Badge
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                            ),
                            child: const ClipOval(
                              child: Icon(Icons.person_rounded, size: 40, color: Color(0xFF64748B)),
                            ),
                          ),
                          Positioned(
                            bottom: -4,
                            right: -4,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: const Color(0xFFE2E8F0)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${widget.driverRating}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
                                    ),
                                  ),
                                  const SizedBox(width: 2),
                                  const Icon(Icons.star_rounded, color: AppColors.primaryBlue, size: 11),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    widget.driverName,
                                    style: GoogleFonts.poppins(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (widget.startOtp != null && widget.startOtp!.isNotEmpty) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryBlue.withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: AppColors.primaryBlue.withValues(alpha: 0.3)),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'OTP: ',
                                          style: GoogleFonts.poppins(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.primaryBlue,
                                          ),
                                        ),
                                        Text(
                                          widget.startOtp!,
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.0,
                                            color: AppColors.primaryBlue,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              widget.vehicleInfo,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      // Call Button
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.phone_outlined, color: AppColors.primaryBlue, size: 20),
                          onPressed: () {},
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Chat Button
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.chat_bubble_outline_rounded, color: AppColors.primaryBlue, size: 20),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Location Timeline
                  _buildTimelineRow(
                    isPickup: true,
                    label: 'PICKUP',
                    address: widget.pickupAddress,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 12),
                  _buildTimelineRow(
                    isPickup: false,
                    label: 'DESTINATION',
                    address: widget.dropAddress,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 20),

                  // SOS and Add Stop Action Row
                  Row(
                    children: [
                      // SOS / Emergency Button
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Emergency SOS alert sent!')),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              backgroundColor: isDark ? const Color(0xFF2C1E1E) : const Color(0xFFFFF1F2),
                              side: const BorderSide(color: Color(0xFFFECDD3), width: 1.2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            icon: const Icon(Icons.emergency_rounded, color: Color(0xFFE11D48), size: 18),
                            label: Text(
                              'SOS / Emergency',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFE11D48),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Add Stop Button
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            icon: Icon(
                              Icons.add_circle_outline_rounded,
                              color: isDark ? AppColors.textPrimaryDark : const Color(0xFF475569),
                              size: 18,
                            ),
                            label: Text(
                              'Add Stop',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isDark ? AppColors.textPrimaryDark : const Color(0xFF475569),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Cancel Ride Red Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton.icon(
                      onPressed: () => _showCancelRideDialog(context),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: isDark ? const Color(0xFF2C1E1E) : const Color(0xFFFEF2F2),
                        side: const BorderSide(color: Color(0xFFFECDD3), width: 1.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: const Icon(Icons.cancel_outlined, color: Color(0xFFEF4444), size: 18),
                      label: Text(
                        'Cancel Ride',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFEF4444),
                        ),
                      ),
                    ),
                  ),

                  // Demo Complete Trip Trigger Button
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: TextButton(
                      onPressed: () {
                        if (sl.isRegistered<ActiveBookingService>()) {
                          sl<ActiveBookingService>().clearActiveBooking();
                        }
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => JourneyCompletePage(
                              driverName: widget.driverName,
                              vehicleInfo: widget.vehicleInfo,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'Simulate End of Trip →',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineRow({
    required bool isPickup,
    required String label,
    required String address,
    required bool isDark,
  }) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isPickup ? const Color(0xFF64748B) : AppColors.primaryBlue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.6,
                  color: isDark ? AppColors.textSecondaryDark : const Color(0xFF94A3B8),
                ),
              ),
              Text(
                address,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
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
}
