import '../repositories/splash_repository.dart';

class InitialAuthData {
  final bool isAuthenticated;
  final String? authStatus;
  final int? currentStep;
  final String? phoneNumber;

  InitialAuthData({
    required this.isAuthenticated,
    this.authStatus,
    this.currentStep,
    this.phoneNumber,
  });
}

/// Clean Architecture Use Case to check initial auth status during splash.
class CheckInitialAuthStatus {
  final SplashRepository repository;

  CheckInitialAuthStatus(this.repository);

  Future<InitialAuthData> call() async {
    final isAuthenticated = await repository.isUserAuthenticated();
    final authStatus = await repository.getAuthStatus();
    final currentStep = await repository.getCurrentStep();
    final phoneNumber = await repository.getPhoneNumber();
    
    return InitialAuthData(
      isAuthenticated: isAuthenticated,
      authStatus: authStatus,
      currentStep: currentStep,
      phoneNumber: phoneNumber,
    );
  }
}
