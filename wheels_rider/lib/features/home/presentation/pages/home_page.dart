import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/network/api_endpoints.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../../../trips/presentation/pages/trips_page.dart';
import '../../../earnings/presentation/pages/earnings_page.dart';
import '../../../settings/presentation/pages/settings_page.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../../../../core/di/injection_container.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../../../profile/presentation/bloc/profile_event.dart';
import '../../../profile/presentation/bloc/profile_state.dart';
import '../../../profile/presentation/pages/profile_view_page.dart';
import '../../../profile/domain/entities/profile_entity.dart';
import '../bloc/booking_bloc.dart';
import '../bloc/booking_event.dart';
import '../bloc/booking_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../chat/presentation/pages/ride_chat_page.dart';
import '../../../trips/presentation/pages/active_trip_page.dart';
import '../../domain/entities/ride_request_entity.dart';
import '../../data/models/ride_request_model.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/websocket_client.dart';
import '../../../../core/services/navigation_service.dart';
import '../../../../core/services/ride_ringtone_service.dart';
import '../widgets/availability_dialog.dart';
import '../widgets/maneuver_banner_widget.dart';
import '../widgets/navigation_bottom_panel_widget.dart';
import '../widgets/moving_car.dart';
import '../../../../core/services/live_journey_notification_service.dart';
import '../../../trips/presentation/pages/trip_payment_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  int _currentIndex = 0;
  bool _isOnDuty = true;
  String _rideType = 'Self'; // 'Corporate' or 'Self'
  // ignore: unused_field
  List<DateTime> _corporateSelectedDates = [];
  bool _isRideRequestMinimized = false;
  bool _hasActiveRideRequest = false;
  bool _isTripAccepted = false;
  /// True once the rider verifies OTP — unlocks pickup→drop route on map
  bool _isTripStarted = false;

  int? _driverId;
  String _userToken = '';
  Timer? _locationTimer;
  Timer? _riderHttpCheckTimer;
  RideRequestEntity? _currentRideRequest;
  StreamSubscription<Map<String, dynamic>>? _wsDropSubscription;
  bool _isCustomerDropModalShowing = false;

  GoogleMapController? _mapController;

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(37.7800, -122.4050),
    zoom: 14.5,
  );

  late final HomeBloc _homeBloc;
  late final ProfileBloc _profileBloc;
  late final BookingBloc _bookingBloc;
  late final NavigationService _navigationService;
  late final RideRingtoneService _ringtoneService;

  List<LatLng> _navigationPolylinePoints = [];
  // ignore: unused_field
  List<NavigationStep> _navigationSteps = [];
  NavigationStep? _currentManeuverStep;
  double _distanceToStepMeters = 0.0;
  double _remainingDistanceKm = 0.0;
  int _remainingDurationMins = 0;
  String _etaTimeString = '';
  bool _isNavMuted = false;
  bool _isManualPan = false;
  bool _isLoadingAction = false;
  bool _isDropRequestPending = false;
  bool _isLocationPermissionGranted = false;
  
  BitmapDescriptor? _customMarker;
  LatLng? _currentLatLng;
  final TextEditingController _dropReasonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _homeBloc = sl<HomeBloc>();
    _profileBloc = sl<ProfileBloc>()..add(GetProfileEvent());
    _bookingBloc = sl<BookingBloc>();
    _navigationService = sl<NavigationService>();
    _ringtoneService = sl<RideRingtoneService>();
    _loadCustomMarker();
    _startLocationTracking();
    _restoreActiveRideState();
    _setupDropRequestWebSocketListener();
    _startActiveRideHttpPolling();
    _loadSavedRideTypeAndSchedule();
  }

  Future<void> _loadSavedRideTypeAndSchedule() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedRideType = prefs.getString('selected_ride_type');
      final savedDateStrings = prefs.getStringList('corporate_selected_dates');

      List<DateTime> parsedDates = [];
      if (savedDateStrings != null && savedDateStrings.isNotEmpty) {
        for (final ds in savedDateStrings) {
          try {
            final parsed = DateTime.parse(ds);
            parsedDates.add(DateTime(parsed.year, parsed.month, parsed.day));
          } catch (_) {}
        }
      }

      if (mounted) {
        setState(() {
          if (savedRideType != null && (savedRideType == 'Corporate' || savedRideType == 'Self')) {
            _rideType = savedRideType;
          }
          if (parsedDates.isNotEmpty) {
            _corporateSelectedDates = parsedDates;
          }
        });

        final initialMode = _rideType == 'Corporate' ? 'CORPORATE' : 'NORMAL';
        _homeBloc.add(HomeEvent.updateAvailability(
          availabilityMode: initialMode,
          isOnline: _isOnDuty,
          selectedDates: _corporateSelectedDates.isNotEmpty ? _corporateSelectedDates : null,
        ));
      }
    } catch (_) {
      final initialMode = _rideType == 'Corporate' ? 'CORPORATE' : 'NORMAL';
      _homeBloc.add(HomeEvent.updateAvailability(
        availabilityMode: initialMode,
        isOnline: _isOnDuty,
      ));
    }
  }

  void _dismissRideRequestPopup({String? reason, int? bookingId}) {
    final bId = bookingId ?? _currentRideRequest?.id;
    debugPrint('[HomePage] Auto-disposing ride request popup for booking: $bId (reason: $reason)');
    _ringtoneService.stopCallingRingtone();
    _clearActiveRideState();
    _bookingBloc.add(RideCancelledEvent(reason: reason ?? 'Ride cancelled by customer'));
    if (mounted) {
      setState(() {
        _hasActiveRideRequest = false;
        _isRideRequestMinimized = false;
        _isTripAccepted = false;
        _currentRideRequest = null;
        _isTripStarted = false;
        _isDropRequestPending = false;
        _navigationPolylinePoints.clear();
      });
    }
  }

  void _startActiveRideHttpPolling() {
    _riderHttpCheckTimer?.cancel();
    _riderHttpCheckTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      _checkActiveRideStatusHttp();
    });
  }

  void _stopActiveRideHttpPolling() {
    _riderHttpCheckTimer?.cancel();
    _riderHttpCheckTimer = null;
  }

  Future<void> _checkActiveRideStatusHttp() async {
    if (!mounted || _currentRideRequest == null) return;
    final bookingId = _currentRideRequest!.id;
    if (bookingId == 0) return;

    try {
      final apiClient = sl<ApiClient>();
      final response = await apiClient.get('${ApiEndpoints.baseUrl}/bookings/$bookingId');
      if (!mounted) return;
      if (response.statusCode == 200 && response.data != null) {
        final Map<String, dynamic> data = response.data is Map<String, dynamic>
            ? response.data
            : Map<String, dynamic>.from(response.data as Map);
        final bookingData = data['booking'] is Map
            ? Map<String, dynamic>.from(data['booking'] as Map)
            : (data['data'] is Map ? Map<String, dynamic>.from(data['data'] as Map) : data);

        final status = (bookingData['status'] ?? data['status'])?.toString().toUpperCase() ?? '';
        final isDropRequested = (bookingData['is_drop_requested'] == true || data['is_drop_requested'] == true);
        final isDropAccepted = (bookingData['is_drop_accepted'] == true || data['is_drop_accepted'] == true);
        final requestedBy = (bookingData['requested_by'] ?? data['requested_by'] ?? bookingData['requestedBy'] ?? data['requestedBy'])?.toString().toUpperCase() ?? '';

        final isCancelled = status.contains('CANCEL') ||
            status == 'EXPIRED' ||
            status == 'TIMEOUT' ||
            status == 'REJECTED';

        if (isCancelled) {
          debugPrint('[HomePage] HTTP check detected booking $bookingId is $status. Auto-disposing popup.');
          _dismissRideRequestPopup(
            reason: (bookingData['cancellation_reason'] ?? 'Ride cancelled by customer').toString(),
            bookingId: bookingId,
          );
        } else if (isDropAccepted || status == 'COMPLETED') {
          _stopActiveRideHttpPolling();
          setState(() => _isDropRequestPending = false);
          _navigateToPaymentScreen(bookingId: bookingId);
        } else if (isDropRequested && requestedBy != 'RIDER' && !_isCustomerDropModalShowing) {
          final reason = (bookingData['reason'] ?? data['reason'] ?? 'Early drop requested by customer').toString();
          _showCustomerDropRequestModal(reason: reason, bookingId: bookingId);
        }
      }
    } catch (e) {
      debugPrint('[HomePage] HTTP background booking check notice: $e');
    }
  }

  void _setupDropRequestWebSocketListener() async {
    if (!sl.isRegistered<WebSocketClient>()) return;
    final wsClient = sl<WebSocketClient>();
    await wsClient.ensureConnected();

    _wsDropSubscription?.cancel();
    _wsDropSubscription = wsClient.messageStream.listen((msg) {
      if (!mounted) return;
      final event = msg['event']?.toString() ?? '';
      final Map<String, dynamic> data = (msg['data'] is Map)
          ? Map<String, dynamic>.from(msg['data'] as Map)
          : Map<String, dynamic>.from(msg);

      final requestedBy = (data['requested_by'] ?? msg['requested_by'] ?? data['requestedBy'] ?? msg['requestedBy'] ?? data['user_type'] ?? msg['user_type'])?.toString() ?? '';

      // 1. FAST-PATH CANCELLATION HANDLER (Auto-dispose incoming or active booking popup immediately)
      final notifTitle = (data['notification']?['title'] ?? data['title'] ?? '')?.toString().toLowerCase() ?? '';
      final notifBody = (data['notification']?['body'] ?? data['body'] ?? '')?.toString().toLowerCase() ?? '';
      final isCancelNotif = event == 'notification.new' && (notifTitle.contains('cancel') || notifBody.contains('cancel'));

      final isCancelled =
          event == 'booking.cancelled' ||
          event == 'booking.canceled' ||
          event == 'booking.customer_cancelled' ||
          event == 'booking.rider_cancelled' ||
          event == 'booking.request_cancelled' ||
          event == 'booking.request_expired' ||
          event == 'booking_request_cancelled' ||
          event == 'booking.cancel_success' ||
          event == 'booking.cancel' ||
          event == 'ride.cancelled' ||
          event == 'ride.customer_cancelled' ||
          event == 'ride.canceled' ||
          event == 'cancel_booking' ||
          event == 'cancel_ride' ||
          isCancelNotif ||
          data['status']?.toString().toUpperCase().contains('CANCEL') == true ||
          data['status']?.toString().toUpperCase() == 'EXPIRED';

      if (isCancelled) {
        final reason = (data['reason'] ?? msg['reason'] ?? data['notification']?['body'] ?? 'Ride cancelled by customer').toString();
        final cancelBookingId = data['booking_id'] ?? msg['booking_id'] ?? data['id'] ?? data['booking']?['id'];
        debugPrint('🔔 [HomePage] Auto-disposing ride request on cancellation WS event: $event (booking: $cancelBookingId, reason: $reason)');
        _dismissRideRequestPopup(
          reason: reason,
          bookingId: cancelBookingId is int ? cancelBookingId : int.tryParse(cancelBookingId?.toString() ?? ''),
        );
        return;
      }

      final isNewRideRequest =
          event == 'booking.new_request' ||
          event == 'booking.created' ||
          event == 'booking.requested' ||
          event == 'booking.broadcast' ||
          event == 'booking.near_by' ||
          event == 'booking.searching' ||
          event == 'booking_request' ||
          event == 'ride.created' ||
          event == 'ride.requested' ||
          event == 'ride_request' ||
          event == 'new_ride_request' ||
          (event == 'notification.new' && !isCancelNotif) ||
          event == 'booking.status' ||
          event == 'booking.status_response' ||
          event == 'booking.status_info';

      if (isNewRideRequest) {
        try {
          Map<String, dynamic> bookingMap = {};
          if (data['booking'] is Map) {
            bookingMap = Map<String, dynamic>.from(data['booking'] as Map);
          } else if (data['notification'] is Map) {
            final notif = Map<String, dynamic>.from(data['notification'] as Map);
            if (notif['metadata_json'] is String) {
              try {
                final meta = jsonDecode(notif['metadata_json'] as String);
                if (meta is Map) bookingMap = Map<String, dynamic>.from(meta);
              } catch (_) {}
            }
            if (notif['metadata'] is Map) {
              bookingMap = Map<String, dynamic>.from(notif['metadata'] as Map);
            }
          } else {
            bookingMap = Map<String, dynamic>.from(data);
          }

          int? parseInt(dynamic val) {
            if (val == null) return null;
            if (val is int) return val;
            if (val is num) return val.toInt();
            return int.tryParse(val.toString());
          }

          double? parseDouble(dynamic val) {
            if (val == null) return null;
            if (val is double) return val;
            if (val is num) return val.toDouble();
            return double.tryParse(val.toString());
          }

          String? parseString(dynamic val) {
            if (val == null) return null;
            return val.toString();
          }

          if (bookingMap['pickup_address'] == null && data['pickup_address'] != null) {
            bookingMap['pickup_address'] = data['pickup_address'];
          }
          if (bookingMap['drop_address'] == null && data['drop_address'] != null) {
            bookingMap['drop_address'] = data['drop_address'];
          }
          if (bookingMap['estimated_fare'] == null && data['estimated_fare'] != null) {
            bookingMap['estimated_fare'] = data['estimated_fare'];
          }
          if (bookingMap['pickup_lat'] == null && data['pickup_lat'] != null) {
            bookingMap['pickup_lat'] = data['pickup_lat'];
          }
          if (bookingMap['pickup_lng'] == null && data['pickup_lng'] != null) {
            bookingMap['pickup_lng'] = data['pickup_lng'];
          }
          if (bookingMap['drop_lat'] == null && data['drop_lat'] != null) {
            bookingMap['drop_lat'] = data['drop_lat'];
          }
          if (bookingMap['drop_lng'] == null && data['drop_lng'] != null) {
            bookingMap['drop_lng'] = data['drop_lng'];
          }
          if (bookingMap['estimated_distance_km'] == null && data['estimated_distance_km'] != null) {
            bookingMap['estimated_distance_km'] = data['estimated_distance_km'];
          }
          if (bookingMap['estimated_duration_mins'] == null && data['estimated_duration_mins'] != null) {
            bookingMap['estimated_duration_mins'] = data['estimated_duration_mins'];
          }
          if (bookingMap['booking_code'] == null && data['booking_code'] != null) {
            bookingMap['booking_code'] = data['booking_code'];
          }
          if (bookingMap['service_mode'] == null && data['service_mode'] != null) {
            bookingMap['service_mode'] = data['service_mode'];
          }

          if (bookingMap['pickup_address'] != null) bookingMap['pickup_address'] = parseString(bookingMap['pickup_address']);
          if (bookingMap['drop_address'] != null) bookingMap['drop_address'] = parseString(bookingMap['drop_address']);
          if (bookingMap['booking_code'] != null) bookingMap['booking_code'] = parseString(bookingMap['booking_code']);
          if (bookingMap['service_mode'] != null) bookingMap['service_mode'] = parseString(bookingMap['service_mode']);

          if (bookingMap['pickup_lat'] != null) bookingMap['pickup_lat'] = parseDouble(bookingMap['pickup_lat']);
          if (bookingMap['pickup_lng'] != null) bookingMap['pickup_lng'] = parseDouble(bookingMap['pickup_lng']);
          if (bookingMap['drop_lat'] != null) bookingMap['drop_lat'] = parseDouble(bookingMap['drop_lat']);
          if (bookingMap['drop_lng'] != null) bookingMap['drop_lng'] = parseDouble(bookingMap['drop_lng']);
          if (bookingMap['estimated_fare'] != null) bookingMap['estimated_fare'] = parseDouble(bookingMap['estimated_fare']);
          if (bookingMap['estimated_distance_km'] != null) bookingMap['estimated_distance_km'] = parseDouble(bookingMap['estimated_distance_km']);
          if (bookingMap['estimated_duration_mins'] != null) bookingMap['estimated_duration_mins'] = parseInt(bookingMap['estimated_duration_mins']);

          final int? trueBookingId = parseInt(bookingMap['booking_id']) ??
              parseInt(bookingMap['id']) ??
              parseInt(data['booking_id']) ??
              parseInt(data['id']);

          if (trueBookingId != null) {
            bookingMap['id'] = trueBookingId;
            bookingMap['booking_id'] = trueBookingId;
          }

          final int? reqId = parseInt(data['request_id']) ?? parseInt(bookingMap['request_id']);
          if (reqId != null) {
            bookingMap['request_id'] = reqId;
          }
          if (bookingMap['estimated_distance_km'] != null) bookingMap['estimated_distance_km'] = parseDouble(bookingMap['estimated_distance_km']);
          if (bookingMap['estimated_duration_mins'] != null) bookingMap['estimated_duration_mins'] = parseInt(bookingMap['estimated_duration_mins']);

          final String sMode = (bookingMap['service_mode'] ?? data['service_mode'] ?? '').toString().toUpperCase();
          final bool isCorp = sMode == 'CORPORATE' ||
              bookingMap['is_corporate'] == true ||
              data['is_corporate'] == true ||
              bookingMap['payment_method'] == 'CORPORATE_BILLING' ||
              data['payment_method'] == 'CORPORATE_BILLING';

          // If rider is offline or already in a trip / on payment screen, do not process new ride requests
          if (!_isOnDuty) {
            debugPrint('[HomePage] Dropping incoming ride request because rider is offline.');
            return;
          }
          if (_isTripStarted || _isNavigatingToPayment) {
            debugPrint('[HomePage] Dropping incoming ride request because rider is in a trip or on payment screen.');
            return;
          }

          // Strictly filter out Corporate bookings when Rider is in Self mode
          if (_rideType == 'Self' && isCorp) {
            debugPrint('[HomePage] Dropping Corporate ride request because rider is in Self mode.');
            return;
          }
          // Strictly filter out Self/Normal bookings when Rider is in Corporate mode
          if (_rideType == 'Corporate' && !isCorp) {
            debugPrint('[HomePage] Dropping Self/Normal ride request because rider is in Corporate mode.');
            return;
          }

          final model = RideRequestModel.fromJson(bookingMap);
          final entity = model.toEntity();

          if (mounted) {
            setState(() {
              _hasActiveRideRequest = true;
              _isRideRequestMinimized = false;
              _isTripAccepted = false;
              _currentRideRequest = entity;
            });
            _bookingBloc.add(RideRequestReceivedEvent(entity));
            _ringtoneService.playCallingRingtone();
          }
        } catch (e) {
          debugPrint('Error handling new ride request WS event in HomePage: $e');
        }
      } else {
        final isTripAccepted =
            event == 'booking.accepted_success' ||
            event == 'booking.accepted' ||
            event == 'booking.rider_accepted' ||
            event == 'booking.driver_accepted';

        final isTripStarted =
            event == 'booking.trip_started' ||
            event == 'booking.started' ||
            event == 'rider.trip_started' ||
            event == 'trip_started' ||
            event == 'trip.started' ||
            event == 'booking.start_success' ||
            event == 'booking.otp_verified' ||
            event == 'otpverify';

        if (isTripAccepted) {
          _ringtoneService.stopCallingRingtone();
          if (mounted) {
            setState(() {
              _isTripAccepted = true;
              _hasActiveRideRequest = false;
            });
          }
        } else if (isTripStarted) {
          _ringtoneService.stopCallingRingtone();
          if (!_isTripStarted) {
            setState(() {
              _isTripStarted = true;
              _isTripAccepted = true;
              _hasActiveRideRequest = false;
            });
            _saveActiveRideState();
            _fetchNavigationRoute();
          }
        } else if (event == 'notification.new') {
          // Suppress snackbar in booking flow
        }

        final isDropRequested =
            event == 'booking.drop_requested' ||
            event == 'booking.drop_request' ||
            event == 'trip.drop_requested' ||
            event == 'trip.drop_request' ||
            event == 'booking.early_drop_requested' ||
            event == 'booking.customer_drop_requested' ||
            event == 'ride.drop_requested' ||
            event == 'drop_requested' ||
            (data['is_drop_requested'] == true && requestedBy.toUpperCase() != 'RIDER') ||
            (data['status']?.toString().toUpperCase() == 'DROP_REQUESTED' && requestedBy.toUpperCase() != 'RIDER');

        if (isDropRequested) {
          // Only show popup if requested by the CUSTOMER (not by RIDER themselves)
          if (requestedBy.toUpperCase() != 'RIDER') {
            final reason = (data['reason'] ?? msg['reason'] ?? data['drop_reason'] ?? msg['drop_reason'] ?? 'Early drop requested by customer').toString();
            final bookingId = data['booking_id'] ?? msg['booking_id'] ?? _currentRideRequest?.id;
            _showCustomerDropRequestModal(reason: reason, bookingId: bookingId);
          }
        } else if (event == 'booking.drop_accepted' ||
            event == 'booking.drop_approved' ||
            event == 'trip.drop_accepted' ||
            event == 'trip.drop_approved' ||
            event == 'booking.completed') {
          _ringtoneService.stopCallingRingtone();
          setState(() => _isDropRequestPending = false);
          _navigateToPaymentScreen(bookingId: data['booking_id'] ?? msg['booking_id']);
        } else if (event == 'booking.drop_rejected') {
          setState(() => _isDropRequestPending = false);
        } else {
          final isCancelled =
              event == 'booking.cancelled' ||
              event == 'booking.canceled' ||
              event == 'booking.customer_cancelled' ||
              event == 'booking.rider_cancelled' ||
              event == 'booking.request_cancelled' ||
              event == 'booking.request_expired' ||
              event == 'booking_request_cancelled' ||
              event == 'booking.cancel_success' ||
              event == 'booking.cancel' ||
              event == 'ride.cancelled' ||
              event == 'ride.customer_cancelled' ||
              event == 'ride.canceled' ||
              event == 'cancel_booking' ||
              event == 'cancel_ride' ||
              data['status']?.toString().toUpperCase().contains('CANCEL') == true ||
              data['status']?.toString().toUpperCase() == 'EXPIRED';

          if (isCancelled) {
            final reason = (data['reason'] ?? msg['reason'] ?? 'Ride cancelled by customer').toString();
            final cancelBookingId = data['booking_id'] ?? msg['booking_id'] ?? data['id'] ?? data['booking']?['id'];
            _dismissRideRequestPopup(
              reason: reason,
              bookingId: cancelBookingId is int ? cancelBookingId : int.tryParse(cancelBookingId?.toString() ?? ''),
            );
          }
        }
      }
    });
  }

  Future<void> _saveActiveRideState() async {
    if (_currentRideRequest == null) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final map = {
        'id': _currentRideRequest!.id,
        'booking_id': _currentRideRequest!.id,
        'pickup_address': _currentRideRequest!.pickupAddress,
        'drop_address': _currentRideRequest!.dropAddress,
        'estimated_fare': _currentRideRequest!.estimatedFare,
        'pickup_lat': _currentRideRequest!.pickupLat,
        'pickup_lng': _currentRideRequest!.pickupLng,
        'drop_lat': _currentRideRequest!.dropLat,
        'drop_lng': _currentRideRequest!.dropLng,
      };
      await prefs.setString('active_ride_request_json', jsonEncode(map));
      await prefs.setBool('active_trip_started', _isTripStarted);
    } catch (e) {
      debugPrint('Error saving active ride state: $e');
    }
  }

  Future<void> _clearActiveRideState() async {
    _ringtoneService.stopCallingRingtone();
    if (sl.isRegistered<LiveJourneyNotificationService>()) {
      sl<LiveJourneyNotificationService>().dismissJourneyNotification();
    }
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('active_ride_request_json');
      await prefs.remove('active_trip_started');
    } catch (e) {
      debugPrint('Error clearing active ride state: $e');
    }
    if (mounted) {
      setState(() {
        _hasActiveRideRequest = false;
        _isTripAccepted = false;
        _currentRideRequest = null;
        _isTripStarted = false;
        _isRideRequestMinimized = false;
        _navigationPolylinePoints = [];
        _navigationSteps = [];
        _currentManeuverStep = null;
      });
    }
  }

  void _declineRide([int? rideId]) {
    final bId = rideId ?? _currentRideRequest?.id;
    _ringtoneService.stopCallingRingtone();
    if (bId != null && sl.isRegistered<WebSocketClient>()) {
      sl<WebSocketClient>().sendMessage({
        'event': 'booking.decline',
        'data': {
          'booking_id': bId,
          'id': bId,
          'rider_id': _driverId,
        }
      });
    }
    _bookingBloc.add(DeclineRideEvent(bId));
    _clearActiveRideState();
  }

  Future<void> _restoreActiveRideState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString('active_ride_request_json');
      final isStarted = prefs.getBool('active_trip_started') ?? false;

      if (jsonStr != null && jsonStr.isNotEmpty) {
        final Map<String, dynamic> jsonMap = jsonDecode(jsonStr);
        final model = RideRequestModel.fromJson(jsonMap);
        final entity = model.toEntity();

        if (mounted) {
          setState(() {
            _currentRideRequest = entity;
            _hasActiveRideRequest = false;
            _isTripAccepted = true;
            _isTripStarted = isStarted;
            _isOnDuty = true;
          });

          _fetchNavigationRoute();
        }
      } else {
        if (mounted) {
          setState(() {
            _hasActiveRideRequest = false;
            _isTripAccepted = false;
            _currentRideRequest = null;
          });
        }
      }
    } catch (e) {
      debugPrint('Error restoring active ride state: $e');
    }
  }

  Future<void> _fetchNavigationRoute() async {
    if (_currentLatLng == null || _currentRideRequest == null) return;

    final LatLng dest = _isTripStarted
        ? LatLng(_currentRideRequest!.dropLat, _currentRideRequest!.dropLng)
        : LatLng(_currentRideRequest!.pickupLat, _currentRideRequest!.pickupLng);

    if (dest.latitude == 0 || dest.longitude == 0) return;

    final navData = await _navigationService.fetchRouteNavigation(
      start: _currentLatLng!,
      destination: dest,
    );

    if (!mounted) return;

    if (!navData.isEmpty) {
      final step = _navigationService.getCurrentStep(_currentLatLng!, navData.steps);
      final etaTime = DateTime.now().add(Duration(seconds: navData.totalDurationSeconds.round()));
      final formattedEta = DateFormat('hh:mm a').format(etaTime);

      setState(() {
        _navigationPolylinePoints = navData.points;
        _navigationSteps = navData.steps;
        _currentManeuverStep = step;
        _remainingDistanceKm = navData.totalDistanceMeters / 1000.0;
        _remainingDurationMins = (navData.totalDurationSeconds / 60.0).round();
        _etaTimeString = formattedEta;
      });

      _showLiveJourneyNotification();

      if (!_isManualPan && _mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: _currentLatLng!,
              zoom: 17.5,
              tilt: 45.0,
            ),
          ),
        );
      }
    }
  }

  void _fitNavigationBounds() {
    if (_mapController == null) return;
    if (_navigationPolylinePoints.isNotEmpty) {
      double minLat = _navigationPolylinePoints.first.latitude;
      double maxLat = _navigationPolylinePoints.first.latitude;
      double minLng = _navigationPolylinePoints.first.longitude;
      double maxLng = _navigationPolylinePoints.first.longitude;

      for (final pt in _navigationPolylinePoints) {
        if (pt.latitude < minLat) minLat = pt.latitude;
        if (pt.latitude > maxLat) maxLat = pt.latitude;
        if (pt.longitude < minLng) minLng = pt.longitude;
        if (pt.longitude > maxLng) maxLng = pt.longitude;
      }

      _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(minLat, minLng),
            northeast: LatLng(maxLat, maxLng),
          ),
          80,
        ),
      );
      setState(() => _isManualPan = true);
    }
  }

  void _startLocationTracking() {
    _locationTimer?.cancel();
    _determinePositionAndSend();
    _locationTimer = Timer.periodic(const Duration(seconds: 8), (_) {
      if (_isOnDuty) {
        _determinePositionAndSend();
      }
    });
  }

  void _stopLocationTracking() {
    _locationTimer?.cancel();
    _locationTimer = null;
  }

  Future<void> _loadCustomMarker() async {
    _customMarker = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/images/rider_marker.png',
    );
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (!_isTripAccepted || _currentRideRequest == null) {
      if (sl.isRegistered<LiveJourneyNotificationService>()) {
        sl<LiveJourneyNotificationService>().dismissJourneyNotification();
      }
    }
    _ringtoneService.stopCallingRingtone();
    _locationTimer?.cancel();
    _riderHttpCheckTimer?.cancel();
    _wsDropSubscription?.cancel();
    _stopLocationTracking();
    _stopActiveRideHttpPolling();
    _dropReasonController.dispose();
    _homeBloc.close();
    _profileBloc.close();
    _bookingBloc.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.hidden) {
      _showLiveJourneyNotification();
    } else if (state == AppLifecycleState.resumed) {
      _showLiveJourneyNotification();
    }
  }

  double get _riderJourneyProgressPercent {
    if (!_isTripAccepted || _currentRideRequest == null) return 0.0;
    if (_navigationPolylinePoints.isNotEmpty) {
      if (!_isTripStarted) {
        return 0.25;
      } else {
        return 0.65;
      }
    }
    return _isTripStarted ? 0.60 : 0.25;
  }

  void _showLiveJourneyNotification() {
    if (!sl.isRegistered<LiveJourneyNotificationService>()) return;
    if (!_isTripAccepted || _currentRideRequest == null || !_isOnDuty) {
      sl<LiveJourneyNotificationService>().dismissJourneyNotification();
      return;
    }

    final req = _currentRideRequest!;
    final etaStr = _remainingDurationMins > 0 ? '$_remainingDurationMins min' : '8 min';
    final title = _isTripStarted
        ? 'Driving to Destination • $etaStr'
        : 'Driving to Pickup • $etaStr';

    final progress = _riderJourneyProgressPercent;

    sl<LiveJourneyNotificationService>().showJourneyNotification(
      title: title,
      pickupLocation: req.pickupAddress.isNotEmpty ? req.pickupAddress : 'Pickup',
      dropLocation: req.dropAddress.isNotEmpty ? req.dropAddress : 'Destination',
      subText: req.bookingCode != null && req.bookingCode!.isNotEmpty
          ? 'Ride #${req.bookingCode}'
          : (req.serviceMode ?? 'Strive Rider'),
      progressPercent: progress,
      remainingMins: _remainingDurationMins > 0 ? _remainingDurationMins : 8,
    );
  }

  void _showPermissionSettingsDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Location Permission Required'),
        content: const Text('StriveWheels Rider requires location access to navigate to pickup/drop locations and track live trips.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Geolocator.openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  Future<void> _determinePositionAndSend() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await Geolocator.openLocationSettings();
      if (!serviceEnabled) return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted && _isLocationPermissionGranted) {
          setState(() => _isLocationPermissionGranted = false);
        }
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        if (_isLocationPermissionGranted) {
          setState(() => _isLocationPermissionGranted = false);
        }
        _showPermissionSettingsDialog();
      }
      return;
    }

    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      if (mounted && !_isLocationPermissionGranted) {
        setState(() {
          _isLocationPermissionGranted = true;
        });
      }
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
      if (mounted) {
        setState(() {
          _currentLatLng = LatLng(position.latitude, position.longitude);
        });

        // Trigger turn-by-turn route update if active ride is in progress
        if (!_hasActiveRideRequest && _currentRideRequest != null) {
          _fetchNavigationRoute();
        } else if (_mapController != null && _currentLatLng != null && !_isManualPan) {
          _mapController!.animateCamera(CameraUpdate.newLatLng(_currentLatLng!));
        }

        _homeBloc.add(
          HomeEvent.updateLocation(
            lat: position.latitude,
            lng: position.longitude,
          ),
        );
        if (_isOnDuty) {
          _bookingBloc.add(
            SendLocationPingEvent(
              lat: position.latitude,
              lng: position.longitude,
              heading: position.heading,
              speedKmh: position.speed * 3.6,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    _showLiveJourneyNotification();
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri.parse('tel:$cleanNumber');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Error launching phone call: $e');
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _homeBloc),
        BlocProvider.value(value: _profileBloc),
        BlocProvider.value(value: _bookingBloc),
      ],
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xFF1A1A1A) : const Color(0xFFEFE9E1),
      body: MultiBlocListener(
        listeners: [
          BlocListener<HomeBloc, HomeState>(
            listener: (context, state) {
              state.maybeWhen(
                failure: (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to update availability: $error'),
                      backgroundColor: Colors.red,
                    ),
                  );
                },
                orElse: () {},
              );
            },
          ),
          BlocListener<ProfileBloc, ProfileState>(
            listener: (context, state) async {
              if (state is ProfileLoaded) {
                final prefs = await SharedPreferences.getInstance();
                _userToken = prefs.getString('user_token') ?? prefs.getString('access_token') ?? prefs.getString('token') ?? '';
                _driverId = state.profile.id;

                await _restoreActiveRideState();

                if (_isOnDuty && _driverId != null) {
                  _startLocationTracking();
                  _bookingBloc.add(ConnectWebSocketEvent(
                    driverId: _driverId!,
                    token: _userToken,
                  ));
                } else {
                  _stopLocationTracking();
                  _bookingBloc.add(DisconnectWebSocketEvent());
                }
              }
            },
          ),
          BlocListener<BookingBloc, BookingState>(
            listener: (context, state) {
              if (state is NewRideRequestState) {
                final bool isCorp = state.rideRequest.serviceMode?.toUpperCase() == 'CORPORATE';
                if (_rideType == 'Self' && isCorp) {
                  return;
                }
                if (_rideType == 'Corporate' && !isCorp) {
                  return;
                }
                setState(() {
                  _hasActiveRideRequest = true;
                  _isRideRequestMinimized = false;
                  _isTripAccepted = false;
                  _currentRideRequest = state.rideRequest;
                });
              } else if (state is RideAcceptedSuccessState) {
                setState(() {
                  _hasActiveRideRequest = false;
                  _isTripAccepted = true;
                  _isManualPan = false;
                  _isOnDuty = true;
                });
                _saveActiveRideState();
                final String mode = _rideType == 'Corporate' ? 'CORPORATE' : 'NORMAL';
                _homeBloc.add(HomeEvent.updateAvailability(availabilityMode: mode, isOnline: true));
                _fetchNavigationRoute();
              } else if (state is BookingErrorState) {
                String userMessage = state.message;
                if (userMessage.contains('is_drop_requested') ||
                    userMessage.contains('UndefinedColumnError') ||
                    userMessage.contains('rider/location')) {
                  return; // Silently ignore background location ping DB errors from backend
                }
                if (userMessage.contains('SQL') || userMessage.contains('sqlalchemy') || userMessage.contains('invalid input value')) {
                  userMessage = 'Unable to accept ride due to backend service error. Please try again.';
                }
              } else if (state is RideCancelledState) {
                // User cancelled — reset all ride state on rider side
                _ringtoneService.stopCallingRingtone();
                _clearActiveRideState();
                if (mounted) {
                  setState(() {
                    _hasActiveRideRequest = false;
                    _isRideRequestMinimized = false;
                    _isTripAccepted = false;
                    _currentRideRequest = null;
                    _isTripStarted = false;
                    _isDropRequestPending = false;
                    _navigationPolylinePoints.clear();
                  });
                }
              } else if (state is BookingConnected) {
                if (mounted) {
                  setState(() {
                    _hasActiveRideRequest = false;
                    _isTripAccepted = false;
                    _currentRideRequest = null;
                    _isRideRequestMinimized = false;
                  });
                }
              }
            },
          ),
        ],
        child: Builder(
          builder: (context) {
            final isGuidanceActive = !_hasActiveRideRequest && _currentRideRequest != null && _isTripAccepted;

            return Stack(
              children: [
                // 1. Map Layer
                Positioned.fill(
                  child: GoogleMap(
                    initialCameraPosition: _currentLatLng != null
                        ? CameraPosition(target: _currentLatLng!, zoom: 15)
                        : _initialPosition,
                    onMapCreated: (controller) {
                      _mapController = controller;
                      if (_currentLatLng != null) {
                        controller.animateCamera(CameraUpdate.newLatLngZoom(_currentLatLng!, 15));
                      }
                    },
                    onCameraMoveStarted: () {
                      if (!_isManualPan) {
                        setState(() => _isManualPan = true);
                      }
                    },
                    mapType: MapType.normal,
                    zoomControlsEnabled: false,
                    myLocationEnabled: _isLocationPermissionGranted,
                    myLocationButtonEnabled: false,
                    polylines: _buildPolylines(),
                    markers: _buildMarkers(),
                  ),
                ),

                // 2. Active Guidance Top Maneuver Banner
                if (isGuidanceActive)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: ManeuverBannerWidget(
                      currentStep: _currentManeuverStep,
                      distanceToStepMeters: _distanceToStepMeters,
                      isMuted: _isNavMuted,
                      onToggleMute: () => setState(() => _isNavMuted = !_isNavMuted),
                      onOverviewTap: _fitNavigationBounds,
                    ),
                  ),

                // 3. Floating Recenter / GPS Button (Top Right)
                Positioned(
                  top: MediaQuery.of(context).padding.top + (isGuidanceActive ? 80 : 180),
                  right: 16,
                  child: _buildFloatingButton(
                    Icons.my_location,
                    isDark,
                    onTap: () {
                      if (isGuidanceActive) {
                        setState(() => _isManualPan = false);
                      }
                      if (_mapController != null && _currentLatLng != null) {
                        _mapController!.animateCamera(
                          isGuidanceActive
                              ? CameraUpdate.newCameraPosition(
                                  CameraPosition(
                                    target: _currentLatLng!,
                                    zoom: 17.5,
                                    tilt: 45.0,
                                  ),
                                )
                              : CameraUpdate.newLatLng(_currentLatLng!),
                        );
                      }
                    },
                  ),
                ),

                // 5. Top Dashboard Card (Only when NOT in active navigation guidance)
                if (!isGuidanceActive)
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 16,
                    left: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceDark : Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 15,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Profile Section
                      Expanded(
                        flex: 3,
                        child: BlocBuilder<ProfileBloc, ProfileState>(
                          builder: (context, state) {
                            String name = 'Loading...';
                            String rating = '0.0';
                            String imageUrl = '';
                            ProfileEntity? profile;

                            if (state is ProfileLoaded) {
                              profile = state.profile;
                              name = state.profile.name;
                              rating = state.profile.rating.toString();
                              imageUrl = state.profile.profileImageUrl;
                            } else if (state is ProfileUpdateSuccess) {
                              profile = state.profile;
                              name = state.profile.name;
                              rating = state.profile.rating.toString();
                              imageUrl = state.profile.profileImageUrl;
                            }

                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BlocProvider.value(
                                      value: _profileBloc,
                                      child: ProfileViewPage(initialProfile: profile),
                                    ),
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Row(
                                children: [
                                  Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      CircleAvatar(
                                        radius: 20,
                                        backgroundColor: Colors.grey.shade200,
                                        backgroundImage: imageUrl.isNotEmpty
                                            ? NetworkImage(imageUrl)
                                            : const AssetImage('assets/images/login.png') as ImageProvider,
                                        onBackgroundImageError: imageUrl.isNotEmpty ? (exception, stackTrace) {} : null,
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: -2,
                                        child: Container(
                                          width: 12,
                                          height: 12,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF10A142),
                                            shape: BoxShape.circle,
                                            border: Border.all(color: Colors.white, width: 2),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          name,
                                          style: GoogleFonts.inter(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: isDark ? Colors.white : Colors.black,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Row(
                                          children: [
                                            const Icon(Icons.star_outline, color: Colors.orange, size: 12),
                                            const SizedBox(width: 2),
                                            Expanded(
                                              child: Text(
                                                '$rating • Top Rated',
                                                style: GoogleFonts.inter(
                                                  fontSize: 10,
                                                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
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
                                ],
                              ),
                            );
                          }
                        ),
                      ),

                      // Duty Toggle Section
                      Expanded(
                        flex: 4,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        width: 6,
                                        height: 6,
                                        decoration: BoxDecoration(
                                          color: _isOnDuty ? const Color(0xFF10A142) : Colors.grey,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Flexible(
                                        child: Text(
                                          _isOnDuty ? 'ON DUTY' : 'OFF DUTY',
                                          style: GoogleFonts.inter(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: _isOnDuty ? const Color(0xFF10A142) : Colors.grey,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _isOnDuty ? "You're available\nfor rides" : "You're offline",
                                    textAlign: TextAlign.right,
                                    style: GoogleFonts.inter(
                                      fontSize: 8,
                                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Transform.scale(
                              scale: 0.7,
                              child: Switch(
                                value: _isOnDuty,
                                onChanged: (val) {
                                  if (!val && (_hasActiveRideRequest || _currentRideRequest != null)) {
                                    return;
                                  }
                                  setState(() {
                                    _isOnDuty = val;
                                  });
                                  final String mode = _rideType == 'Corporate' ? 'CORPORATE' : 'NORMAL';
                                  _homeBloc.add(HomeEvent.updateAvailability(availabilityMode: mode, isOnline: _isOnDuty));

                                  if (_isOnDuty) {
                                    _startLocationTracking();
                                    if (_driverId != null) {
                                      _bookingBloc.add(ConnectWebSocketEvent(
                                        driverId: _driverId!,
                                        token: _userToken,
                                      ));
                                    }
                                  } else {
                                    _stopLocationTracking();
                                    _bookingBloc.add(DisconnectWebSocketEvent());
                                  }
                                },
                                activeThumbColor: Colors.white,
                                activeTrackColor: AppColors.primaryBlue,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Wallet Section
                      Expanded(
                        flex: 3,
                        child: BlocBuilder<ProfileBloc, ProfileState>(
                          builder: (context, state) {
                            String earnings = '0.0';
                            if (state is ProfileLoaded) {
                              earnings = state.profile.totalEarnings.toString();
                            } else if (state is ProfileUpdateSuccess) {
                              earnings = state.profile.totalEarnings.toString();
                            }
                            
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Total Earnings',
                                        style: GoogleFonts.inter(
                                          fontSize: 9,
                                          color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        '₹$earnings',
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: isDark ? Colors.white : Colors.black,
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
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Segmented Control
                  Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              final selectedDates = await showModalBottomSheet<List<DateTime>>(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) => AvailabilityBottomSheet(
                                  initiallySelectedDates: _corporateSelectedDates,
                                ),
                              );

                              if (selectedDates != null && selectedDates.isNotEmpty) {
                                setState(() {
                                  _rideType = 'Corporate';
                                  _corporateSelectedDates = selectedDates;
                                });
                                try {
                                  final prefs = await SharedPreferences.getInstance();
                                  final dateIsoStrings = selectedDates.map((d) => "${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}").toList();
                                  await prefs.setStringList('corporate_selected_dates', dateIsoStrings);
                                  await prefs.setString('selected_ride_type', 'Corporate');
                                } catch (_) {}

                                const String mode = 'CORPORATE';
                                _homeBloc.add(HomeEvent.updateAvailability(
                                  availabilityMode: mode, 
                                  isOnline: _isOnDuty,
                                  selectedDates: selectedDates,
                                ));
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: _rideType == 'Corporate' ? AppColors.primaryBlue : Colors.transparent,
                                borderRadius: BorderRadius.circular(22),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.work_outline,
                                      size: 18,
                                      color: _rideType == 'Corporate' ? Colors.white : (isDark ? Colors.grey.shade400 : Colors.black87),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Corporate',
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: _rideType == 'Corporate' ? Colors.white : (isDark ? Colors.grey.shade400 : Colors.black87),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              setState(() {
                                _rideType = 'Self';
                              });
                              try {
                                final prefs = await SharedPreferences.getInstance();
                                await prefs.setString('selected_ride_type', 'Self');
                              } catch (_) {}
                              const String mode = 'NORMAL';
                              _homeBloc.add(HomeEvent.updateAvailability(availabilityMode: mode, isOnline: _isOnDuty));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: _rideType == 'Self' ? AppColors.primaryBlue : Colors.transparent,
                                borderRadius: BorderRadius.circular(22),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.person_outline,
                                      size: 18,
                                      color: _rideType == 'Self' ? Colors.white : (isDark ? Colors.grey.shade400 : Colors.black87),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Self',
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: _rideType == 'Self' ? Colors.white : (isDark ? Colors.grey.shade400 : Colors.black87),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),
          ),

          // 5. Bottom Ride Request Card
          if (_hasActiveRideRequest && _isOnDuty)
            BlocConsumer<BookingBloc, BookingState>(
              listener: (context, state) {
                if (state is NewRideRequestState) {
                  _ringtoneService.playCallingRingtone();
                } else if (state is AcceptingRideState ||
                    state is RideAcceptedSuccessState ||
                    state is BookingConnected ||
                    state is RideCancelledState ||
                    state is BookingErrorState) {
                  _ringtoneService.stopCallingRingtone();
                }
              },
              builder: (context, state) {
                if (state is NewRideRequestState) {
                  return _isRideRequestMinimized
                      ? _buildMinimizedRideRequestCard(isDark, state)
                      : _buildMaximizedRideRequestCard(isDark, state);
                } else if (state is AcceptingRideState) {
                  return const Center(child: CircularProgressIndicator());
                } else if (_currentRideRequest != null) {
                  final reqState = NewRideRequestState(_currentRideRequest!);
                  return _isRideRequestMinimized
                      ? _buildMinimizedRideRequestCard(isDark, reqState)
                      : _buildMaximizedRideRequestCard(isDark, reqState);
                }
                return const SizedBox.shrink();
              },
            ),

          if (isGuidanceActive && _isOnDuty)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: NavigationBottomPanelWidget(
                remainingMins: _remainingDurationMins > 0 ? _remainingDurationMins : 8,
                remainingKm: _remainingDistanceKm > 0 ? _remainingDistanceKm : 2.4,
                arrivalEta: _etaTimeString.isEmpty ? '10:45 AM' : _etaTimeString,
                destinationAddress: _currentRideRequest?.dropAddress ?? '',
                pickupAddress: _currentRideRequest?.pickupAddress ?? '',
                isTripStarted: _isTripStarted,
                isLoading: _isLoadingAction,
                isDropPending: _isDropRequestPending,
                onMainActionTap: () => _showActiveTripBottomSheet(context),
                onRequestDrop: _isTripStarted ? () => _showDropRequestDialog(context) : null,
                onCancelRide: () => _showRiderCancelDialog(context),
                onCallTap: () => _makePhoneCall('6366557766'),
                onChatTap: () {
                  final bId = _currentRideRequest?.id ?? 0;
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => RideChatPage(
                        bookingId: bId,
                        currentUserId: 2,
                        counterpartyName: 'Customer',
                      ),
                    ),
                  );
                },
              ),
            ),

          // Moving bike riding on top of the bottom navigation bar
          if (!_hasActiveRideRequest && _currentRideRequest == null)
            const Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SizedBox(
                height: 28,
                child: MovingCar(
                  height: 28,
                  carWidth: 56,
                  repeat: false,
                ),
              ),
            ),
        ],
      );
    }),
    ),
      bottomNavigationBar: (!_hasActiveRideRequest && _currentRideRequest != null)
          ? null
          : Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: BottomNavigationBar(
                currentIndex: _currentIndex,
                onTap: (index) {
                  if (index == 1) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const TripsPage()),
                    );
                  } else if (index == 2) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const EarningsPage()),
                    );
                  } else if (index == 3) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const SettingsPage()),
                    );
                  } else {
                    setState(() => _currentIndex = index);
                  }
                },
                type: BottomNavigationBarType.fixed,
                backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
                selectedItemColor: AppColors.primaryBlue,
                unselectedItemColor: isDark ? Colors.grey.shade500 : Colors.grey.shade500,
                selectedLabelStyle: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600),
                unselectedLabelStyle: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500),
                items: const [
                  BottomNavigationBarItem(icon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.home)), label: 'Home'),
                  BottomNavigationBarItem(icon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.history)), label: 'Trips'),
                  BottomNavigationBarItem(icon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.currency_rupee)), label: 'Earnings'),
                  BottomNavigationBarItem(icon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.settings_outlined)), label: 'Settings'),
                ],
              ),
            ),
    ));
  }

  Widget _buildFloatingButton(IconData icon, bool isDark, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: AppColors.primaryBlue, size: 24),
      ),
    );
  }



  Widget _buildMaximizedRideRequestCard(bool isDark, NewRideRequestState state) {
    final ride = state.rideRequest;
    return Positioned(
      bottom: 16,
      left: 16,
      right: 16,
      child: GestureDetector(
        onVerticalDragUpdate: (details) {
          if (details.delta.dy > 10) {
            setState(() {
              _isRideRequestMinimized = true;
            });
          }
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Line 1: Amount, Ride Type, and Minimize Button
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (ride.serviceMode?.toUpperCase() == 'CORPORATE') ...[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.deepPurple.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.business_rounded, size: 15, color: Colors.deepPurple),
                                    const SizedBox(width: 5),
                                    Text(
                                      'Corporate Ride',
                                      style: GoogleFonts.inter(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepPurple,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Company Direct Billing',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'EST. PAYOUT',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
                            ),
                          ),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '₹${ride.estimatedFare}',
                              maxLines: 1,
                              style: GoogleFonts.inter(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF0D6EFD),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D6EFD).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Self',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0D6EFD),
                        ),
                      ),
                    ),
                  ],
                  if (ride.seatNumber != null) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.green.shade600, width: 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.airline_seat_recline_normal, size: 14, color: Colors.green.shade700),
                          const SizedBox(width: 4),
                          Text(
                            'Seat #${ride.seatNumber}',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isRideRequestMinimized = true;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.keyboard_arrow_down, 
                        color: isDark ? Colors.white : Colors.black54, 
                        size: 20
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              Row(
                children: [
                  if (ride.estimatedDistanceKm != null && ride.estimatedDistanceKm! > 0) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.straighten, size: 14, color: isDark ? Colors.grey.shade300 : Colors.grey.shade700),
                          const SizedBox(width: 4),
                          Text(
                            '${ride.estimatedDistanceKm!.toStringAsFixed(1)} km',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  if (ride.estimatedDurationMins != null && ride.estimatedDurationMins! > 0) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.access_time_rounded, size: 14, color: isDark ? Colors.grey.shade300 : Colors.grey.shade700),
                          const SizedBox(width: 4),
                          Text(
                            '${ride.estimatedDurationMins} mins',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  if (ride.bookingCode != null && ride.bookingCode!.isNotEmpty) ...[
                    Expanded(
                      child: Text(
                        ride.bookingCode!,
                        textAlign: TextAlign.end,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 12),

              // Line 2: From Location
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                      CustomPaint(
                        size: const Size(1, 24),
                        painter: DashedLinePainter(),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PICKUP',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          ride.pickupAddress,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              // Line 3: To Location
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Color(0xFF0D6EFD),
                      shape: BoxShape.rectangle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'DROPOFF',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF0D6EFD),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          ride.dropAddress,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: OutlinedButton(
                      onPressed: () => _declineRide(ride.id),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Decline',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        _ringtoneService.stopCallingRingtone();
                        setState(() => _isOnDuty = true);
                        _saveActiveRideState();
                        final String mode = _rideType == 'Corporate' ? 'CORPORATE' : 'NORMAL';
                        _homeBloc.add(HomeEvent.updateAvailability(availabilityMode: mode, isOnline: true));
                        _bookingBloc.add(AcceptRideEvent(ride.id));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D6EFD),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Accept ride',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMinimizedRideRequestCard(bool isDark, NewRideRequestState state) {
    final ride = state.rideRequest;
    return Positioned(
      bottom: 24,
      left: 16,
      right: 16,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isRideRequestMinimized = false;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              // Amount
              // Amount / Header
              if (ride.serviceMode?.toUpperCase() == 'CORPORATE') ...[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CORPORATE',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    Text(
                      'Ride Request',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF1E293B),
                      ),
                    ),
                    if (ride.seatNumber != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        'Seat #${ride.seatNumber}',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade600,
                        ),
                      ),
                    ],
                  ],
                ),
              ] else ...[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PAYOUT',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
                      ),
                    ),
                    Text(
                      '₹${ride.estimatedFare}',
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0D6EFD),
                      ),
                    ),
                    if (ride.seatNumber != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        'Seat #${ride.seatNumber}',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade600,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
              
              Container(
                width: 1,
                height: 30,
                color: Colors.grey.shade300,
                margin: const EdgeInsets.symmetric(horizontal: 16),
              ),
              
              // Locations
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            ride.pickupAddress,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(color: Color(0xFF0D6EFD), shape: BoxShape.rectangle),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            ride.dropAddress,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : Colors.black87,
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
              
              const SizedBox(width: 8),
              
              // Action Buttons
              Row(
                children: [
                  GestureDetector(
                    onTap: () => _declineRide(ride.id),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        color: isDark ? Colors.white : Colors.black54,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      _ringtoneService.stopCallingRingtone();
                      setState(() => _isOnDuty = true);
                      _saveActiveRideState();
                      final String mode = _rideType == 'Corporate' ? 'CORPORATE' : 'NORMAL';
                      _homeBloc.add(HomeEvent.updateAvailability(availabilityMode: mode, isOnline: true));
                      _bookingBloc.add(AcceptRideEvent(ride.id));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Color(0xFF0D6EFD),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Set<Polyline> _buildPolylines() {
    // No route while ride request is pending or no data
    if (_hasActiveRideRequest || _currentRideRequest == null || _currentLatLng == null) {
      return const <Polyline>{};
    }

    final polylines = <Polyline>{};

    if (_navigationPolylinePoints.isNotEmpty) {
      polylines.add(
        Polyline(
          polylineId: const PolylineId('active_navigation_route'),
          points: _navigationPolylinePoints,
          color: _isTripStarted ? const Color(0xFF10B981) : const Color(0xFF0D6EFD),
          width: 6,
          jointType: JointType.round,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
        ),
      );
      return polylines;
    }

    // Fallback straight lines if OSRM geometry is still fetching
    if (_currentRideRequest!.pickupLat != 0 && _currentRideRequest!.pickupLng != 0) {
      polylines.add(
        Polyline(
          polylineId: const PolylineId('rider_to_pickup'),
          points: [
            _currentLatLng!,
            LatLng(_currentRideRequest!.pickupLat, _currentRideRequest!.pickupLng),
          ],
          color: const Color(0xFF0D6EFD),
          width: 5,
          patterns: [PatternItem.dash(20), PatternItem.gap(10)],
        ),
      );
    }

    if (_isTripStarted &&
        _currentRideRequest!.pickupLat != 0 &&
        _currentRideRequest!.dropLat != 0 &&
        _currentRideRequest!.dropLng != 0) {
      polylines.add(
        Polyline(
          polylineId: const PolylineId('pickup_to_drop'),
          points: [
            LatLng(_currentRideRequest!.pickupLat, _currentRideRequest!.pickupLng),
            LatLng(_currentRideRequest!.dropLat, _currentRideRequest!.dropLng),
          ],
          color: const Color(0xFF10A142),
          width: 5,
        ),
      );
    }

    return polylines;
  }

  Set<Marker> _buildMarkers() {
    final markers = <Marker>{};
    if (_currentLatLng != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: _currentLatLng!,
          icon: _customMarker ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          anchor: const Offset(0.5, 0.5),
        ),
      );
    }
    if (_currentRideRequest != null) {
      if (_currentRideRequest!.pickupLat != 0 && _currentRideRequest!.pickupLng != 0) {
        markers.add(
          Marker(
            markerId: const MarkerId('pickup_location'),
            position: LatLng(_currentRideRequest!.pickupLat, _currentRideRequest!.pickupLng),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
            infoWindow: InfoWindow(title: 'Pickup', snippet: _currentRideRequest!.pickupAddress),
          ),
        );
      }
      if (_currentRideRequest!.dropLat != 0 && _currentRideRequest!.dropLng != 0) {
        markers.add(
          Marker(
            markerId: const MarkerId('drop_location'),
            position: LatLng(_currentRideRequest!.dropLat, _currentRideRequest!.dropLng),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            infoWindow: InfoWindow(title: 'Dropoff', snippet: _currentRideRequest!.dropAddress),
          ),
        );
      }
    }
    return markers;
  }

  void _showActiveTripBottomSheet(BuildContext ctx) {
    final ride = _currentRideRequest;
    if (ride == null) return;
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        final activeRide = _currentRideRequest ?? ride;
        if (_currentRideRequest == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (sheetContext.mounted && Navigator.of(sheetContext).canPop()) {
              Navigator.of(sheetContext).pop();
            }
          });
          return const SizedBox.shrink();
        }

        return DraggableScrollableSheet(
          initialChildSize: 0.88,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (_, scrollController) => Container(
            decoration: BoxDecoration(
              color: Theme.of(ctx).brightness == Brightness.dark
                  ? const Color(0xFF121212)
                  : const Color(0xFFF7F8FC),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                // Drag handle
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 4),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    child: ActiveTripPage(
                      bookingId: activeRide.id,
                      pickupAddress: activeRide.pickupAddress,
                      dropAddress: activeRide.dropAddress,
                      estimatedFare: activeRide.estimatedFare,
                      pickupLat: activeRide.pickupLat,
                      pickupLng: activeRide.pickupLng,
                      dropLat: activeRide.dropLat,
                      dropLng: activeRide.dropLng,
                      riderLat: _currentLatLng?.latitude,
                      riderLng: _currentLatLng?.longitude,
                      onTripStarted: () {
                        // OTP verified — unlock pickup→drop route on the home map
                        if (mounted) {
                          setState(() => _isTripStarted = true);
                          _saveActiveRideState();
                          _fetchNavigationRoute();
                        }
                      },
                      onTripCompleted: () {
                        if (sheetContext.mounted && Navigator.of(sheetContext).canPop()) {
                          Navigator.of(sheetContext).pop();
                        }
                        if (mounted) {
                          _clearActiveRideState();
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDropRequestDialog(BuildContext ctx) {
    if (_currentRideRequest == null) return;
    _dropReasonController.clear();
    showDialog(
      context: ctx,
      barrierDismissible: false,
      builder: (dialogCtx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.flag_rounded, color: Colors.orange, size: 22),
              ),
              const SizedBox(width: 12),
              Text(
                'Request Drop',
                style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 17),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Provide a reason for the early drop. The customer will be notified and must approve.',
                style: GoogleFonts.inter(fontSize: 13, color: Colors.grey.shade600, height: 1.5),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _dropReasonController,
                maxLines: 3,
                maxLength: 200,
                decoration: InputDecoration(
                  hintText: 'e.g. Road blocked, vehicle issue...',
                  hintStyle: GoogleFonts.inter(
                    fontSize: 12,
                    color: Theme.of(dialogCtx).brightness == Brightness.dark
                        ? Colors.grey.shade400
                        : Colors.grey.shade500,
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.orange, width: 1.5),
                  ),
                  filled: true,
                  fillColor: Theme.of(dialogCtx).brightness == Brightness.dark
                      ? Colors.grey.shade800
                      : Colors.grey.shade50,
                  contentPadding: const EdgeInsets.all(12),
                ),
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: Theme.of(dialogCtx).brightness == Brightness.dark
                      ? Colors.white
                      : const Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogCtx);
              },
              child: Text('Cancel', style: GoogleFonts.inter(color: Colors.grey.shade600, fontWeight: FontWeight.w600)),
            ),
            ElevatedButton(
              onPressed: () {
                final reason = _dropReasonController.text.trim();
                if (reason.isEmpty) {
                  return;
                }
                Navigator.pop(dialogCtx);
                setState(() => _isDropRequestPending = true);
                // Send booking.drop_requested via WebSocket
                if (sl.isRegistered<WebSocketClient>()) {
                  sl<WebSocketClient>().sendMessage({
                    'event': 'booking.drop_requested',
                    'data': {
                      'booking_id': _currentRideRequest?.id ?? 0,
                      'requested_by': 'RIDER',
                      'reason': reason,
                    },
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: Text(
                'Submit',
                style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showRiderCancelDialog(BuildContext ctx) {
    if (_currentRideRequest == null) return;
    String selectedReason = 'Customer requested cancellation';
    final reasons = [
      'Customer requested cancellation',
      'Vehicle issues / breakdown',
      'Heavy traffic / long delay',
      'Safety concerns',
      'Other',
    ];

    showDialog(
      context: ctx,
      builder: (dialogCtx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444).withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.cancel_outlined, color: Color(0xFFEF4444), size: 22),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Cancel Trip?',
                    style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Please select a reason for cancelling this trip:',
                    style: GoogleFonts.inter(fontSize: 13, color: Colors.grey.shade600, height: 1.4),
                  ),
                  const SizedBox(height: 12),
                  ...reasons.map((reason) => RadioListTile<String>(
                        title: Text(
                          reason,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: Theme.of(dialogCtx).brightness == Brightness.dark
                                ? Colors.white
                                : const Color(0xFF1E293B),
                          ),
                        ),
                        value: reason,
                        groupValue: selectedReason,
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        activeColor: const Color(0xFFEF4444),
                        onChanged: (val) {
                          if (val != null) {
                            setDialogState(() => selectedReason = val);
                          }
                        },
                      )),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogCtx),
                  child: Text('Back', style: GoogleFonts.inter(color: Colors.grey.shade600, fontWeight: FontWeight.w600)),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(dialogCtx);
                    final bookingId = _currentRideRequest?.id;
                    if (bookingId != null) {
                      _bookingBloc.add(CancelRideEvent(bookingId: bookingId, reason: selectedReason));
                      if (sl.isRegistered<WebSocketClient>()) {
                        sl<WebSocketClient>().sendMessage({
                          'event': 'booking.cancelled',
                          'data': {
                            'booking_id': bookingId,
                            'cancelled_by': 'RIDER',
                            'reason': selectedReason,
                          },
                        });
                      }
                    }
                    _clearActiveRideState();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEF4444),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  child: Text(
                    'Confirm Cancel',
                    style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showCustomerDropRequestModal({required String reason, dynamic bookingId}) {
    debugPrint('🔔 [HomePage] Received customer drop request modal trigger: reason=$reason, bookingId=$bookingId');
    if (_isCustomerDropModalShowing) return;
    _isCustomerDropModalShowing = true;

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        int remainingSeconds = 30;
        Timer? timer;

        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            timer ??= Timer.periodic(const Duration(seconds: 1), (t) {
              if (remainingSeconds > 1) {
                if (mounted) {
                  setSheetState(() {
                    remainingSeconds--;
                  });
                }
              } else {
                t.cancel();
                if (mounted) {
                  // Auto Accept on 30s timeout
                  Navigator.pop(ctx);
                  _isCustomerDropModalShowing = false;
                  if (sl.isRegistered<WebSocketClient>()) {
                    final bId = bookingId ?? _currentRideRequest?.id;
                    final bIdInt = bId is String ? int.tryParse(bId.replaceAll(RegExp(r'[^0-9]'), '')) : bId;
                    sl<WebSocketClient>().sendMessage({
                      'event': 'booking.drop_accepted',
                      'data': {
                        'booking_id': bIdInt ?? bId,
                        'accepted_by': 'RIDER',
                        'is_drop_accepted': true,
                      },
                    });
                    sl<WebSocketClient>().sendMessage({
                      'event': 'booking.drop_approved',
                      'data': {
                        'booking_id': bIdInt ?? bId,
                        'accepted_by': 'RIDER',
                        'is_drop_accepted': true,
                      },
                    });
                    sl<WebSocketClient>().sendMessage({
                      'event': 'booking.complete',
                      'data': {
                        'booking_id': bIdInt ?? bId,
                        'rider_lat': _currentLatLng?.latitude,
                        'rider_lng': _currentLatLng?.longitude,
                      },
                    });
                  }
                  Future.delayed(const Duration(milliseconds: 300), () {
                    if (mounted) _navigateToPaymentScreen(bookingId: bookingId);
                  });
                }
              }
            });

            return Container(
              padding: const EdgeInsets.all(24),
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
                        child: const Icon(Icons.flag_rounded, color: Color(0xFF2563EB), size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Customer Drop Request',
                              style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Early drop requested by customer',
                              style: GoogleFonts.inter(fontSize: 13, color: Colors.grey.shade600),
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
                              style: GoogleFonts.inter(
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
                      style: GoogleFonts.inter(fontSize: 14, fontStyle: FontStyle.italic, color: const Color(0xFF334155)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Auto-accepting in ${remainingSeconds}s if no action taken.',
                    style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            timer?.cancel();
                            Navigator.pop(ctx);
                            _isCustomerDropModalShowing = false;
                            if (sl.isRegistered<WebSocketClient>()) {
                              sl<WebSocketClient>().sendMessage({
                                'event': 'booking.drop_rejected',
                                'data': {
                                  'booking_id': bookingId ?? _currentRideRequest?.id,
                                  'rejected_by': 'RIDER',
                                  'reason': 'Rider declined early drop request',
                                },
                              });
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFCBD5E1)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Text(
                            'Decline',
                            style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: const Color(0xFF64748B)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            timer?.cancel();
                            Navigator.pop(ctx);
                            _isCustomerDropModalShowing = false;
                            final bId = bookingId ?? _currentRideRequest?.id;
                            final bIdInt = bId is String ? int.tryParse(bId.replaceAll(RegExp(r'[^0-9]'), '')) : bId;
                            final curLat = _currentLatLng?.latitude;
                            final curLng = _currentLatLng?.longitude;

                            if (sl.isRegistered<WebSocketClient>()) {
                              sl<WebSocketClient>().sendMessage({
                                'event': 'booking.drop_accepted',
                                'data': {
                                  'booking_id': bIdInt ?? bId,
                                  'accepted_by': 'RIDER',
                                  'is_drop_accepted': true,
                                  'lat': curLat,
                                  'lng': curLng,
                                  'rider_lat': curLat,
                                  'rider_lng': curLng,
                                },
                              });
                              sl<WebSocketClient>().sendMessage({
                                'event': 'booking.drop_approved',
                                'data': {
                                  'booking_id': bIdInt ?? bId,
                                  'accepted_by': 'RIDER',
                                  'is_drop_accepted': true,
                                  'lat': curLat,
                                  'lng': curLng,
                                },
                              });
                              sl<WebSocketClient>().sendMessage({
                                'event': 'booking.complete',
                                'data': {
                                  'booking_id': bIdInt ?? bId,
                                  'rider_lat': curLat,
                                  'rider_lng': curLng,
                                },
                              });
                            }
                            Future.delayed(const Duration(milliseconds: 300), () {
                              if (mounted) {
                                _navigateToPaymentScreen(
                                  bookingId: bookingId,
                                  isEarlyDrop: true,
                                );
                              }
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF10B981),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Text(
                            'Accept (${remainingSeconds}s)',
                            style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.white),
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
    ).whenComplete(() => _isCustomerDropModalShowing = false);
  }

  bool _isNavigatingToPayment = false;

  void _navigateToPaymentScreen({
    dynamic bookingId,
    double? updatedFare,
    bool isEarlyDrop = false,
    double? distanceKm,
  }) {
    if (_isNavigatingToPayment) return;
    _isNavigatingToPayment = true;

    final req = _currentRideRequest;
    _ringtoneService.stopCallingRingtone();
    _clearActiveRideState();

    final id = bookingId is int
        ? bookingId
        : (bookingId is String ? int.tryParse(bookingId) : null) ?? req?.id ?? 0;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TripPaymentPage(
          bookingId: id,
          estimatedFare: req?.estimatedFare ?? 0.0,
          finalFare: updatedFare,
          isEarlyDrop: isEarlyDrop,
          actualDistanceKm: distanceKm,
          pickupAddress: req?.pickupAddress ?? '',
          dropAddress: req?.dropAddress ?? '',
          riderLat: _currentLatLng?.latitude,
          riderLng: _currentLatLng?.longitude,
          isCorporate: req?.serviceMode?.toUpperCase() == 'CORPORATE',
          serviceMode: req?.serviceMode,
          onCompleted: () {
            _ringtoneService.stopCallingRingtone();
            _clearActiveRideState();
          },
        ),
      ),
    ).then((_) {
      _isNavigatingToPayment = false;
      _ringtoneService.stopCallingRingtone();
      _clearActiveRideState();
    });
  }


}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const dashWidth = 3.0;
    const dashSpace = 3.0;
    double startY = 0;
    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashWidth), paint);
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
