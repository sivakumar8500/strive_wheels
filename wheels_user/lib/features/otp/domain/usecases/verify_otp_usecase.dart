import '../entities/otp_verification_entity.dart';
import '../repositories/otp_repository.dart';

/// UseCase for verifying 6-digit OTP code.
class VerifyOtpUseCase {
  final OtpRepository repository;

  VerifyOtpUseCase(this.repository);

  Future<bool> call(OtpVerificationEntity params) async {
    return await repository.verifyOtp(params);
  }
}
