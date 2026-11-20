import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/settings_entity.dart';
import 'user_profile_model.dart';

part 'settings_model.freezed.dart';

@freezed
abstract class SettingsModel with _$SettingsModel {
  const factory SettingsModel({
    required UserProfileModel profile,
    required bool rideNotificationsEnabled,
    required bool isDarkMode,
    required String selectedLanguage,
    required String appVersion,
  }) = _SettingsModel;

  factory SettingsModel.fromJson(dynamic rawJson) {
    final Map<String, dynamic> json = rawJson is Map<String, dynamic>
        ? rawJson
        : (rawJson is Map ? Map<String, dynamic>.from(rawJson) : {});

    final profileJson = json['profile'] ?? json['data'] ?? json;

    final bool rideNotifs = json['rideNotificationsEnabled'] == true ||
        json['ride_notifications_enabled'] == true ||
        (json['rideNotificationsEnabled'] != false && json['ride_notifications_enabled'] != false);

    final bool dark = json['isDarkMode'] == true || json['is_dark_mode'] == true;

    return SettingsModel(
      profile: UserProfileModel.fromJson(profileJson),
      rideNotificationsEnabled: rideNotifs,
      isDarkMode: dark,
      selectedLanguage:
          (json['selectedLanguage'] ?? json['selected_language'] ?? 'English (India)').toString(),
      appVersion:
          (json['appVersion'] ?? json['app_version'] ?? 'v2.4.1 (build 108)').toString(),
    );
  }
}

extension SettingsModelX on SettingsModel {
  SettingsEntity toEntity() => SettingsEntity(
        profile: profile.toEntity(),
        rideNotificationsEnabled: rideNotificationsEnabled,
        isDarkMode: isDarkMode,
        selectedLanguage: selectedLanguage,
        appVersion: appVersion,
      );
}
