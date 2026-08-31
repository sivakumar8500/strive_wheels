import '../../domain/entities/ride_request_entity.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/booking_websocket_data_source.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingWebSocketDataSource webSocketDataSource;

  BookingRepositoryImpl({required this.webSocketDataSource});

  @override
  void connectToBookingSocket(int driverId, String token) {
    webSocketDataSource.connect(driverId, token);
  }

  @override
  void disconnect() {
    webSocketDataSource.disconnect();
  }

  @override
  void acceptBooking(int bookingId) {
    webSocketDataSource.acceptBooking(bookingId);
  }

  @override
  Stream<RideRequestEntity> get rideRequestsStream => webSocketDataSource.rideRequestsStream.map((model) => model.toEntity());

  @override
  Stream<int> get bookingSuccessStream => webSocketDataSource.bookingSuccessStream;

  @override
  Stream<String> get errorStream => webSocketDataSource.errorStream;
}
