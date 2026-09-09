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
