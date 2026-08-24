import '../../repositories/registration_repository.dart';
import '../../../data/models/registration_step_response.dart';

class SubmitKycUsecase {
  final RegistrationRepository repository;

  SubmitKycUsecase(this.repository);

  Future<RegistrationStepResponse> call(Map<String, dynamic> data) {
    return repository.submitKyc(data);
  }
}