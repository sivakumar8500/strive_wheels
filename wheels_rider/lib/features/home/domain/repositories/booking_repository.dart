import '../../domain/entities/ride_request_entity.dart';

abstract class BookingRepository {
  void connectToBookingSocket(int driverId, String token);
  void disconnect();
  void acceptBooking(int bookingId);
  Stream<RideRequestEntity> get rideRequestsStream;
  Stream<int> get bookingSuccessStream;
  Stream<Map<String, dynamic>> get rideCancelledStream;
  Stream<String> get errorStream;
}
