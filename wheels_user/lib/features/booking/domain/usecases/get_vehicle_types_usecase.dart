import '../entities/vehicle_type_entity.dart';
import '../repositories/booking_repository.dart';

class GetVehicleTypesUseCase {
  final BookingRepository repository;

  GetVehicleTypesUseCase(this.repository);

  Future<List<VehicleTypeEntity>> call() async {
    return await repository.getVehicleTypes();
  }
}
