import '../repositories/rider_repository.dart';
import '../../data/models/booking_action_response.dart';

class StartTripUseCase {
  final RiderRepository repository;

  StartTripUseCase(this.repository);

  Future<BookingActionResponse> call({required int bookingId, required String otp}) {
    return repository.startTrip(bookingId: bookingId, otp: otp);
  }
}