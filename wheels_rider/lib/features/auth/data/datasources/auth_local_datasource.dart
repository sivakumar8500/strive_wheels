import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUserToken(String token, {String? refreshToken});
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
  Future<void> cacheUserToken(String token, {String? refreshToken}) async {
    await sharedPreferences.setString('user_token', token);
    await sharedPreferences.setString('access_token', token);
    if (refreshToken != null && refreshToken.isNotEmpty) {
      await sharedPreferences.setString('user_refresh_token', refreshToken);
      await sharedPreferences.setString('refresh_token', refreshToken);
    }
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
