/// Repository contract for Onboarding operations.
abstract class OnboardingRepository {
  /// Returns whether the app is launched for the first time.
  Future<bool> isFirstTime();

  /// Marks onboarding as completed.
  Future<void> completeOnboarding();
}
