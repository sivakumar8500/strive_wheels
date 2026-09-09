import '../entities/trip_entity.dart';
import '../repositories/trips_repository.dart';

class GetTripsUseCase {
  final TripsRepository repository;

  GetTripsUseCase(this.repository);

  Future<TripEntity> call(int limit, int offset) async {
    return await repository.getTrips(limit, offset);
  }
}
