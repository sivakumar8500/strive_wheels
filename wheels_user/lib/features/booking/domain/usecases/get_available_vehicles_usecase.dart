import '../entities/vehicle_option_entity.dart';
import '../repositories/booking_repository.dart';

class GetAvailableVehiclesUseCase {
  final BookingRepository repository;

  GetAvailableVehiclesUseCase(this.repository);

  Future<List<VehicleOptionEntity>> call() async {
    return await repository.getAvailableVehicles();
  }
}
