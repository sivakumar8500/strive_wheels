import '../../domain/entities/vehicle_details_entity.dart';
import '../../domain/repositories/vehicle_details_repository.dart';
import '../datasources/vehicle_details_local_datasource.dart';
import '../models/vehicle_details_model.dart';

class VehicleDetailsRepositoryImpl implements VehicleDetailsRepository {
  final VehicleDetailsLocalDataSource localDataSource;

  VehicleDetailsRepositoryImpl({required this.localDataSource});

  @override
  Future<VehicleDetailsEntity> getVehicleDetails(String vehicleId) async {
    final model = await localDataSource.getVehicleDetails(vehicleId);
    return model.toEntity();
  }
}
