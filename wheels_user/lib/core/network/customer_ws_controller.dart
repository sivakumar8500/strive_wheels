import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../di/injection_container.dart';
import '../utils/jwt_utils.dart';
import 'api_constants.dart';
import 'websocket_service.dart';

class CustomerWSController {
  final WebSocketService _ws;
  final Dio _dio;
  StreamSubscription? _subscription;
  final _bookingEventController = StreamController<Map<String, dynamic>>.broadcast();

  CustomerWSController({WebSocketService? ws, Dio? dio})
      : _ws = ws ?? WebSocketService(),
        _dio = dio ?? Dio();

  Stream<Map<String, dynamic>> get bookingEventStream =>
      _bookingEventController.stream;

  void reconnectIfNeeded() {
    try {
      final prefs = sl.isRegistered<SharedPreferences>() ? sl<SharedPreferences>() : null;
      final rawToken = prefs?.getString('access_token') ??
          prefs?.getString('auth_token') ??
          prefs?.getString('user_token');
      final token = (rawToken != null && rawToken.trim().isNotEmpty) ? rawToken.trim() : 'demo_token';

      int? userId = prefs?.getInt('user_id') ?? prefs?.getInt('customer_id');
      if (userId == null && rawToken != null && rawToken.trim().isNotEmpty) {
        userId = JwtUtils.getUserIdFromJwt(rawToken);
      }
      userId ??= 1;

      initCustomerWebSocket(userId, token);
      debugPrint('[CustomerWSController] Reconnect executed for customerId: $userId');
    } catch (e) {
      debugPrint('[CustomerWSController] Reconnect error: $e');
    }
  }

  void initCustomerWebSocket(int customerId, String jwtToken, {String? baseUrl}) {
    final url = baseUrl ?? ApiConstants.wsBaseUrl;
    _ws.connect(url, customerId, jwtToken, role: 'customer');

    _subscription?.cancel();
    _subscription = _ws.eventStream.listen((message) {
      final event = message['event'];
      final data = message['data'] ?? {};

      debugPrint('[CustomerWSController] Received event $event with data: $data');

      _bookingEventController.add(message);

      switch (event) {
        case 'booking.created':
          debugPrint('[CustomerWSController] Booking created: ${data['booking']?['id']}');
          break;
        case 'booking.rider_accepted':
          final booking = data['booking'] ?? {};
          final rider = booking['rider'] ?? {};
          final otp = booking['start_otp'];
          debugPrint('[CustomerWSController] Rider Accepted! Driver: ${rider['full_name']}, OTP: $otp');
          break;
        case 'rider.location_updated':
        case 'rider.location':
        case 'location_update':
        case 'location.update':
        case 'location.updated':
        case 'driver.location':
        case 'driver.location_updated':
        case 'booking.location_updated':
          double? parseCoord(dynamic val) {
            if (val == null) return null;
            if (val is num) return val.toDouble();
            return double.tryParse(val.toString());
          }
          final lat = parseCoord(
            data['lat'] ??
            data['latitude'] ??
            data['rider_lat'] ??
            data['driver_lat'] ??
            (data['location'] is Map ? data['location']['lat'] ?? data['location']['latitude'] : null) ??
            (data['coords'] is Map ? data['coords']['lat'] ?? data['coords']['latitude'] : null)
          );
          final lng = parseCoord(
            data['lng'] ??
            data['longitude'] ??
            data['rider_lng'] ??
            data['driver_lng'] ??
            (data['location'] is Map ? data['location']['lng'] ?? data['location']['longitude'] : null) ??
            (data['coords'] is Map ? data['coords']['lng'] ?? data['coords']['longitude'] : null)
          );
          debugPrint('[CustomerWSController] Rider location update: $lat, $lng');
          break;
        case 'booking.arrived':
        case 'rider.arrived':
        case 'booking.rider_arrived':
          debugPrint('[CustomerWSController] Rider Arrived at Pickup!');
          break;
        case 'booking.verify':
        case 'booking.verified':
        case 'booking.started':
        case 'rider.trip_started':
        case 'booking.trip_started':
        case 'booking.start_success':
        case 'booking.start':
        case 'trip_started':
        case 'trip.started':
        case 'booking.otp_verified':
        case 'otp_verified':
        case 'otpverify':
        case 'booking.updated':
        case 'ride.started':
        case 'booking.in_transit':
        case 'in_transit':
          debugPrint('[CustomerWSController] Trip Started / OTP Verified!');
          break;
        case 'booking.completed':
        case 'rider.trip_completed':
        case 'booking.trip_completed':
          debugPrint('[CustomerWSController] Trip Completed!');
          break;
        case 'booking.cancelled':
        case 'booking.cancel_success':
        case 'booking.customer_cancelled':
          debugPrint('[CustomerWSController] Trip Cancelled!');
          break;
        case 'booking.drop_requested':
          final reason = data['reason'] ?? 'No reason provided';
          debugPrint('[CustomerWSController] Drop Requested by rider! Reason: $reason');
          break;
        case 'notification.new':
          final notif = data['notification'] ?? {};
          debugPrint('[CustomerWSController] New Notification: ${notif['title']} - ${notif['body']}');
          break;
      }
    });
  }

  /// Request new ride booking
  void requestRide({
    required int vehicleTypeId,
    required double pickupLat,
    required double pickupLng,
    required String pickupAddress,
    required double dropLat,
    required double dropLng,
    required String dropAddress,
    String serviceMode = 'NORMAL',
    String bookingMode = 'INSTANT',
    String tripType = 'ONE_WAY',
    String paymentMethod = 'CASH',
  }) {
    _ws.send('booking.create', {
      'service_mode': serviceMode,
      'booking_mode': bookingMode,
      'trip_type': tripType,
      'vehicle_type_id': vehicleTypeId,
      'pickup_lat': pickupLat,
      'pickup_lng': pickupLng,
      'pickup_address': pickupAddress,
      'drop_lat': dropLat,
      'drop_lng': dropLng,
      'drop_address': dropAddress,
      'payment_method': paymentMethod,
    });
  }

  /// Cancel existing active ride booking via WS and HTTP REST
  void cancelRide({
    required String bookingId,
    String? reason,
  }) async {
    final cleanBookingId = bookingId.replaceAll(RegExp(r'[^0-9]'), '');
    final bIdInt = int.tryParse(cleanBookingId);
    final reasonStr = reason ?? 'Customer cancelled trip';

    // 1. Send WebSocket cancel event
    _ws.send('booking.cancel', {
      'booking_id': bIdInt ?? bookingId,
      'reason': reasonStr,
    });
    debugPrint('[CustomerWSController] Cancel ride WS sent for booking: $bookingId');

    // 2. HTTP REST fallback POST to backend to ensure DB status update
    try {
      final bIdPath = bIdInt != null ? '$bIdInt' : bookingId;
      await _dio.post(
        '${ApiConstants.baseUrl}/api/v1/bookings/$bIdPath/cancel',
        data: {'reason': reasonStr},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      debugPrint('[CustomerWSController] Cancel ride HTTP REST success');
    } catch (e) {
      try {
        final bIdPath = bIdInt != null ? '$bIdInt' : bookingId;
        await _dio.post(
          '${ApiConstants.baseUrl}/api/v1/customer/bookings/$bIdPath/cancel',
          data: {'reason': reasonStr},
          options: Options(headers: {'Content-Type': 'application/json'}),
        );
        debugPrint('[CustomerWSController] Customer cancel ride HTTP REST success');
      } catch (e2) {
        debugPrint('[CustomerWSController] HTTP cancel fallback notice: $e2');
      }
    }
  }

  void dispose() {
    _subscription?.cancel();
    _ws.disconnect();
  }

  /// Request custom/early drop location from customer side.
  void requestDrop({required dynamic bookingId, required String reason}) {
    final bIdInt = bookingId is String ? int.tryParse(bookingId.replaceAll(RegExp(r'[^0-9]'), '')) : bookingId;
    final payload = {
      'booking_id': bIdInt ?? bookingId,
      'requested_by': 'CUSTOMER',
      'reason': reason,
      'is_drop_requested': true,
      'timestamp': DateTime.now().toIso8601String(),
    };
    _ws.send('booking.drop_requested', payload);
    debugPrint('[CustomerWSController] Drop requested WS sent for booking: $bookingId, reason: $reason');
  }

  /// Approve a drop request from the rider / counterpart.
  void sendDropApproved({required dynamic bookingId}) {
    final bIdInt = bookingId is String ? int.tryParse(bookingId.replaceAll(RegExp(r'[^0-9]'), '')) : bookingId;
    final payload = {
      'booking_id': bIdInt ?? bookingId,
      'accepted_by': 'CUSTOMER',
      'is_drop_accepted': true,
      'timestamp': DateTime.now().toIso8601String(),
    };
    _ws.send('booking.drop_accepted', payload);
    _ws.send('booking.drop_approved', payload);
    debugPrint('[CustomerWSController] Drop accepted/approved WS sent for booking: $bookingId');
  }

  /// Reject a drop request from the rider with a reason.
  void sendDropRejected({required dynamic bookingId, required String reason}) {
    final bIdInt = bookingId is String ? int.tryParse(bookingId.replaceAll(RegExp(r'[^0-9]'), '')) : bookingId;
    _ws.send('booking.drop_rejected', {
      'booking_id': bIdInt ?? bookingId,
      'rejected_by': 'CUSTOMER',
      'reason': reason,
    });
    debugPrint('[CustomerWSController] Drop rejected WS sent for booking: $bookingId, reason: $reason');
  }
}
