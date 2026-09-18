import '../../../../core/constants/app_strings.dart';
import '../models/settings_model.dart';
import '../models/user_profile_model.dart';

abstract class SettingsLocalDataSource {
  Future<SettingsModel> getSettingsData();
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  const SettingsLocalDataSourceImpl();

  @override
  Future<SettingsModel> getSettingsData() async {
    return const SettingsModel(
      profile: UserProfileModel(
        name: 'Puja Sri',
        membershipTier: AppStrings.diamondMember,
        totalRides: AppStrings.totalRidesCount,
        rating: AppStrings.ratingValue,
        phone: '+91 98765 43210',
        email: 'pujasri@strive.com',
        gender: 'Female',
        isCorporate: false,
      ),
      rideNotificationsEnabled: true,
      isDarkMode: false,
      selectedLanguage: AppStrings.englishIndia,
      appVersion: AppStrings.appVersionString,
    );
  }
}
