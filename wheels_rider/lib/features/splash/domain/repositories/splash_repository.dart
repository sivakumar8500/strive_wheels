/// Repository interface for Splash initialization logic.
abstract class SplashRepository {
  Future<bool> isUserAuthenticated();
  Future<String?> getAuthStatus();
  Future<int?> getCurrentStep();
  Future<String?> getPhoneNumber();
}
