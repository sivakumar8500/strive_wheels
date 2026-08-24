import '../../repositories/registration_repository.dart';
import '../../../data/models/registration_step_response.dart';

class SubmitVehicleDocsUsecase {
  final RegistrationRepository repository;

  SubmitVehicleDocsUsecase(this.repository);

  Future<RegistrationStepResponse> call(Map<String, dynamic> data) {
    return repository.submitVehicleDocuments(data);
  }
}