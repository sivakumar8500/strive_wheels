import '../entities/auth_result.dart';

enum AuthStatus {
  approved,
  registrationPending,
  registrationDraft,
  registrationSubmitted,
  registrationRejected,
  failed,
}

abstract class AuthRepository {
  Future<bool> loginWithPhone(String phoneNumber);
  Future<AuthResult> verifyOtp(String phoneNumber, String otp);
}
