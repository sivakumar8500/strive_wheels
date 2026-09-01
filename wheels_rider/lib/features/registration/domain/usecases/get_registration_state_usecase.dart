import '../repositories/registration_repository.dart';
import '../../data/models/registration_step_response.dart';

class GetRegistrationStateUseCase {
  final RegistrationRepository repository;

  GetRegistrationStateUseCase(this.repository);

  Future<RegistrationStepResponse> call() {
    return repository.getRegistrationState();
  }
}
