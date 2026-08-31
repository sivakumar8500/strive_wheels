import 'package:shared_preferences/shared_preferences.dart';

abstract class SplashLocalDataSource {
  Future<bool> isAuthenticated();
  Future<String?> getAuthStatus();
  Future<int?> getCurrentStep();
  Future<String?> getPhoneNumber();
}

class SplashLocalDataSourceImpl implements SplashLocalDataSource {
  final SharedPreferences sharedPreferences;

  SplashLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<bool> isAuthenticated() async {
    return sharedPreferences.getBool('is_authenticated') ?? false;
  }

  @override
  Future<String?> getAuthStatus() async {
    return sharedPreferences.getString('auth_status');
  }

  @override
  Future<int?> getCurrentStep() async {
    return sharedPreferences.getInt('current_step');
  }

  @override
  Future<String?> getPhoneNumber() async {
    return sharedPreferences.getString('phone_number');
  }
}
