import 'dart:async';
import '../../../../core/network/websocket_client.dart';
import '../models/ride_request_model.dart';

abstract class BookingWebSocketDataSource {
  void connect(int driverId, String token);
  void disconnect();
  void acceptBooking(int bookingId);
  void cancelBooking(int bookingId, {String reason});
  void notifyBookingSuccess(int bookingId);
  void sendLocationPing({
    required double lat,
    required double lng,
    double heading,
    double speedKmh,
  });
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
          Map<String, dynamic> bookingMap = {};
          if (data['booking'] is Map<String, dynamic>) {
            bookingMap = Map<String, dynamic>.from(data['booking'] as Map<String, dynamic>);
          } else {
            bookingMap = Map<String, dynamic>.from(data);
          }

          final int? trueBookingId = (bookingMap['booking_id'] as int?) ??
              (bookingMap['id'] as int?) ??
              (data['booking_id'] as int?) ??
              (data['id'] as int?);

          final int? reqId = (data['request_id'] as int?) ?? (bookingMap['request_id'] as int?);

          if (trueBookingId != null) {
            bookingMap['id'] = trueBookingId;
            bookingMap['booking_id'] = trueBookingId;
          }
          if (reqId != null) {
            bookingMap['request_id'] = reqId;
          }

          _rideRequestController.add(RideRequestModel.fromJson(bookingMap));
          break;
        case 'booking.accepted_success':
        case 'booking.rider_accepted':
        case 'booking.accepted':
          final bookingId = data['booking_id'] as int? ?? (data['booking'] as Map<String, dynamic>?)?['id'] as int?;
          if (bookingId != null) {
            _bookingSuccessController.add(bookingId);
          }
          break;
        case 'booking.cancelled':
        case 'booking.canceled':
        case 'ride.cancelled':
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
        'request_id': bookingId,
        'id': bookingId,
      }
    });
  }

  @override
  void cancelBooking(int bookingId, {String reason = 'Rider cancelled trip'}) {
    webSocketClient.sendMessage({
      'event': 'booking.cancel',
      'data': {
        'booking_id': bookingId,
        'id': bookingId,
        'reason': reason,
      }
    });
  }

  @override
  void notifyBookingSuccess(int bookingId) {
    _bookingSuccessController.add(bookingId);
  }

  @override
  void sendLocationPing({
    required double lat,
    required double lng,
    double heading = 0.0,
    double speedKmh = 0.0,
  }) {
    webSocketClient.sendLocationPing(
      lat: lat,
      lng: lng,
      heading: heading,
      speedKmh: speedKmh,
    );
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
