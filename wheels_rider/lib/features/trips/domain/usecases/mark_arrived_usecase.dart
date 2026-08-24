import '../repositories/rider_repository.dart';
import '../../data/models/booking_action_response.dart';

class MarkArrivedUseCase {
  final RiderRepository repository;

  MarkArrivedUseCase(this.repository);

  Future<BookingActionResponse> call(int bookingId) {
    return repository.markArrived(bookingId);
  }
}