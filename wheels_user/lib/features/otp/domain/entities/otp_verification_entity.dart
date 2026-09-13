/// Entity representing OTP verification request in domain layer.
class OtpVerificationEntity {
  final String fullPhoneNumber;
  final String otpCode;
  final String? fullName;
  final String role;

  const OtpVerificationEntity({
    required this.fullPhoneNumber,
    required this.otpCode,
    this.fullName,
    this.role = 'CUSTOMER',
  });
}
