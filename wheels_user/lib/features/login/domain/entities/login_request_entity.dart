/// Entity representing login/OTP request data in domain layer.
class LoginRequestEntity {
  final String countryCode;
  final String phoneNumber;

  const LoginRequestEntity({
    required this.countryCode,
    required this.phoneNumber,
  });

  String get fullPhoneNumber => '$countryCode$phoneNumber';
}
