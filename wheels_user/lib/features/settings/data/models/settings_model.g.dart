// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SettingsModel _$SettingsModelFromJson(Map<String, dynamic> json) =>
    _SettingsModel(
      profile: UserProfileModel.fromJson(
        json['profile'] as Map<String, dynamic>,
      ),
      rideNotificationsEnabled: json['rideNotificationsEnabled'] as bool,
      isDarkMode: json['isDarkMode'] as bool,
      selectedLanguage: json['selectedLanguage'] as String,
      appVersion: json['appVersion'] as String,
    );

Map<String, dynamic> _$SettingsModelToJson(_SettingsModel instance) =>
    <String, dynamic>{
      'profile': instance.profile,
      'rideNotificationsEnabled': instance.rideNotificationsEnabled,
      'isDarkMode': instance.isDarkMode,
      'selectedLanguage': instance.selectedLanguage,
      'appVersion': instance.appVersion,
    };
