import '../entities/recent_journey_entity.dart';
import '../entities/vehicle_option_entity.dart';

abstract class BookingRepository {
  Future<List<RecentJourneyEntity>> getRecentJourneys();
  Future<List<VehicleOptionEntity>> getAvailableVehicles();
}
