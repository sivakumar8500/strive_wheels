import '../repositories/registration_repository.dart';
import '../../data/models/registration_step_response.dart';

class SubmitRegistrationUsecase {
  final RegistrationRepository repository;

  SubmitRegistrationUsecase(this.repository);

  Future<RegistrationStepResponse> call(Map<String, dynamic> data) {
    return repository.submitRegistration(data);
  }
}