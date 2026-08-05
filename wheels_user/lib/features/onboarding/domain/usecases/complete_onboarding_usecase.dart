import '../repositories/onboarding_repository.dart';

/// UseCase to complete onboarding and mark first launch as false.
class CompleteOnboardingUseCase {
  final OnboardingRepository repository;

  CompleteOnboardingUseCase(this.repository);

  Future<void> call() async {
    await repository.completeOnboarding();
  }
}
