import '../repositories/rider_repository.dart';
import '../../data/models/booking_action_response.dart';

class CompleteTripUseCase {
  final RiderRepository repository;

  CompleteTripUseCase(this.repository);

  Future<BookingActionResponse> call({required int bookingId, required double distanceKm, required int durationMins}) {
    return repository.completeTrip(bookingId: bookingId, distanceKm: distanceKm, durationMins: durationMins);
  }
}