import '../repositories/rider_repository.dart';
import '../../data/models/booking_action_response.dart';

class AcceptBookingUseCase {
  final RiderRepository repository;

  AcceptBookingUseCase(this.repository);

  Future<BookingActionResponse> call(int bookingId) {
    return repository.acceptBooking(bookingId);
  }
}