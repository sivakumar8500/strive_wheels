import '../entities/login_request_entity.dart';
import '../repositories/login_repository.dart';

/// UseCase for sending OTP to user's mobile number.
class SendOtpUseCase {
  final LoginRepository repository;

  SendOtpUseCase(this.repository);

  Future<bool> call(LoginRequestEntity params) async {
    return await repository.sendOtp(params);
  }
}
