import 'dart:async';
import '../../../../core/network/websocket_client.dart';
import '../models/ride_request_model.dart';

abstract class BookingWebSocketDataSource {
  void connect(int driverId, String token);
  void disconnect();
  void acceptBooking(int bookingId);
  Stream<RideRequestModel> get rideRequestsStream;
  Stream<int> get bookingSuccessStream;
  Stream<String> get errorStream;
}

class BookingWebSocketDataSourceImpl implements BookingWebSocketDataSource {
  final WebSocketClient webSocketClient;

  final _rideRequestController = StreamController<RideRequestModel>.broadcast();
  final _bookingSuccessController = StreamController<int>.broadcast();
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
          final bookingData = data['booking'] as Map<String, dynamic>?;
          if (bookingData != null) {
            _rideRequestController.add(RideRequestModel.fromJson(bookingData));
          }
          break;
        case 'booking.accepted_success':
          final bookingId = data['booking_id'] as int?;
          if (bookingId != null) {
            _bookingSuccessController.add(bookingId);
          }
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
  Stream<String> get errorStream => _errorController.stream;
}
