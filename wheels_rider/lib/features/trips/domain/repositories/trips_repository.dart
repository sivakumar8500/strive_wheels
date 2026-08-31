import '../entities/trip_entity.dart';

abstract class TripsRepository {
  Future<TripEntity> getTrips(int limit, int offset);
}
