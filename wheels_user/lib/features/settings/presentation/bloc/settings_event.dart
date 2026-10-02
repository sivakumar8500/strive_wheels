abstract class SettingsEvent {
  const SettingsEvent();
}

class LoadSettingsEvent extends SettingsEvent {
  const LoadSettingsEvent();
}

class ToggleRideNotificationsEvent extends SettingsEvent {
  final bool enabled;

  const ToggleRideNotificationsEvent(this.enabled);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ToggleRideNotificationsEvent &&
          runtimeType == other.runtimeType &&
          enabled == other.enabled;

  @override
  int get hashCode => enabled.hashCode;
}

class ToggleDarkModeEvent extends SettingsEvent {
  final bool isDarkMode;

  const ToggleDarkModeEvent(this.isDarkMode);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ToggleDarkModeEvent &&
          runtimeType == other.runtimeType &&
          isDarkMode == other.isDarkMode;

  @override
  int get hashCode => isDarkMode.hashCode;
}

class SelectSettingItemEvent extends SettingsEvent {
  final String itemName;

  const SelectSettingItemEvent(this.itemName);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SelectSettingItemEvent &&
          runtimeType == other.runtimeType &&
          itemName == other.itemName;

  @override
  int get hashCode => itemName.hashCode;
}

class LogoutEvent extends SettingsEvent {
  const LogoutEvent();
}

class UpdateUserProfileEvent extends SettingsEvent {
  final String name;
  final String phone;
  final String email;
  final String gender;
  final String? profileImagePath;

  const UpdateUserProfileEvent({
    required this.name,
    required this.phone,
    required this.email,
    required this.gender,
    this.profileImagePath,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UpdateUserProfileEvent &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          phone == other.phone &&
          email == other.email &&
          gender == other.gender &&
          profileImagePath == other.profileImagePath;

  @override
  int get hashCode =>
      name.hashCode ^
      phone.hashCode ^
      email.hashCode ^
      gender.hashCode ^
      profileImagePath.hashCode;
}
