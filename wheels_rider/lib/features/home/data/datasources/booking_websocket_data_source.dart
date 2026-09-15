import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';
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
      final event = message['event']?.toString();
      final Map<String, dynamic> data = (message['data'] is Map)
          ? Map<String, dynamic>.from(message['data'] as Map)
          : Map<String, dynamic>.from(message);

      if (event == null) return;

      switch (event) {
        case 'booking.new_request':
        case 'booking.created':
        case 'booking.requested':
        case 'booking.broadcast':
        case 'booking.near_by':
        case 'booking.searching':
        case 'booking_request':
        case 'ride.created':
        case 'ride.requested':
        case 'ride_request':
        case 'new_ride_request':
        case 'notification.new':
        case 'booking.status':
        case 'booking.status_response':
        case 'booking.status_info':
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
            if (data['pickup_address'] != null && bookingMap['pickup_address'] == null) {
              bookingMap['pickup_address'] = data['pickup_address'];
            }
            if (data['drop_address'] != null && bookingMap['drop_address'] == null) {
              bookingMap['drop_address'] = data['drop_address'];
            }
            if (data['estimated_fare'] != null && bookingMap['estimated_fare'] == null) {
              bookingMap['estimated_fare'] = data['estimated_fare'];
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

            final int? trueBookingId = parseInt(bookingMap['booking_id']) ??
                parseInt(bookingMap['id']) ??
                parseInt(data['booking_id']) ??
                parseInt(data['id']);

            final int? reqId = parseInt(data['request_id']) ?? parseInt(bookingMap['request_id']);

            if (trueBookingId != null) {
              bookingMap['id'] = trueBookingId;
              bookingMap['booking_id'] = trueBookingId;
            }
            if (reqId != null) {
              bookingMap['request_id'] = reqId;
            }

            if (bookingMap['pickup_lat'] != null) bookingMap['pickup_lat'] = parseDouble(bookingMap['pickup_lat']);
            if (bookingMap['pickup_lng'] != null) bookingMap['pickup_lng'] = parseDouble(bookingMap['pickup_lng']);
            if (bookingMap['drop_lat'] != null) bookingMap['drop_lat'] = parseDouble(bookingMap['drop_lat']);
            if (bookingMap['drop_lng'] != null) bookingMap['drop_lng'] = parseDouble(bookingMap['drop_lng']);
            if (bookingMap['estimated_fare'] != null) bookingMap['estimated_fare'] = parseDouble(bookingMap['estimated_fare']);

            _rideRequestController.add(RideRequestModel.fromJson(bookingMap));
          } catch (e) {
            debugPrint('[BookingWebSocket] Error parsing new ride request: $e');
          }
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
