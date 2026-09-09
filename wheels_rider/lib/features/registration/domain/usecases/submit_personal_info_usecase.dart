import '../repositories/registration_repository.dart';
import '../../data/models/registration_step_response.dart';

class SubmitPersonalInfoUsecase {
  final RegistrationRepository repository;

  SubmitPersonalInfoUsecase(this.repository);

  Future<RegistrationStepResponse> call(Map<String, dynamic> data) {
    return repository.submitPersonalInfo(data);
  }
}