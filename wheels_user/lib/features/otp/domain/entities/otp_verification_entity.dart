/// Entity representing OTP verification request in domain layer.
class OtpVerificationEntity {
  final String fullPhoneNumber;
  final String otpCode;

  const OtpVerificationEntity({
    required this.fullPhoneNumber,
    required this.otpCode,
  });
}
