import '../repositories/registration_repository.dart';
import '../../data/models/registration_step_response.dart';

class SubmitVehicleDetailsUsecase {
  final RegistrationRepository repository;

  SubmitVehicleDetailsUsecase(this.repository);

  Future<RegistrationStepResponse> call(Map<String, dynamic> data) {
    return repository.submitVehicleDetails(data);
  }
}