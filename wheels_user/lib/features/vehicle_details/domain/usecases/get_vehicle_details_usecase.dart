import '../entities/vehicle_details_entity.dart';
import '../repositories/vehicle_details_repository.dart';

class GetVehicleDetailsUseCase {
  final VehicleDetailsRepository repository;

  GetVehicleDetailsUseCase(this.repository);

  Future<VehicleDetailsEntity> call(String vehicleId) async {
    return await repository.getVehicleDetails(vehicleId);
  }
}
