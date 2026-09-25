import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_strings.dart';
import '../models/settings_model.dart';
import '../models/user_profile_model.dart';

abstract class SettingsLocalDataSource {
  Future<SettingsModel> getSettingsData();
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final SharedPreferences sharedPreferences;

  const SettingsLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<SettingsModel> getSettingsData() async {
    UserProfileModel profile;
    final savedProfileStr = sharedPreferences.getString('saved_customer_profile');
    if (savedProfileStr != null && savedProfileStr.isNotEmpty) {
      try {
        final decoded = jsonDecode(savedProfileStr);
        profile = UserProfileModel.fromJson(decoded);
      } catch (_) {
        profile = _buildProfileFromKeys();
      }
    } else {
      profile = _buildProfileFromKeys();
    }

    return SettingsModel(
      profile: profile,
      rideNotificationsEnabled: true,
      isDarkMode: false,
      selectedLanguage: AppStrings.englishIndia,
      appVersion: AppStrings.appVersionString,
    );
  }

  UserProfileModel _buildProfileFromKeys() {
    final name = sharedPreferences.getString('user_name') ?? 'User';
    final phone = sharedPreferences.getString('user_phone') ?? '';
    final email = sharedPreferences.getString('user_email') ?? '';
    final isCorporate = sharedPreferences.getBool('is_corporate_user') ?? false;
    final companyName = sharedPreferences.getString('corporate_company_name');
    final employeeCode = sharedPreferences.getString('corporate_employee_code');
    final spendingLimit = sharedPreferences.getString('corporate_spending_limit');
    final corpEmail = sharedPreferences.getString('corporate_email');
    final corpLocation = sharedPreferences.getString('corporate_location');

    return UserProfileModel(
      name: name,
      membershipTier: AppStrings.diamondMember,
      totalRides: '0',
      rating: '5.0',
      phone: phone,
      email: email,
      gender: 'Not Specified',
      isCorporate: isCorporate,
      companyName: companyName,
      corporateEmail: corpEmail,
      corporateId: employeeCode,
      spendingLimit: spendingLimit,
      companyLocation: corpLocation,
    );
  }
}
