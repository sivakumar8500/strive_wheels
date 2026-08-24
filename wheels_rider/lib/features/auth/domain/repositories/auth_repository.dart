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
  Future<AuthStatus> verifyOtp(String phoneNumber, String otp);
}
