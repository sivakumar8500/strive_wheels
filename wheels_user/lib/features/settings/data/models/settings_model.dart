import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/settings_entity.dart';
import 'user_profile_model.dart';

part 'settings_model.freezed.dart';
part 'settings_model.g.dart';

@freezed
abstract class SettingsModel with _$SettingsModel {
  const factory SettingsModel({
    required UserProfileModel profile,
    required bool rideNotificationsEnabled,
    required bool isDarkMode,
    required String selectedLanguage,
    required String appVersion,
  }) = _SettingsModel;

  factory SettingsModel.fromJson(Map<String, dynamic> json) =>
      _$SettingsModelFromJson(json);
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
