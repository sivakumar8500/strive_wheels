import '../entities/otp_verification_entity.dart';

/// Abstract repository contract for OTP verification feature.
abstract class OtpRepository {
  Future<bool> verifyOtp(OtpVerificationEntity entity);
  Future<bool> resendOtp(String fullPhoneNumber);
}
