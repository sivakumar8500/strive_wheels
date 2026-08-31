import '../../domain/repositories/booking_repository.dart';
import '../../domain/entities/ride_request_entity.dart';

class ConnectToBookingSocketUseCase {
  final BookingRepository repository;

  ConnectToBookingSocketUseCase(this.repository);

  void call(int driverId, String token) {
    repository.connectToBookingSocket(driverId, token);
  }
}

class DisconnectBookingSocketUseCase {
  final BookingRepository repository;

  DisconnectBookingSocketUseCase(this.repository);

  void call() {
    repository.disconnect();
  }
}

class AcceptBookingUseCase {
  final BookingRepository repository;

  AcceptBookingUseCase(this.repository);

  void call(int bookingId) {
    repository.acceptBooking(bookingId);
  }
}

class GetRideRequestsStreamUseCase {
  final BookingRepository repository;

  GetRideRequestsStreamUseCase(this.repository);

  Stream<RideRequestEntity> call() {
    return repository.rideRequestsStream;
  }
}

class GetBookingSuccessStreamUseCase {
  final BookingRepository repository;

  GetBookingSuccessStreamUseCase(this.repository);

  Stream<int> call() {
    return repository.bookingSuccessStream;
  }
}

class GetBookingErrorStreamUseCase {
  final BookingRepository repository;

  GetBookingErrorStreamUseCase(this.repository);

  Stream<String> call() {
    return repository.errorStream;
  }
}
