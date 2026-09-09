import '../entities/trip_overview_entity.dart';
import '../repositories/trip_overview_repository.dart';

class GetTripOverviewUseCase {
  final TripOverviewRepository repository;

  GetTripOverviewUseCase(this.repository);

  Future<TripOverviewEntity> call([String vehicleId = 'v1']) async {
    return await repository.getTripOverviewDetails(vehicleId);
  }
}
