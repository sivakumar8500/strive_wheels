import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class OnboardingLocalDataSource {
  Future<bool> isFirstTime();
  Future<void> setFirstTimeCompleted();
}

class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  static const String keyIsFirstTime = 'is_first_time_launch';
  final SharedPreferences? sharedPreferences;

  OnboardingLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<bool> isFirstTime() async {
    try {
      if (sharedPreferences == null) return true;
      return sharedPreferences!.getBool(keyIsFirstTime) ?? true;
    } catch (e) {
      debugPrint('Error accessing SharedPreferences isFirstTime: $e');
      return true;
    }
  }

  @override
  Future<void> setFirstTimeCompleted() async {
    try {
      if (sharedPreferences != null) {
        await sharedPreferences!.setBool(keyIsFirstTime, false);
      }
    } catch (e) {
      debugPrint('Error writing to SharedPreferences setFirstTimeCompleted: $e');
    }
  }
}
