import '../entities/recent_journey_entity.dart';
import '../repositories/booking_repository.dart';

class GetRecentJourneysUseCase {
  final BookingRepository repository;

  GetRecentJourneysUseCase(this.repository);

  Future<List<RecentJourneyEntity>> call() async {
    return await repository.getRecentJourneys();
  }
}
