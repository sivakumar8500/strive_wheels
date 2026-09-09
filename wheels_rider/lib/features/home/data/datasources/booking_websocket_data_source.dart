import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../../core/network/websocket_client.dart';
import '../models/ride_request_model.dart';

abstract class BookingWebSocketDataSource {
  void connect(int driverId, String token);
  void disconnect();
  void acceptBooking(int bookingId);
  Stream<RideRequestModel> get rideRequestsStream;
  Stream<int> get bookingSuccessStream;
  Stream<Map<String, dynamic>> get rideCancelledStream;
  Stream<String> get errorStream;
}

class BookingWebSocketDataSourceImpl implements BookingWebSocketDataSource {
  final WebSocketClient webSocketClient;

  final _rideRequestController = StreamController<RideRequestModel>.broadcast();
  final _bookingSuccessController = StreamController<int>.broadcast();
  final _rideCancelledController = StreamController<Map<String, dynamic>>.broadcast();
  final _errorController = StreamController<String>.broadcast();
  
  StreamSubscription? _subscription;

  BookingWebSocketDataSourceImpl({required this.webSocketClient});

  @override
  void connect(int driverId, String token) {
    webSocketClient.connect(driverId, token);
    
    _subscription?.cancel();
    _subscription = webSocketClient.messageStream.listen((message) {
      final event = message['event'] as String?;
      final data = message['data'] as Map<String, dynamic>?;

      if (event == null || data == null) return;

      switch (event) {
        case 'booking.new_request':
        case 'booking.created':
        case 'booking.requested':
        case 'booking.create':
        case 'ride_request':
        case 'new_booking':
          final bookingData = (data['booking'] as Map<String, dynamic>?) ?? data;
          if (bookingData.isNotEmpty) {
            try {
              _rideRequestController.add(RideRequestModel.fromJson(bookingData));
            } catch (e) {
              debugPrint('[BookingWS] Error parsing RideRequestModel: $e');
            }
          }
          break;
        case 'booking.accepted_success':
          final bookingId = data['booking_id'] as int?;
          if (bookingId != null) {
            _bookingSuccessController.add(bookingId);
          }
          break;
        case 'booking.cancelled':
        case 'booking.customer_cancelled':
        case 'booking.request_cancelled':
        case 'booking.cancel':
        case 'booking.cancel_success':
          debugPrint('[BookingWS] Cancellation event received: $event with data: $data');
          _rideCancelledController.add(data);
          break;
        case 'error':
          final errorMessage = data['message'] as String? ?? 'Unknown WebSocket Error';
          _errorController.add(errorMessage);
          break;
      }
    });
  }

  @override
  void disconnect() {
    _subscription?.cancel();
    webSocketClient.disconnect();
  }

  @override
  void acceptBooking(int bookingId) {
    webSocketClient.sendMessage({
      'event': 'booking.accept',
      'data': {
        'booking_id': bookingId,
      }
    });
  }

  @override
  Stream<RideRequestModel> get rideRequestsStream => _rideRequestController.stream;

  @override
  Stream<int> get bookingSuccessStream => _bookingSuccessController.stream;

  @override
  Stream<Map<String, dynamic>> get rideCancelledStream => _rideCancelledController.stream;

  @override
  Stream<String> get errorStream => _errorController.stream;
}
