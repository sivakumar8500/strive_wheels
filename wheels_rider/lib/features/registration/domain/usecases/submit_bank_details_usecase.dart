import '../repositories/registration_repository.dart';
import '../../data/models/registration_step_response.dart';

class SubmitBankDetailsUsecase {
  final RegistrationRepository repository;

  SubmitBankDetailsUsecase(this.repository);

  Future<RegistrationStepResponse> call(Map<String, dynamic> data) {
    return repository.submitBankDetails(data);
  }
}