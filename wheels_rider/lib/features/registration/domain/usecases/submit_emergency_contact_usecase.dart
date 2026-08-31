import '../repositories/registration_repository.dart';
import '../../data/models/registration_step_response.dart';

class SubmitEmergencyContactUsecase {
  final RegistrationRepository repository;

  SubmitEmergencyContactUsecase(this.repository);

  Future<RegistrationStepResponse> call(Map<String, dynamic> data) {
    return repository.submitEmergencyContact(data);
  }
}