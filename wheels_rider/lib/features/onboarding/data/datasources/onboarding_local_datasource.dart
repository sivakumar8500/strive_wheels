import 'package:shared_preferences/shared_preferences.dart';

abstract class OnboardingLocalDataSource {
  Future<void> setOnboardingCompleted();
  Future<bool> isOnboardingCompleted();
}

class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  final SharedPreferences sharedPreferences;

  OnboardingLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> setOnboardingCompleted() async {
    await sharedPreferences.setBool('onboarding_completed', true);
  }

  @override
  Future<bool> isOnboardingCompleted() async {
    return sharedPreferences.getBool('onboarding_completed') ?? false;
  }
}
