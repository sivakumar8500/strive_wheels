abstract class AuthRepository {
  Future<bool> loginWithPhone(String phoneNumber);
  Future<bool> verifyOtp(String phoneNumber, String otp);
}
