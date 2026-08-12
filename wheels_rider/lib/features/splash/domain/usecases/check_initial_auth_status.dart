import '../repositories/splash_repository.dart';

/// Clean Architecture Use Case to check initial auth status during splash.
class CheckInitialAuthStatus {
  final SplashRepository repository;

  CheckInitialAuthStatus(this.repository);

  Future<bool> call() async {
    return await repository.isUserAuthenticated();
  }
}
