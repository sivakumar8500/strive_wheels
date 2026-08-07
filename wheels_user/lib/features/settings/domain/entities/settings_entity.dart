import 'user_profile_entity.dart';

class SettingsEntity {
  final UserProfileEntity profile;
  final bool rideNotificationsEnabled;
  final bool isDarkMode;
  final String selectedLanguage;
  final String appVersion;

  const SettingsEntity({
    required this.profile,
    required this.rideNotificationsEnabled,
    required this.isDarkMode,
    required this.selectedLanguage,
    required this.appVersion,
  });
}
