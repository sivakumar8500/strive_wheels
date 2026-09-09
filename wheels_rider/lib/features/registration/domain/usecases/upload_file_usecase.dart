import '../repositories/registration_repository.dart';

class UploadFileUseCase {
  final RegistrationRepository repository;

  UploadFileUseCase(this.repository);

  Future<String> call(String filePath) async {
    return await repository.uploadFile(filePath);
  }
}
