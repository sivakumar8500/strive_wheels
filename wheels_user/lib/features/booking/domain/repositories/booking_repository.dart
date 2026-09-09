import '../entities/fare_estimate_entity.dart';
import '../entities/recent_journey_entity.dart';
import '../entities/vehicle_option_entity.dart';
import '../entities/vehicle_type_entity.dart';

abstract class BookingRepository {
  Future<List<RecentJourneyEntity>> getRecentJourneys();
  Future<List<VehicleOptionEntity>> getAvailableVehicles();
  Future<List<VehicleTypeEntity>> getVehicleTypes();
  Future<FareEstimateEntity> getFareEstimate({
    required int vehicleTypeId,
    required double pickupLat,
    required double pickupLng,
    required double dropLat,
    required double dropLng,
    double distanceKm = 0.0,
    int durationMins = 0,
    String serviceMode = 'NORMAL',
    String bookingMode = 'INSTANT',
    String tripType = 'ONE_WAY',
    String couponCode = 'string',
    bool isAc = true,
    bool isOutstation = false,
    int vehicleAgeYears = 2,
    String weather = 'CLEAR',
    String trafficLevel = 'LOW',
  });
}
