import '../repositories/registration_repository.dart';

class GetVehicleTypesUseCase {
  final RegistrationRepository repository;

  GetVehicleTypesUseCase(this.repository);

  Future<List<dynamic>> call() {
    return repository.getVehicleTypes();
  }
}
