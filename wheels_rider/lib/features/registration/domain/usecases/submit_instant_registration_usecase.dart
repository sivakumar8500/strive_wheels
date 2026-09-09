import '../repositories/registration_repository.dart';
import '../../data/models/registration_step_response.dart';

class SubmitInstantRegistrationUseCase {
  final RegistrationRepository repository;

  SubmitInstantRegistrationUseCase(this.repository);

  Future<RegistrationStepResponse> call() {
    return repository.submitInstantRegistration();
  }
}
