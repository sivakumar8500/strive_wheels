import '../entities/auth_result.dart';
import '../repositories/auth_repository.dart';

class VerifyOtpUseCase {
  final AuthRepository repository;

  VerifyOtpUseCase(this.repository);

  Future<AuthResult> call(String phoneNumber, String otp) async {
    return await repository.verifyOtp(phoneNumber, otp);
  }
}

