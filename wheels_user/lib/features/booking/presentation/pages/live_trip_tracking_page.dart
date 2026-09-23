import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/customer_ws_controller.dart';
import '../../../../core/services/active_booking_service.dart';
import '../../../../core/services/navigation_service.dart';
import '../widgets/maneuver_banner_widget.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../home/presentation/widgets/home_bottom_nav_bar.dart';
import 'journey_complete_page.dart';
import '../../../../core/widgets/app_map_widget.dart';
import '../../../chat/presentation/pages/ride_chat_page.dart';

enum TripPhase { navToPickup, driverArrived, inTransit, tripCompleted }

/// Live Trip Tracking Page matching reference UI design with real-time route progress & OTP state machine.
class LiveTripTrackingPage extends StatefulWidget {
  final String? bookingId;
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
    this.bookingId,
    this.driverName = 'Alexander Smith',
    this.driverRating = 4.9,
    this.vehicleInfo = 'Black Tesla Model S • KLY-1204',
    this.pickupAddress = '245 Market St, San Francisco',
    this.dropAddress = 'San Francisco International Airport (SFO)',
    this.pickupLatLng = const LatLng(17.4126, 78.3498),
    this.dropLatLng = const LatLng(17.4435, 78.3772),
    this.initialRiderLatLng,
    this.arrivingMins = '12 mins',
    this.distanceMiles = '2.4 km',
    this.etaTime = '14:45',
    this.startOtp,
    this.initialStatus = 'RIDER_ACCEPTED',
  });

  @override
  State<LiveTripTrackingPage> createState() => _LiveTripTrackingPageState();
}

class _LiveTripTrackingPageState extends State<LiveTripTrackingPage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  GoogleMapController? _mapController;
  late LatLng _currentVehiclePos;
  double _currentVehicleRotation = 0.0;

  List<LatLng> _routePoints = [];
  List<LatLng> _dropoffPreviewRoutePoints = [];

  BitmapDescriptor? _carMarkerIcon;
  BitmapDescriptor? _pickupMarkerIcon;
  BitmapDescriptor? _dropMarkerIcon;
  BitmapDescriptor? _navArrowIcon;

  double _remainingMetersVal = 2400.0;
  double _remainingSecondsVal = 720.0;

  List<NavigationStep> _routeSteps = [];
  NavigationStep? _currentStep;
  double _distanceToStepMeters = 0.0;

  bool _isMuted = true;
  bool _isFollowingVehicle = true;
  bool _is3DView = true;
  bool _isSheetMinimized = false;
  bool _isProgrammaticCameraMove = false;

  bool _isDropRequested = false;
  int _dropCountdownSeconds = 30;
  Timer? _dropCountdownTimer;
  String _selectedDropReason = 'Reached destination early';

  bool _isFetchingRoute = false;
  bool _isRouteUnavailable = false;
  DateTime? _lastRouteFetchTime;
  LatLng? _lastRouteFetchPos;
  double _savedFareAmount = 0.0;

  late AnimationController _animController;
  LatLng _animStartPos = const LatLng(0, 0);
  LatLng _animTargetPos = const LatLng(0, 0);
  double _animStartRotation = 0.0;
  double _animTargetRotation = 0.0;

  bool _isRiderDropModalShowing = false;

  late final Dio _dio;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WakelockPlus.enable();
    _dio = sl.isRegistered<Dio>() ? sl<Dio>() : Dio();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _saveActiveBookingState();
      }
    });

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..addListener(() {
        if (!mounted) return;
        final t = Curves.easeInOut.transform(_animController.value);
        setState(() {
          _currentVehiclePos = LatLng(
            _animStartPos.latitude + (_animTargetPos.latitude - _animStartPos.latitude) * t,
            _animStartPos.longitude + (_animTargetPos.longitude - _animStartPos.longitude) * t,
          );
          _currentVehicleRotation = _animStartRotation + (_animTargetRotation - _animStartRotation) * t;
        });

        if (_isFollowingVehicle && _mapController != null) {
          final targetCamPos = _calculateHeadingCameraTarget(
            _currentVehiclePos,
            _currentVehicleRotation,
            25.0,
          );
          _isProgrammaticCameraMove = true;
          _mapController!.moveCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: targetCamPos,
                zoom: 18.0,
                tilt: _is3DView ? 60.0 : 0.0,
                bearing: _currentVehicleRotation,
              ),
            ),
          );
        }
      });

    // Phase 1 Initial Rider Location or Pickup
    _currentVehiclePos = widget.initialRiderLatLng ??
        LatLng(widget.pickupLatLng.latitude - 0.005, widget.pickupLatLng.longitude - 0.005);
    _lastLocationTime = DateTime.now();

    final initStatus = widget.initialStatus.toUpperCase();
    if (initStatus == 'TRIP_STARTED' ||
        initStatus == 'IN_TRANSIT' ||
        initStatus == 'ON_THE_WAY' ||
        initStatus == 'STARTED' ||
        initStatus == 'RIDER_TRIP_STARTED') {
      _phase = TripPhase.inTransit;
      _startCustomerDeviceLocationTracking();
    } else if (initStatus == 'DRIVER_ARRIVED' ||
        initStatus == 'RIDER_ARRIVED' ||
        initStatus == 'ARRIVED') {
      _phase = TripPhase.driverArrived;
    } else {
      _phase = TripPhase.navToPickup;
    }

    // 1. Load custom marker icons
    _loadCustomMarkerIcons();

    // 2. Fetch real road OSRM turn-by-turn geometry points
    _fetchRealRoadRoute();
    _fetchDropoffPreviewRoute();

    // 3. Listen to live WebSocket events (rider.location_updated, booking.arrived, booking.started, etc.)
    _setupWebSocketListener();

    // 4. Start stale location check timer (15 second threshold)
    _startStaleLocationTimer();
  }

  TripPhase _phase = TripPhase.navToPickup;
  StreamSubscription? _wsSubscription;
  StreamSubscription<Position>? _customerPositionStreamSubscription;
  Timer? _staleTimer;
  DateTime? _lastLocationTime;
  bool _isLocationStale = false;
  bool _hasNavigatedToComplete = false;

  Future<void> _startCustomerDeviceLocationTracking() async {
    if (_customerPositionStreamSubscription != null) return;
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        debugPrint('[LiveTripTrackingPage] Customer location permission not granted');
        return;
      }

      _customerPositionStreamSubscription = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 2,
        ),
      ).listen((Position position) {
        if (!mounted) return;
        if (_phase == TripPhase.inTransit) {
          final customerPos = LatLng(position.latitude, position.longitude);
          _onRiderLocationUpdate(customerPos);
        }
      });
      debugPrint('[LiveTripTrackingPage] Customer device location tracking active for inTransit phase.');
    } catch (e) {
      debugPrint('[LiveTripTrackingPage] Error starting customer position stream: $e');
    }
  }

  void _startStaleLocationTimer() {
    _staleTimer?.cancel();
    _staleTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted || _hasNavigatedToComplete) return;
      if (_lastLocationTime != null) {
        final secondsSinceLastFix = DateTime.now().difference(_lastLocationTime!).inSeconds;
        final isStaleNow = secondsSinceLastFix > 15;
        if (isStaleNow != _isLocationStale) {
          setState(() {
            _isLocationStale = isStaleNow;
          });
        }
      }
      _checkActiveBookingStatusHttp();
    });
  }

  Future<void> _checkActiveBookingStatusHttp() async {
    try {
      if (_hasNavigatedToComplete) return;
      final bookingId = _effectiveBookingId;
      if (bookingId.isEmpty) return;

      final cleanId = bookingId.replaceAll(RegExp(r'[^0-9]'), '');
      final bIdPath = cleanId.isNotEmpty ? cleanId : bookingId;

      final res = await _dio.get('${ApiConstants.baseUrl}/api/v1/bookings/$bIdPath');
      final data = res.data is Map ? res.data['data'] ?? res.data : {};
      final status = (data['status'] ?? data['booking']?['status'])?.toString().toUpperCase() ?? '';

      debugPrint('[LiveTripTrackingPage] Active booking status sync on check: $status');

      final isDropReq = data['is_drop_requested'] == true;
      final dropReqBy = (data['drop_requested_by'] ?? data['requested_by'])?.toString().toUpperCase() ?? '';
      final isDropAcc = data['is_drop_accepted'] == true;

      if (isDropAcc) {
        if (_hasNavigatedToComplete) return;
        _onRiderApprovedDrop(data);
        return;
      }

      if (isDropReq && dropReqBy != 'CUSTOMER' && !_isRiderDropModalShowing && mounted) {
        final reason = (data['drop_request_reason'] ?? data['reason'] ?? 'Early drop requested by driver').toString();
        _showRiderDropRequestModal(reason: reason);
      }

      if (status == 'TRIP_STARTED' || status == 'TRIP_IN_PROGRESS' || status == 'IN_TRANSIT' || status == 'STARTED') {
        if (mounted && _phase != TripPhase.inTransit) {
          setState(() {
            _phase = TripPhase.inTransit;
            _lastRouteFetchTime = null;
            _lastRouteFetchPos = null;
            _routeSteps = [];
            _currentStep = null;
          });
          _startCustomerDeviceLocationTracking();
          if (sl.isRegistered<ActiveBookingService>()) {
            sl<ActiveBookingService>().updateBookingStatus('TRIP_STARTED');
          }
          _fetchRealRoadRoute(from: _currentVehiclePos, to: widget.dropLatLng, force: true);
        }
      } else if (status == 'DRIVER_ARRIVED' || status == 'RIDER_ARRIVED' || status == 'ARRIVED') {
        if (mounted && _phase != TripPhase.driverArrived) {
          setState(() {
            _phase = TripPhase.driverArrived;
          });
          if (sl.isRegistered<ActiveBookingService>()) {
            sl<ActiveBookingService>().updateBookingStatus('DRIVER_ARRIVED');
          }
        }
      } else if (status == 'CANCELLED' || status == 'RIDER_CANCELLED' || status == 'CUSTOMER_CANCELLED' || status == 'CANCEL_SUCCESS') {
        final reason = (data['reason'] ?? data['cancel_reason'])?.toString() ?? '';
        final cancelledBy = (data['cancelled_by'])?.toString() ?? '';
        final displayMsg = cancelledBy.toUpperCase() == 'CUSTOMER'
            ? 'Trip cancelled successfully.'
            : (reason.isNotEmpty ? reason : 'Your ride was cancelled by the rider while you were away.');

        if (sl.isRegistered<ActiveBookingService>()) {
          sl<ActiveBookingService>().clearActiveBooking();
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(displayMsg),
              backgroundColor: const Color(0xFFEF4444),
              duration: const Duration(seconds: 4),
            ),
          );
          Navigator.of(context).pushAndRemoveUntil(HomePage.route(), (route) => false);
        }
      } else if (status == 'COMPLETED' || status == 'TRIP_COMPLETED' || status == 'FINISHED') {
        if (sl.isRegistered<ActiveBookingService>()) {
          sl<ActiveBookingService>().clearActiveBooking();
        }
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => JourneyCompletePage(
                driverName: widget.driverName,
                vehicleInfo: widget.vehicleInfo,
                distanceText: _formattedDistance,
                durationText: _formattedDuration,
              ),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('[LiveTripTrackingPage] HTTP status check error: $e');
    }
  }

  String get _effectiveBookingId =>
      widget.bookingId ??
      (sl.isRegistered<ActiveBookingService>() ? sl<ActiveBookingService>().activeBooking?.bookingId : null) ??
      'ER-9921-X4B';

  void _saveActiveBookingState() {
    if (sl.isRegistered<ActiveBookingService>()) {
      sl<ActiveBookingService>().setActiveBooking(
        ActiveBookingData(
          bookingId: _effectiveBookingId,
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
                final bookingId = sl.isRegistered<ActiveBookingService>()
                    ? sl<ActiveBookingService>().activeBooking?.bookingId ?? 'Unknown'
                    : 'Unknown';
                sl<CustomerWSController>().cancelRide(bookingId: bookingId);
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
              Navigator.of(context).pushAndRemoveUntil(HomePage.route(), (route) => false);
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
        debugPrint('[LiveTripTrackingPage] Received WS Event: $eventData');
        final event = eventData['event']?.toString() ?? '';
        final data = eventData['data'] is Map
            ? Map<String, dynamic>.from(eventData['data'])
            : Map<String, dynamic>.from(eventData);
        if (!mounted) return;

        final isLocationEvent = event == 'rider.location_updated' ||
            event == 'rider.location' ||
            event == 'location_update' ||
            event == 'location.update' ||
            event == 'location.updated' ||
            event == 'driver.location' ||
            event == 'driver.location_updated' ||
            event == 'booking.location_updated';

        if (isLocationEvent) {
          // After OTP verification (inTransit), customer marker moves based on customer's own device location
          // Only update location from rider socket events during pre-pickup phase
          if (_phase != TripPhase.inTransit) {
            final lat = ((data['lat'] ??
                    data['latitude'] ??
                    data['rider_lat'] ??
                    data['driver_lat'] ??
                    (data['location'] is Map ? data['location']['lat'] ?? data['location']['latitude'] : null)) as num?)
                ?.toDouble();
            final lng = ((data['lng'] ??
                    data['longitude'] ??
                    data['rider_lng'] ??
                    data['driver_lng'] ??
                    (data['location'] is Map ? data['location']['lng'] ?? data['location']['longitude'] : null)) as num?)
                ?.toDouble();
            if (lat != null && lng != null && lat != 0.0 && lng != 0.0) {
              _onRiderLocationUpdate(LatLng(lat, lng));
            }
          }
        } else {
          dynamic notifMetadata;
          if (data['notification'] is Map) {
            notifMetadata = data['notification']['metadata'];
          }
          final rawStatus = (data['status'] ?? 
                             (data['booking'] is Map ? data['booking']['status'] : null) ?? 
                             eventData['status'] ?? 
                             (notifMetadata is Map ? notifMetadata['status'] : null))
                             ?.toString().toUpperCase() ?? '';

          final isDriverArrived =
              event == 'booking.arrived' ||
              event == 'rider.arrived' ||
              event == 'driver.arrived' ||
              event == 'booking.rider_arrived' ||
              rawStatus == 'RIDER_ARRIVED' ||
              rawStatus == 'DRIVER_ARRIVED' ||
              rawStatus == 'ARRIVED';

          if (isDriverArrived && _phase != TripPhase.inTransit && _phase != TripPhase.driverArrived) {
            setState(() {
              _phase = TripPhase.driverArrived;
            });
            if (sl.isRegistered<ActiveBookingService>()) {
              sl<ActiveBookingService>().updateBookingStatus('DRIVER_ARRIVED');
            }
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.white, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Driver has arrived! Share OTP with driver: ${widget.startOtp ?? ""}',
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: AppColors.primaryBlue,
                  duration: const Duration(seconds: 4),
                ),
              );
            }
          }

          final isTripStarted =
              event == 'booking.verify' ||
              event == 'booking.verified' ||
              event == 'otpverify' ||
              event == 'booking.otp_verified' ||
              event == 'otp_verified' ||
              event == 'booking.trip_started' ||
              event == 'booking.started' ||
              event == 'rider.trip_started' ||
              event == 'trip_started' ||
              event == 'trip.started' ||
              event == 'booking.start_success' ||
              event == 'ride.started' ||
              event == 'booking.start' ||
              data['otp_verified'] == true ||
              rawStatus == 'TRIP_STARTED' ||
              rawStatus == 'TRIP_IN_PROGRESS' ||
              rawStatus == 'IN_TRANSIT' ||
              rawStatus == 'STARTED';

          final bookingObj = data['booking'] as Map<String, dynamic>?;
          if (bookingObj != null) {
            final fFare = bookingObj['final_fare'] ?? bookingObj['estimated_fare'];
            if (fFare is num && fFare > 0) {
              _savedFareAmount = fFare.toDouble();
            }
          }
          if (data['final_fare'] is num && (data['final_fare'] as num) > 0) {
            _savedFareAmount = (data['final_fare'] as num).toDouble();
          } else if (data['finalFare'] is num && (data['finalFare'] as num) > 0) {
            _savedFareAmount = (data['finalFare'] as num).toDouble();
          }

          if (isTripStarted) {
            if (_phase != TripPhase.inTransit) {
              setState(() {
                _phase = TripPhase.inTransit;
                _lastRouteFetchTime = null;
                _lastRouteFetchPos = null;
                _routeSteps = [];
                _currentStep = null;
              });
              _startCustomerDeviceLocationTracking();
              if (sl.isRegistered<ActiveBookingService>()) {
                sl<ActiveBookingService>().updateBookingStatus('TRIP_STARTED');
              }
              _fetchRealRoadRoute(from: _currentVehiclePos, to: widget.dropLatLng, force: true);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'OTP Verified! Ride Started - En Route to Destination',
                            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: AppColors.primaryBlue,
                    duration: const Duration(seconds: 4),
                  ),
                );
              }
            }
          } else if (event == 'booking.completed' || event == 'rider.trip_completed' || event == 'booking.trip_completed') {
            if (_hasNavigatedToComplete) return;
            _hasNavigatedToComplete = true;
            _staleTimer?.cancel();
            if (sl.isRegistered<ActiveBookingService>()) {
              sl<ActiveBookingService>().clearActiveBooking();
            }
            final fareVal = data['final_fare'] ?? data['finalFare'] ?? data['price'] ?? data['fare'] ?? data['final_amount'] ??
                bookingObj?['final_fare'] ?? bookingObj?['estimated_fare'] ?? bookingObj?['finalFare'];
            final double fare = (fareVal is num) ? fareVal.toDouble() : (double.tryParse(fareVal?.toString() ?? '') ?? _savedFareAmount);
            final String fareStr = fare > 0 ? '₹${fare.toStringAsFixed(2)}' : (_savedFareAmount > 0 ? '₹${_savedFareAmount.toStringAsFixed(2)}' : '');

            if (mounted) {
              ScaffoldMessenger.of(context).clearSnackBars();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => JourneyCompletePage(
                    driverName: widget.driverName,
                    vehicleInfo: widget.vehicleInfo,
                    distanceText: _formattedDistance,
                    durationText: _formattedDuration,
                    finalPaymentText: fareStr,
                  ),
                ),
              );
            }
          } else if (event == 'booking.drop_requested' ||
              event == 'booking.drop_request' ||
              event == 'trip.drop_requested' ||
              event == 'trip.drop_request' ||
              event == 'booking.early_drop_requested' ||
              event == 'drop_requested') {
            final requestedBy = (data['requested_by'] ?? eventData['requested_by'] ?? data['requestedBy'] ?? eventData['requestedBy'])?.toString() ?? '';
            // Only show popup to customer if requested by RIDER (not by CUSTOMER themselves)
            if (requestedBy.toUpperCase() != 'CUSTOMER') {
              final reason = (data['reason'] ?? data['drop_reason'] ?? eventData['reason'] ?? eventData['drop_reason'] ?? 'Early drop requested by driver').toString();
              _showRiderDropRequestModal(reason: reason);
            }
          } else if (event == 'booking.drop_rejected') {
            final reason = (data['reason'] ?? 'Rider declined early drop request').toString();
            _dropCountdownTimer?.cancel();
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Drop Request Declined: $reason'),
                  backgroundColor: const Color(0xFFEF4444),
                  duration: const Duration(seconds: 4),
                ),
              );
            }
          } else if (event == 'booking.drop_approved' ||
              event == 'booking.drop_accepted' ||
              event == 'trip.drop_approved' ||
              event == 'trip.drop_accepted') {
            _onRiderApprovedDrop(data);
          } else if (event == 'booking.cancelled' ||
              event == 'booking.rider_cancelled' ||
              event == 'booking.customer_cancelled' ||
              event == 'ride.cancelled' ||
              event == 'booking.cancel_success') {
            final reason = data['reason']?.toString() ?? '';
            final cancelledBy = data['cancelled_by']?.toString() ?? '';
            final displayMsg = cancelledBy.toUpperCase() == 'CUSTOMER'
                ? 'Trip cancelled successfully.'
                : (reason.isNotEmpty ? reason : 'Your ride was cancelled by the rider.');

            if (sl.isRegistered<ActiveBookingService>()) {
              sl<ActiveBookingService>().clearActiveBooking();
            }
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(displayMsg),
                  backgroundColor: const Color(0xFFEF4444),
                  duration: const Duration(seconds: 4),
                ),
              );
              Navigator.of(context).pushAndRemoveUntil(HomePage.route(), (route) => false);
            }
          }
        }
      });
    }
  }

  void _onRiderLocationUpdate(LatLng newPos) {
    if (!mounted) return;
    if (newPos.latitude == 0.0 || newPos.longitude == 0.0) return;

    _lastLocationTime = DateTime.now();
    if (_isLocationStale) {
      setState(() {
        _isLocationStale = false;
      });
    }

    final moveDist = NavigationService.calculateDistanceMeters(_currentVehiclePos, newPos);
    if (moveDist < 1.0) return;

    final double targetRotation = moveDist >= 2.0
        ? _calculateBearing(_currentVehiclePos, newPos)
        : _currentVehicleRotation;

    _animStartPos = _currentVehiclePos;
    _animTargetPos = newPos;
    _animStartRotation = _currentVehicleRotation;
    _animTargetRotation = targetRotation;

    _animController.reset();
    _animController.forward();

    // Slice remaining route points smoothly along road geometry
    if (_routePoints.length > 1) {
      int closestIdx = 0;
      double minDistance = double.infinity;
      for (int i = 0; i < _routePoints.length; i++) {
        final dist = NavigationService.calculateDistanceMeters(newPos, _routePoints[i]);
        if (dist < minDistance) {
          minDistance = dist;
          closestIdx = i;
        }
      }
      if (closestIdx >= 0 && closestIdx < _routePoints.length) {
        final remaining = closestIdx == 0 ? _routePoints.sublist(1) : _routePoints.sublist(closestIdx);
        _routePoints = [newPos, ...remaining];
      }
    }

    // Dynamic distance & duration update
    final targetDest = _phase == TripPhase.inTransit ? widget.dropLatLng : widget.pickupLatLng;
    final remainingDist = NavigationService.calculateDistanceMeters(newPos, targetDest);
    setState(() {
      _remainingMetersVal = remainingDist;
      _remainingSecondsVal = max(60.0, remainingDist / 9.72); // ~35 km/h avg speed
    });

    if (_routeSteps.isNotEmpty) {
      final navService = sl.isRegistered<NavigationService>()
          ? sl<NavigationService>()
          : NavigationService(dio: _dio);
      final nextStep = navService.getCurrentStep(newPos, _routeSteps);
      if (nextStep != null) {
        _currentStep = nextStep;
        _distanceToStepMeters = NavigationService.calculateDistanceMeters(newPos, nextStep.location);
      }
    }

    // Off-route detection (> 50 meters from route geometry)
    double minDistanceToRoute = double.infinity;
    for (final pt in _routePoints) {
      final d = NavigationService.calculateDistanceMeters(newPos, pt);
      if (d < minDistanceToRoute) minDistanceToRoute = d;
    }

    bool shouldRefetch = minDistanceToRoute > 50.0;
    if (_lastRouteFetchTime != null) {
      final secondsSinceLastFetch = DateTime.now().difference(_lastRouteFetchTime!).inSeconds;
      if (secondsSinceLastFetch < 8 && !shouldRefetch) {
        shouldRefetch = false;
      }
    }

    if (shouldRefetch) {
      _fetchRealRoadRoute(from: newPos, to: targetDest);
    }
  }

  Future<BitmapDescriptor?> _loadAssetAsBitmapDescriptor(String assetPath, {int targetWidth = 72}) async {
    try {
      final ByteData data = await rootBundle.load(assetPath);
      final Codec codec = await instantiateImageCodec(
        data.buffer.asUint8List(),
        targetWidth: targetWidth,
      );
      final FrameInfo fi = await codec.getNextFrame();
      final ByteData? byteData = await fi.image.toByteData(format: ImageByteFormat.png);
      if (byteData != null) {
        return BitmapDescriptor.fromBytes(byteData.buffer.asUint8List());
      }
    } catch (e) {
      debugPrint('[LiveTripTrackingPage] Error loading asset image $assetPath: $e');
    }
    return null;
  }

  Future<void> _loadCustomMarkerIcons() async {
    BitmapDescriptor? pickupIcon = await _loadAssetAsBitmapDescriptor('assets/images/user_marker.png', targetWidth: 160);
    BitmapDescriptor? navCarIcon = await _loadAssetAsBitmapDescriptor('assets/images/nav_car_marker.png', targetWidth: 240);

    pickupIcon ??= await _createPinMarkerIcon(AppColors.primaryBlue, Icons.person_pin_circle_rounded);
    final fallbackCarIcon = await _createPinMarkerIcon(AppColors.primaryBlue, Icons.directions_car_rounded);
    final dropIcon = await _createPinMarkerIcon(const Color(0xFFEF4444), Icons.location_on_rounded);
    final navArrowIcon = await _createNavigationArrowIcon();

    if (mounted) {
      setState(() {
        _pickupMarkerIcon = pickupIcon;
        _carMarkerIcon = navCarIcon ?? fallbackCarIcon;
        if (dropIcon != null) _dropMarkerIcon = dropIcon;
        _navArrowIcon = navCarIcon ?? navArrowIcon ?? fallbackCarIcon;
      });
    }
  }

  Future<BitmapDescriptor?> _createNavigationArrowIcon() async {
    try {
      final PictureRecorder pictureRecorder = PictureRecorder();
      final Canvas canvas = Canvas(pictureRecorder);
      const double size = 220.0;

      final Paint shadowPaint = Paint()
        ..color = const Color(0x40000000)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
      canvas.drawCircle(const Offset(size / 2, size / 2 + 3), size / 2 - 8, shadowPaint);

      final Paint whitePaint = Paint()..color = Colors.white;
      canvas.drawCircle(const Offset(size / 2, size / 2), size / 2 - 8, whitePaint);

      final Paint bluePaint = Paint()..color = AppColors.primaryBlue;
      canvas.drawCircle(const Offset(size / 2, size / 2), size / 2 - 16, bluePaint);

      final Path arrowPath = Path();
      const double center = size / 2;
      arrowPath.moveTo(center, center - 22);
      arrowPath.lineTo(center + 18, center + 16);
      arrowPath.lineTo(center, center + 8);
      arrowPath.lineTo(center - 18, center + 16);
      arrowPath.close();

      final Paint arrowPaint = Paint()..color = Colors.white;
      canvas.drawPath(arrowPath, arrowPaint);

      final img = await pictureRecorder.endRecording().toImage(size.toInt(), size.toInt());
      final data = await img.toByteData(format: ImageByteFormat.png);
      if (data != null) {
        return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
      }
    } catch (e) {
      debugPrint('[LiveTripTrackingPage] Error creating navigation arrow icon: $e');
    }
    return null;
  }

  Future<BitmapDescriptor?> _createPinMarkerIcon(Color color, IconData iconData) async {
    try {
      final PictureRecorder pictureRecorder = PictureRecorder();
      final Canvas canvas = Canvas(pictureRecorder);
      const double size = 200.0;

      final Paint shadowPaint = Paint()
        ..color = const Color(0x33000000)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
      canvas.drawCircle(const Offset(size / 2, size / 2 + 2), size / 2 - 6, shadowPaint);

      final Paint whitePaint = Paint()..color = Colors.white;
      canvas.drawCircle(const Offset(size / 2, size / 2), size / 2 - 6, whitePaint);

      final Paint colorPaint = Paint()..color = color;
      canvas.drawCircle(const Offset(size / 2, size / 2), size / 2 - 12, colorPaint);

      final TextPainter textPainter = TextPainter(textDirection: TextDirection.ltr);
      textPainter.text = TextSpan(
        text: String.fromCharCode(iconData.codePoint),
        style: TextStyle(
          fontSize: 34.0,
          fontFamily: iconData.fontFamily,
          package: iconData.fontPackage,
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
      if (data != null) {
        return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
      }
    } catch (e) {
      debugPrint('[LiveTripTrackingPage] Error creating marker icon: $e');
    }
    return null;
  }

  /// Fetches real road-accurate turn-by-turn geometry points & step maneuvers from OSRM
  Future<void> _fetchRealRoadRoute({LatLng? from, LatLng? to, bool force = false}) async {
    if (_isFetchingRoute && !force) return;

    final startPt = from ?? _currentVehiclePos;
    final endPt = to ?? (_phase == TripPhase.inTransit ? widget.dropLatLng : widget.pickupLatLng);

    final distanceBetween = NavigationService.calculateDistanceMeters(startPt, endPt);
    if (distanceBetween < 15.0) {
      if (mounted) {
        setState(() {
          _remainingMetersVal = 0.0;
          _remainingSecondsVal = 0.0;
          _isRouteUnavailable = false;
        });
      }
      return;
    }

    _isFetchingRoute = true;
    _lastRouteFetchTime = DateTime.now();
    _lastRouteFetchPos = startPt;

    try {
      final navService = sl.isRegistered<NavigationService>()
          ? sl<NavigationService>()
          : NavigationService(dio: _dio);

      final navData = await navService.fetchRouteNavigation(
        start: startPt,
        destination: endPt,
      );

      if (navData.points.isNotEmpty && mounted) {
        setState(() {
          _routePoints = navData.points;
          _routeSteps = navData.steps;
          _isRouteUnavailable = false;
          if (_routePoints.length > 1) {
            _currentVehicleRotation = _calculateBearing(_routePoints[0], _routePoints[1]);
          }
          if (navData.totalDistanceMeters > 0) {
            _remainingMetersVal = navData.totalDistanceMeters;
            _remainingSecondsVal = navData.totalDurationSeconds;
          }
          if (_routeSteps.isNotEmpty) {
            final step = navService.getCurrentStep(_currentVehiclePos, _routeSteps);
            if (step != null) {
              _currentStep = step;
              _distanceToStepMeters = NavigationService.calculateDistanceMeters(_currentVehiclePos, step.location);
            }
          }
        });
      } else if (mounted && _routePoints.isEmpty) {
        setState(() {
          _isRouteUnavailable = true;
        });
      }
    } catch (e) {
      debugPrint('[LiveTripTrackingPage] Failed OSRM route fetch: $e');
      if (mounted && _routePoints.isEmpty) {
        setState(() {
          _isRouteUnavailable = true;
        });
      }
    } finally {
      _isFetchingRoute = false;
    }
  }

  Future<void> _fetchDropoffPreviewRoute() async {
    try {
      final navService = sl.isRegistered<NavigationService>()
          ? sl<NavigationService>()
          : NavigationService(dio: _dio);

      final navData = await navService.fetchRouteNavigation(
        start: widget.pickupLatLng,
        destination: widget.dropLatLng,
      );

      if (navData.points.isNotEmpty && mounted) {
        setState(() {
          _dropoffPreviewRoutePoints = navData.points;
        });
      }
    } catch (e) {
      debugPrint('[LiveTripTrackingPage] Failed dropoff preview route fetch: $e');
    }
  }

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

  /// Calculates camera target offset so navigation arrow is positioned near lower-center of map
  LatLng _calculateHeadingCameraTarget(LatLng vehiclePos, double rotation, double forwardMeters) {
    final rad = rotation * (pi / 180.0);
    final dLat = (forwardMeters / 111320.0) * cos(rad);
    final dLng = (forwardMeters / (111320.0 * cos(vehiclePos.latitude * (pi / 180.0)))) * sin(rad);
    return LatLng(vehiclePos.latitude + dLat, vehiclePos.longitude + dLng);
  }

  /// Fits camera view to show full route and markers with padding
  void _fitMapBounds() {
    if (_mapController == null) return;

    final List<LatLng> allPoints = [
      _currentVehiclePos,
      widget.pickupLatLng,
      widget.dropLatLng,
      ..._routePoints,
    ];

    double minLat = allPoints.first.latitude;
    double maxLat = allPoints.first.latitude;
    double minLng = allPoints.first.longitude;
    double maxLng = allPoints.first.longitude;

    for (final point in allPoints) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    final bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    if (mounted) {
      _isProgrammaticCameraMove = true;
      try {
        _mapController?.animateCamera(
          CameraUpdate.newLatLngBounds(bounds, 70),
        );
      } catch (e) {
        debugPrint('Error animating trip bounds camera: $e');
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    WakelockPlus.disable();
    _customerPositionStreamSubscription?.cancel();
    _animController.dispose();
    _wsSubscription?.cancel();
    _staleTimer?.cancel();
    _dropCountdownTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      debugPrint('[LiveTripTrackingPage] App resumed (from call/background). Reconnecting socket & checking active booking status...');
      if (sl.isRegistered<CustomerWSController>()) {
        sl<CustomerWSController>().reconnectIfNeeded();
      }
      _checkActiveBookingStatusHttp();
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final cleanNum = phoneNumber.replaceAll(' ', '');
    final uri = Uri.parse('tel:$cleanNum');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Error launching phone call to $cleanNum: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Dialing $phoneNumber...'),
            backgroundColor: AppColors.primaryBlue,
          ),
        );
      }
    }
  }

  void _showEmergencyCallModal(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (modalCtx) {
        return Container(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 16,
            bottom: MediaQuery.of(modalCtx).padding.bottom + 16,
          ),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardBgDark : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 38,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.accentOrange.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.phone_in_talk_rounded, color: AppColors.accentOrange, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Emergency & Support Calls',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
                            ),
                          ),
                          Text(
                            'Select helpline or emergency contact:',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 12),

                // Option 1: Admin Helpline (63665 57766)
                _buildCallOptionTile(
                  context: modalCtx,
                  isDark: isDark,
                  icon: Icons.admin_panel_settings_rounded,
                  iconBgColor: AppColors.primaryBlue,
                  title: 'StriveWheels Admin Support',
                  subtitle: '24/7 Support: 63665 57766',
                  phoneNumber: '63665 57766',
                ),

                // Option 2: Police (100)
                _buildCallOptionTile(
                  context: modalCtx,
                  isDark: isDark,
                  icon: Icons.local_police_rounded,
                  iconBgColor: const Color(0xFFEF4444),
                  title: 'Police Emergency (100)',
                  subtitle: 'Immediate Police Assistance',
                  phoneNumber: '100',
                ),

                // Option 3: Ambulance (108)
                _buildCallOptionTile(
                  context: modalCtx,
                  isDark: isDark,
                  icon: Icons.medical_services_rounded,
                  iconBgColor: const Color(0xFFF97316),
                  title: 'Ambulance & Medical (108)',
                  subtitle: 'Medical Emergency Services',
                  phoneNumber: '108',
                ),

                // Option 4: Health Helpline (104)
                _buildCallOptionTile(
                  context: modalCtx,
                  isDark: isDark,
                  icon: Icons.health_and_safety_rounded,
                  iconBgColor: const Color(0xFF06B6D4),
                  title: 'Health & Safety Helpline (104)',
                  subtitle: 'Medical Advice & Safety',
                  phoneNumber: '104',
                ),

                // Option 5: Call Driver
                _buildCallOptionTile(
                  context: modalCtx,
                  isDark: isDark,
                  icon: Icons.person_rounded,
                  iconBgColor: AppColors.primaryBlue,
                  title: 'Call Driver (${widget.driverName})',
                  subtitle: widget.vehicleInfo,
                  phoneNumber: '63665 57766',
                ),

                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCallOptionTile({
    required BuildContext context,
    required bool isDark,
    required IconData icon,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    required String phoneNumber,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
          _makePhoneCall(phoneNumber);
        },
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconBgColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconBgColor, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.call_rounded, color: Colors.white, size: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDropRequestDialog(BuildContext context) {
    if (_isDropRequested) {
      _showPendingDropDialog(context);
      return;
    }

    final reasons = [
      'Reached destination early',
      'Emergency / Need to stop here',
      'Traffic / Route change',
      'Other reason',
    ];
    String tempReason = _selectedDropReason;

    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              const Icon(Icons.pin_drop_rounded, color: AppColors.accentOrange, size: 26),
              const SizedBox(width: 8),
              Text(
                'Request Drop Off',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select reason for requesting drop off here:',
                style: GoogleFonts.poppins(fontSize: 13, color: const Color(0xFF64748B)),
              ),
              const SizedBox(height: 12),
              ...reasons.map((r) => RadioListTile<String>(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: Text(r, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500)),
                    value: r,
                    groupValue: tempReason,
                    activeColor: AppColors.accentOrange,
                    onChanged: (val) {
                      if (val != null) {
                        setDialogState(() => tempReason = val);
                      }
                    },
                  )),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogCtx).pop(),
              child: Text('Cancel', style: GoogleFonts.poppins(color: const Color(0xFF64748B))),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogCtx).pop();
                _submitDropRequest(tempReason);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentOrange,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(
                'Send Request',
                style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitDropRequest(String reason) {
    setState(() {
      _selectedDropReason = reason;
      _isDropRequested = true;
      _dropCountdownSeconds = 30;
    });

    final bookingId = _effectiveBookingId;

    if (sl.isRegistered<CustomerWSController>()) {
      sl<CustomerWSController>().requestDrop(
        bookingId: bookingId,
        reason: reason,
        lat: _currentVehiclePos.latitude,
        lng: _currentVehiclePos.longitude,
      );
    }

    _dropCountdownTimer?.cancel();
    _dropCountdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_dropCountdownSeconds > 1) {
        setState(() {
          _dropCountdownSeconds--;
        });
      } else {
        timer.cancel();
        _onAutoApproveDrop();
      }
    });

    _showPendingDropDialog(context);
  }

  void _showPendingDropDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2.5, color: AppColors.accentOrange),
            ),
            const SizedBox(width: 12),
            Text(
              'Waiting Rider Approval',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Drop off request sent to rider (${widget.driverName}).\nIf no response within 30 seconds, it will be automatically approved.',
              style: GoogleFonts.poppins(fontSize: 13, height: 1.4),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7ED),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFED7AA)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.timer_outlined, color: AppColors.accentOrange, size: 20),
                  const SizedBox(width: 8),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'Auto-approving in ${_dropCountdownSeconds}s...',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: const Color(0xFFC2410C),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: Text('Close', style: GoogleFonts.poppins(color: const Color(0xFF64748B))),
          ),
        ],
      ),
    );
  }

  void _onRiderApprovedDrop([Map<String, dynamic>? data]) {
    _dropCountdownTimer?.cancel();
    _staleTimer?.cancel();
    if (!mounted || _hasNavigatedToComplete) return;
    _hasNavigatedToComplete = true;

    if (sl.isRegistered<ActiveBookingService>()) {
      sl<ActiveBookingService>().clearActiveBooking();
    }

    final bookingObj = (data != null && data['booking'] is Map) ? data['booking'] as Map<String, dynamic> : null;
    final fareVal = data?['final_fare'] ?? data?['finalFare'] ?? data?['price'] ?? data?['fare'] ?? data?['final_amount'] ??
        bookingObj?['final_fare'] ?? bookingObj?['estimated_fare'] ?? bookingObj?['finalFare'];
    final double fare = (fareVal is num) ? fareVal.toDouble() : (double.tryParse(fareVal?.toString() ?? '') ?? _savedFareAmount);
    final String fareStr = fare > 0 ? '₹${fare.toStringAsFixed(2)}' : (_savedFareAmount > 0 ? '₹${_savedFareAmount.toStringAsFixed(2)}' : '');

    ScaffoldMessenger.of(context).clearSnackBars();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => JourneyCompletePage(
          driverName: widget.driverName,
          vehicleInfo: widget.vehicleInfo,
          distanceText: _formattedDistance,
          durationText: _formattedDuration,
          finalPaymentText: fareStr,
        ),
      ),
    );
  }

  void _showRiderDropRequestModal({required String reason}) {
    if (_isRiderDropModalShowing) return;
    _isRiderDropModalShowing = true;

    int remainingSeconds = 30;
    Timer? timer;

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            timer ??= Timer.periodic(const Duration(seconds: 1), (t) {
              if (remainingSeconds > 1) {
                setModalState(() {
                  remainingSeconds--;
                });
              } else {
                t.cancel();
                if (Navigator.canPop(ctx)) {
                  Navigator.pop(ctx);
                }
                _isRiderDropModalShowing = false;
                final bookingId = _effectiveBookingId;
                if (sl.isRegistered<CustomerWSController>()) {
                  sl<CustomerWSController>().sendDropApproved(bookingId: bookingId);
                }
                _onRiderApprovedDrop();
              }
            });

            return Container(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 24,
                bottom: MediaQuery.of(ctx).padding.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: Color(0xFFEFF6FF),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.flag_rounded, color: AppColors.primaryBlue, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Driver Drop Request',
                              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Early drop requested by driver',
                              style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.orange.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.timer_outlined, size: 14, color: Colors.orange),
                            const SizedBox(width: 4),
                            Text(
                              '${remainingSeconds}s',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Text(
                      'Reason: "$reason"',
                      style: GoogleFonts.poppins(fontSize: 14, fontStyle: FontStyle.italic, color: const Color(0xFF334155)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Auto-accepting in ${remainingSeconds}s if no action taken.',
                    style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            timer?.cancel();
                            if (Navigator.canPop(ctx)) {
                              Navigator.pop(ctx);
                            }
                            _isRiderDropModalShowing = false;
                            final bookingId = _effectiveBookingId;
                            if (sl.isRegistered<CustomerWSController>()) {
                              sl<CustomerWSController>().sendDropRejected(
                                bookingId: bookingId,
                                reason: 'Customer declined early drop request',
                              );
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFCBD5E1)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Text(
                            'Decline',
                            style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: const Color(0xFF64748B)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            timer?.cancel();
                            if (Navigator.canPop(ctx)) {
                              Navigator.pop(ctx);
                            }
                            _isRiderDropModalShowing = false;
                            final bookingId = _effectiveBookingId;
                            if (sl.isRegistered<CustomerWSController>()) {
                              sl<CustomerWSController>().sendDropApproved(
                                bookingId: bookingId,
                                lat: _currentVehiclePos.latitude,
                                lng: _currentVehiclePos.longitude,
                              );
                            }
                            _onRiderApprovedDrop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF10B981),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Text(
                            'Accept (${remainingSeconds}s)',
                            style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((_) {
      timer?.cancel();
      _isRiderDropModalShowing = false;
    });
  }

  void _onAutoApproveDrop() {
    _dropCountdownTimer?.cancel();
    _staleTimer?.cancel();
    if (!mounted || _hasNavigatedToComplete) return;
    _hasNavigatedToComplete = true;

    final bookingId = _effectiveBookingId;

    if (sl.isRegistered<CustomerWSController>()) {
      sl<CustomerWSController>().sendDropApproved(
        bookingId: bookingId,
        lat: _currentVehiclePos.latitude,
        lng: _currentVehiclePos.longitude,
      );
    }

    if (sl.isRegistered<ActiveBookingService>()) {
      sl<ActiveBookingService>().clearActiveBooking();
    }

    ScaffoldMessenger.of(context).clearSnackBars();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => JourneyCompletePage(
          driverName: widget.driverName,
          vehicleInfo: widget.vehicleInfo,
          distanceText: _formattedDistance,
          durationText: _formattedDuration,
        ),
      ),
    );
  }

  String get _formattedDuration {
    if (_phase == TripPhase.driverArrived) return 'Arrived';
    if (_phase == TripPhase.tripCompleted) return 'Completed';
    return NavigationService.formatMetricDuration(_remainingSecondsVal);
  }

  String get _formattedDistance {
    if (_phase == TripPhase.driverArrived) return '0 m';
    if (_phase == TripPhase.tripCompleted) return '0 m';
    return NavigationService.formatMetricDistance(_remainingMetersVal);
  }

  String get _formattedArrivalTime {
    if (_phase == TripPhase.driverArrived) return 'Now';
    if (_phase == TripPhase.tripCompleted) return 'Done';
    return NavigationService.formatLocalArrivalTime(_remainingSecondsVal);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.onboardingBgDark : const Color(0xFFF8FAFC),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: AppBar(
          backgroundColor: isDark ? AppColors.onboardingBgDark : Colors.white,
          elevation: 0.5,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_rounded,
              color: isDark ? AppColors.textPrimaryDark : AppColors.primaryBlue,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Row(
            children: [
              Text(
                AppStrings.appName,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBlue,
                  fontSize: 18,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.accentOrange.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'LIVE',
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.accentOrange,
                  ),
                ),
              ),
            ],
          ),
          centerTitle: false,
          actions: const [],
        ),
      ),
      body: Stack(
        children: [
          // 1. Full Screen Map View
          AppMapWidget(
            initialCameraPosition: CameraPosition(
              target: widget.pickupLatLng,
              zoom: 18.0,
              tilt: 60.0,
            ),
            buildingsEnabled: true,
            tiltGesturesEnabled: true,
            rotateGesturesEnabled: true,
            onMapCreated: (controller) {
              _mapController = controller;
              if (_isFollowingVehicle && mounted) {
                final targetCamPos = _calculateHeadingCameraTarget(
                  _currentVehiclePos,
                  _currentVehicleRotation,
                  25.0,
                );
                _isProgrammaticCameraMove = true;
                try {
                  _mapController?.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                        target: targetCamPos,
                        zoom: 18.0,
                        tilt: _is3DView ? 60.0 : 0.0,
                        bearing: _currentVehicleRotation,
                      ),
                    ),
                  );
                } catch (e) {
                  debugPrint('Error animating camera in onMapCreated: $e');
                }
              } else {
                _fitMapBounds();
              }
            },
            onCameraMoveStarted: () {
              if (_isProgrammaticCameraMove) {
                _isProgrammaticCameraMove = false;
              } else if (_isFollowingVehicle) {
                setState(() {
                  _isFollowingVehicle = false;
                });
              }
            },
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
            polylines: {
              if (_routePoints.isNotEmpty)
                Polyline(
                  polylineId: const PolylineId('street_route'),
                  points: _routePoints,
                  color: AppColors.primaryBlue,
                  width: 6,
                  jointType: JointType.round,
                  startCap: Cap.roundCap,
                  endCap: Cap.roundCap,
                ),
            },
            markers: {
              // PRE-PICKUP: Customer Pickup Pin
              if (_phase != TripPhase.inTransit)
                Marker(
                  markerId: const MarkerId('customer_marker'),
                  position: widget.pickupLatLng,
                  icon: _pickupMarkerIcon ??
                      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
                  infoWindow: const InfoWindow(title: 'Pickup Location'),
                ),
              // PRE-PICKUP: Approaching Rider Vehicle Marker
              if (_phase != TripPhase.inTransit)
                Marker(
                  markerId: const MarkerId('rider_vehicle'),
                  position: _currentVehiclePos,
                  rotation: _currentVehicleRotation,
                  anchor: const Offset(0.5, 0.5),
                  flat: true,
                  icon: _carMarkerIcon ??
                      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
                  infoWindow: InfoWindow(
                    title: widget.driverName,
                    snippet: widget.vehicleInfo,
                  ),
                ),
              // POST-OTP CONFIRMED TRIP: ONE Active Trip Navigation Arrow Cursor
              if (_phase == TripPhase.inTransit)
                Marker(
                  markerId: const MarkerId('active_trip_arrow'),
                  position: _currentVehiclePos,
                  rotation: _currentVehicleRotation,
                  anchor: const Offset(0.5, 0.5),
                  flat: true,
                  icon: _navArrowIcon ??
                      _carMarkerIcon ??
                      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
                  infoWindow: InfoWindow(
                    title: 'En Route to Destination',
                    snippet: widget.driverName,
                  ),
                ),
              // Fixed Destination Dropoff Marker Pin
              Marker(
                markerId: const MarkerId('drop'),
                position: widget.dropLatLng,
                icon: _dropMarkerIcon ??
                    BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                infoWindow: const InfoWindow(title: 'Destination'),
              ),
            },
          ),

          // 2. Next-Turn Maneuver Guidance Top Banner (Compact Dark Green Card)
          Positioned(
            top: 10,
            left: 12,
            right: 12,
            child: ManeuverBannerWidget(
              currentStep: _currentStep,
              distanceToStepMeters: _distanceToStepMeters,
              isMuted: _isMuted,
              onToggleMute: () {
                setState(() => _isMuted = !_isMuted);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(_isMuted ? 'Voice guidance muted' : 'Voice guidance enabled'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              onOverviewTap: () {
                setState(() => _isFollowingVehicle = false);
                _fitMapBounds();
              },
            ),
          ),

          // 3. Stale Location Warning Banner
          if (_isLocationStale)
            Positioned(
              top: 90,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFF59E0B)),
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFD97706)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Location updating...',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF92400E),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // 4. Route Retrying Status Banner
          if (_isRouteUnavailable)
            Positioned(
              top: 90,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primaryBlue),
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryBlue),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Route loading...',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // 5. Right Control Stack (Mute, 3D/2D Toggle, Recenter, Route Overview)
          Positioned(
            right: 16,
            bottom: _isSheetMinimized ? 155 : 350,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Voice Guidance Mute Toggle
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: _isMuted ? (isDark ? AppColors.cardBgDark : Colors.white) : AppColors.primaryBlue,
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
                    tooltip: 'Toggle Voice Guidance',
                    icon: Icon(
                      _isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                      color: _isMuted ? (isDark ? AppColors.textPrimaryDark : const Color(0xFF1E293B)) : Colors.white,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() => _isMuted = !_isMuted);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(_isMuted ? 'Voice guidance muted' : 'Voice guidance enabled'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),

                // 3D Map Perspective Toggle Button
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: _is3DView ? AppColors.primaryBlue : (isDark ? AppColors.cardBgDark : Colors.white),
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
                    tooltip: 'Toggle 3D Map View',
                    icon: Icon(
                      Icons.threed_rotation_rounded,
                      color: _is3DView ? Colors.white : (isDark ? AppColors.textPrimaryDark : const Color(0xFF1E293B)),
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _is3DView = !_is3DView;
                        _isFollowingVehicle = true;
                      });
                      final targetCamPos = _calculateHeadingCameraTarget(
                        _currentVehiclePos,
                        _currentVehicleRotation,
                        25.0,
                      );
                      _isProgrammaticCameraMove = true;
                      try {
                        _mapController?.animateCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(
                              target: targetCamPos,
                              zoom: 18.0,
                              tilt: _is3DView ? 60.0 : 0.0,
                              bearing: _currentVehicleRotation,
                            ),
                          ),
                        );
                      } catch (e) {
                        debugPrint('Error animating 3D camera: $e');
                      }
                    },
                  ),
                ),
                const SizedBox(height: 10),

                // Recenter / Follow Driver Button
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: _isFollowingVehicle ? AppColors.primaryBlue : (isDark ? AppColors.cardBgDark : Colors.white),
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
                    tooltip: 'Recenter Camera',
                    icon: Icon(
                      Icons.my_location_rounded,
                      color: _isFollowingVehicle ? Colors.white : (isDark ? AppColors.textPrimaryDark : const Color(0xFF1E293B)),
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() => _isFollowingVehicle = true);
                      final targetCamPos = _calculateHeadingCameraTarget(
                        _currentVehiclePos,
                        _currentVehicleRotation,
                        25.0,
                      );
                      _isProgrammaticCameraMove = true;
                      try {
                        _mapController?.animateCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(
                              target: targetCamPos,
                              zoom: 18.0,
                              tilt: _is3DView ? 60.0 : 0.0,
                              bearing: _currentVehicleRotation,
                            ),
                          ),
                        );
                      } catch (e) {
                        debugPrint('Error animating recenter camera: $e');
                      }
                    },
                  ),
                ),
                const SizedBox(height: 10),

                // Route Overview Button
                Container(
                  width: 44,
                  height: 44,
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
                    tooltip: 'Route Overview',
                    icon: Icon(
                      Icons.map_rounded,
                      color: isDark ? AppColors.textPrimaryDark : const Color(0xFF1E293B),
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() => _isFollowingVehicle = false);
                      _fitMapBounds();
                    },
                  ),
                ),
              ],
            ),
          ),

          // 6. Minimizable & Expandable Bottom Popup Card with Rider Details, Drop-off Info & Action Buttons
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 8,
                bottom: max(16.0, MediaQuery.of(context).padding.bottom ),
              ),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardBgDark : Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.12),
                    blurRadius: 18,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Drag Handle & Minimize/Expand Toggle Bar
                      GestureDetector(
                        onTap: () => setState(() {
                          _isSheetMinimized = !_isSheetMinimized;
                        }),
                        behavior: HitTestBehavior.opaque,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Column(
                            children: [
                              Container(
                                width: 38,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),

                      // MINIMIZED (COLLAPSED) VIEW
                      if (_isSheetMinimized)
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () => setState(() {
                                _isSheetMinimized = false;
                              }),
                              borderRadius: BorderRadius.circular(12),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 18,
                                      backgroundColor: AppColors.primaryBlue.withValues(alpha: 0.1),
                                      child: Text(
                                        widget.driverName.isNotEmpty ? widget.driverName[0] : 'A',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primaryBlue,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.driverName,
                                            style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            '${_formattedDuration} • ${_formattedDistance} • Arrival ${_formattedArrivalTime}',
                                            style: GoogleFonts.poppins(
                                              fontSize: 10.5,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.primaryBlue,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    IconButton(
                                      constraints: const BoxConstraints(),
                                      padding: EdgeInsets.zero,
                                      icon: Container(
                                        padding: const EdgeInsets.all(7),
                                        decoration: const BoxDecoration(
                                          color: AppColors.accentOrange,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(Icons.phone_rounded, color: Colors.white, size: 15),
                                      ),
                                      onPressed: () => _showEmergencyCallModal(context),
                                    ),
                                    const SizedBox(width: 6),
                                    IconButton(
                                      constraints: const BoxConstraints(),
                                      padding: EdgeInsets.zero,
                                      icon: Container(
                                        padding: const EdgeInsets.all(7),
                                        decoration: const BoxDecoration(
                                          color: AppColors.primaryBlue,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(Icons.chat_bubble_rounded, color: Colors.white, size: 15),
                                      ),
                                      onPressed: () {
                                        final bIdStr = widget.bookingId ?? (sl.isRegistered<ActiveBookingService>() ? sl<ActiveBookingService>().activeBooking?.bookingId : null) ?? '';
                                        final bookingIdInt = int.tryParse(bIdStr.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) => RideChatPage(
                                              bookingId: bookingIdInt,
                                              currentUserId: 1,
                                              counterpartyName: widget.driverName,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    const SizedBox(width: 6),
                                    IconButton(
                                      constraints: const BoxConstraints(),
                                      padding: EdgeInsets.zero,
                                      icon: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.keyboard_arrow_up_rounded,
                                          color: isDark ? AppColors.textPrimaryDark : const Color(0xFF475569),
                                          size: 20,
                                        ),
                                      ),
                                      onPressed: () => setState(() {
                                        _isSheetMinimized = false;
                                      }),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Action buttons in Minimized View
                            if (_phase != TripPhase.inTransit) ...[
                              if (widget.startOtp != null && widget.startOtp!.isNotEmpty) ...[
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  margin: const EdgeInsets.only(bottom: 8),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryBlue.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: AppColors.primaryBlue.withValues(alpha: 0.3)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Share OTP with Driver:',
                                        style: GoogleFonts.poppins(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primaryBlue,
                                        ),
                                      ),
                                      Text(
                                        widget.startOtp!,
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 2.0,
                                          color: AppColors.primaryBlue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              SizedBox(
                                width: double.infinity,
                                height: 44,
                                child: OutlinedButton(
                                  onPressed: () => _showCancelRideDialog(context),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: const Color(0xFFEF4444),
                                    side: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  child: Text(
                                    'Cancel Ride',
                                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13),
                                  ),
                                ),
                              ),
                            ] else ...[
                              SizedBox(
                                width: double.infinity,
                                height: 44,
                                child: ElevatedButton(
                                  onPressed: () => _showDropRequestDialog(context),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _isDropRequested ? const Color(0xFFD97706) : AppColors.accentOrange,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        _isDropRequested ? Icons.timer_outlined : Icons.pin_drop_rounded,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        _isDropRequested
                                            ? 'Waiting Rider Approval (${_dropCountdownSeconds}s)'
                                            : 'Request Drop Location',
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),

                      // EXPANDED VIEW
                      if (!_isSheetMinimized) ...[
                        // Rider Header Row: Avatar, Name, Rating, Vehicle, Call, Chat, Minimize button
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: AppColors.primaryBlue.withValues(alpha: 0.1),
                              child: Text(
                                widget.driverName.isNotEmpty ? widget.driverName[0] : 'A',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryBlue,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.driverName,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 1),
                                  Row(
                                    children: [
                                      const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 14),
                                      const SizedBox(width: 3),
                                      Text(
                                        widget.driverRating.toStringAsFixed(1),
                                        style: GoogleFonts.poppins(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: isDark ? AppColors.textSecondaryDark : const Color(0xFF475569),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          widget.vehicleInfo,
                                          style: GoogleFonts.poppins(
                                            fontSize: 10,
                                            color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              constraints: const BoxConstraints(),
                              padding: EdgeInsets.zero,
                              icon: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: AppColors.accentOrange,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.phone_rounded, color: Colors.white, size: 16),
                              ),
                              onPressed: () => _showEmergencyCallModal(context),
                            ),
                            const SizedBox(width: 6),
                            IconButton(
                              constraints: const BoxConstraints(),
                              padding: EdgeInsets.zero,
                              icon: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: AppColors.primaryBlue,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.chat_bubble_rounded, color: Colors.white, size: 16),
                              ),
                              onPressed: () {
                                final bIdStr = widget.bookingId ?? (sl.isRegistered<ActiveBookingService>() ? sl<ActiveBookingService>().activeBooking?.bookingId : null) ?? '';
                                final bookingIdInt = int.tryParse(bIdStr.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => RideChatPage(
                                      bookingId: bookingIdInt,
                                      currentUserId: 1,
                                      counterpartyName: widget.driverName,
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 4),
                            IconButton(
                              constraints: const BoxConstraints(),
                              padding: EdgeInsets.zero,
                              icon: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: isDark ? AppColors.textPrimaryDark : const Color(0xFF64748B),
                                  size: 20,
                                ),
                              ),
                              onPressed: () => setState(() {
                                _isSheetMinimized = true;
                              }),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),
                        const Divider(height: 1),
                        const SizedBox(height: 8),

                        // Compact Stats Bar: Duration | Metric Distance | Arrival Time
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // 1. Duration
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'TRAVEL TIME',
                                  style: GoogleFonts.poppins(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                    color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
                                  ),
                                ),
                                const SizedBox(height: 1),
                                Text(
                                  _formattedDuration,
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
                                  ),
                                ),
                              ],
                            ),
                            Container(width: 1, height: 22, color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                            // 2. Metric Distance
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'DISTANCE',
                                  style: GoogleFonts.poppins(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                    color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
                                  ),
                                ),
                                const SizedBox(height: 1),
                                Text(
                                  _formattedDistance,
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryBlue,
                                  ),
                                ),
                              ],
                            ),
                            Container(width: 1, height: 22, color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                            // 3. Arrival Time
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'ARRIVAL TIME',
                                  style: GoogleFonts.poppins(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                    color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
                                  ),
                                ),
                                const SizedBox(height: 1),
                                Text(
                                  _formattedArrivalTime,
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // Drop-off Destination Address Row
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.location_on_rounded, color: Color(0xFFEF4444), size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'DROP OFF DESTINATION',
                                      style: GoogleFonts.poppins(
                                        fontSize: 8.5,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                        color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
                                      ),
                                    ),
                                    const SizedBox(height: 1),
                                    Text(
                                      widget.dropAddress,
                                      style: GoogleFonts.poppins(
                                        fontSize: 11.5,
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
                          ),
                        ),

                        // PRE-TRIP START: Pickup OTP & Cancel Ride Button
                        if (_phase != TripPhase.inTransit) ...[
                          if (widget.startOtp != null) ...[
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.primaryBlue.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppColors.primaryBlue.withValues(alpha: 0.3)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Pickup OTP for Rider:',
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primaryBlue,
                                    ),
                                  ),
                                  Text(
                                    widget.startOtp!,
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 2.0,
                                      color: AppColors.primaryBlue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: OutlinedButton(
                              onPressed: () => _showCancelRideDialog(context),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFFEF4444),
                                side: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
                                padding: const EdgeInsets.symmetric(horizontal: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.cancel_outlined, size: 18),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Cancel Ride',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],

                        // POST-TRIP START: Request Drop Location Button
                        if (_phase == TripPhase.inTransit) ...[
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () => _showDropRequestDialog(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _isDropRequested ? const Color(0xFFD97706) : AppColors.accentOrange,
                                padding: const EdgeInsets.symmetric(horizontal: 14),
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    _isDropRequested ? Icons.timer_outlined : Icons.pin_drop_rounded,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _isDropRequested
                                        ? 'Waiting Rider Approval (${_dropCountdownSeconds}s)'
                                        : 'Request Drop Location',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: HomeBottomNavBar(
        selectedIndex: 0,
        onTabSelected: (index) {
          if (index == 0) {
            Navigator.of(context).pushAndRemoveUntil(HomePage.route(), (route) => false);
          }
        },
      ),
    );
  }
}
