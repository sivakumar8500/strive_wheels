import '../entities/vehicle_details_entity.dart';

abstract class VehicleDetailsRepository {
  Future<VehicleDetailsEntity> getVehicleDetails(String vehicleId);
}
