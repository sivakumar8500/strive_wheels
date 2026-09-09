import '../repositories/otp_repository.dart';

/// UseCase for requesting a new OTP code.
class ResendOtpUseCase {
  final OtpRepository repository;

  ResendOtpUseCase(this.repository);

  Future<bool> call(String fullPhoneNumber) async {
    return await repository.resendOtp(fullPhoneNumber);
  }
}
