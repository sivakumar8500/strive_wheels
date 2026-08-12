import '../repositories/auth_repository.dart';

class LoginWithPhoneUseCase {
  final AuthRepository repository;

  LoginWithPhoneUseCase(this.repository);

  Future<bool> call(String phoneNumber) async {
    return await repository.loginWithPhone(phoneNumber);
  }
}
