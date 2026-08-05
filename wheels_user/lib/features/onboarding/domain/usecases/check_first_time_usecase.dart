import '../repositories/onboarding_repository.dart';

/// UseCase to check if app launch is the first installation/time.
class CheckFirstTimeUseCase {
  final OnboardingRepository repository;

  CheckFirstTimeUseCase(this.repository);

  Future<bool> call() async {
    return await repository.isFirstTime();
  }
}
