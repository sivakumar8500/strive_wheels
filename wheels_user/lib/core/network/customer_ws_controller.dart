import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
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
          final lat = (data['lat'] as num?)?.toDouble();
          final lng = (data['lng'] as num?)?.toDouble();
          debugPrint('[CustomerWSController] Rider location update: $lat, $lng');
          break;
        case 'booking.arrived':
        case 'rider.arrived':
        case 'booking.rider_arrived':
          debugPrint('[CustomerWSController] Rider Arrived at Pickup!');
          break;
        case 'booking.started':
        case 'rider.trip_started':
        case 'booking.trip_started':
          debugPrint('[CustomerWSController] Trip Started!');
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
}
