import '../repositories/onboarding_repository.dart';

class CheckFirstTimeUseCase {
  final OnboardingRepository repository;

  CheckFirstTimeUseCase(this.repository);

  Future<bool> call() async {
    final isCompleted = await repository.isOnboardingCompleted();
    return !isCompleted;
  }
}
