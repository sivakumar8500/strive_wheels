import 'package:flutter/foundation.dart';
import '../../../trips/data/datasources/rider_remote_data_source.dart';
import '../../domain/entities/ride_request_entity.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/booking_websocket_data_source.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingWebSocketDataSource webSocketDataSource;
  final RiderRemoteDataSource? remoteDataSource;

  BookingRepositoryImpl({
    required this.webSocketDataSource,
    this.remoteDataSource,
  });

  @override
  void connectToBookingSocket(int driverId, String token) {
    webSocketDataSource.connect(driverId, token);
  }

  @override
  void disconnect() {
    webSocketDataSource.disconnect();
  }

  @override
  void acceptBooking(int bookingId) async {
    webSocketDataSource.acceptBooking(bookingId);
    webSocketDataSource.notifyBookingSuccess(bookingId);

    if (remoteDataSource != null) {
      try {
        await remoteDataSource!.acceptBooking(bookingId);
      } catch (e) {
        debugPrint('[BookingRepositoryImpl] REST accept error: $e');
      }
    }
  }

  @override
  void sendLocationPing({
    required double lat,
    required double lng,
    double heading = 0.0,
    double speedKmh = 0.0,
  }) {
    webSocketDataSource.sendLocationPing(
      lat: lat,
      lng: lng,
      heading: heading,
      speedKmh: speedKmh,
    );
  }

  @override
  Stream<RideRequestEntity> get rideRequestsStream => webSocketDataSource.rideRequestsStream.map((model) => model.toEntity());

  @override
  Stream<int> get bookingSuccessStream => webSocketDataSource.bookingSuccessStream;

  @override
  Stream<String> get errorStream => webSocketDataSource.errorStream;
}
