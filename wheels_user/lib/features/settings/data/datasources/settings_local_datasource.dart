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
        name: AppStrings.alexanderPierce,
        membershipTier: AppStrings.diamondMember,
        totalRides: AppStrings.totalRidesCount,
        rating: AppStrings.ratingValue,
      ),
      rideNotificationsEnabled: true,
      isDarkMode: false,
      selectedLanguage: AppStrings.englishIndia,
      appVersion: AppStrings.appVersionString,
    );
  }
}
