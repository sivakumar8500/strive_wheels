
import '../repositories/registration_repository.dart';
import '../../data/models/registration_step_response.dart';

class SubmitAddressUsecase {
  final RegistrationRepository repository;

  SubmitAddressUsecase(this.repository);

  Future<RegistrationStepResponse> call(Map<String, dynamic> data) {
    return repository.submitAddress(data);
  }
}