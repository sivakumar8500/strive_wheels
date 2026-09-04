import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUserToken(String token);
  Future<void> cacheAuthData({
    required bool isAuthenticated,
    required String authStatus,
    int? currentStep,
    String? phoneNumber,
  });
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheUserToken(String token) async {
    await sharedPreferences.setString('user_token', token);
  }

  @override
  Future<void> cacheAuthData({
    required bool isAuthenticated,
    required String authStatus,
    int? currentStep,
    String? phoneNumber,
  }) async {
    await sharedPreferences.setBool('is_authenticated', isAuthenticated);
    await sharedPreferences.setString('auth_status', authStatus);
    if (currentStep != null) {
      await sharedPreferences.setInt('current_step', currentStep);
    }
    if (phoneNumber != null) {
      await sharedPreferences.setString('phone_number', phoneNumber);
    }
  }
}
