import '../entities/trip_overview_entity.dart';

abstract class TripOverviewRepository {
  Future<TripOverviewEntity> getTripOverviewDetails(String vehicleId);
}
