import '../../domain/entities/settings_entity.dart';

class SettingsState {
  final bool isLoading;
  final SettingsEntity? settingsEntity;
  final bool rideNotificationsEnabled;
  final bool isDarkMode;
  final String? actionMessage;
  final bool isLoggedOut;
  final String? errorMessage;

  const SettingsState({
    this.isLoading = false,
    this.settingsEntity,
    this.rideNotificationsEnabled = true,
    this.isDarkMode = false,
    this.actionMessage,
    this.isLoggedOut = false,
    this.errorMessage,
  });

  SettingsState copyWith({
    bool? isLoading,
    SettingsEntity? settingsEntity,
    bool? rideNotificationsEnabled,
    bool? isDarkMode,
    String? actionMessage,
    bool? isLoggedOut,
    String? errorMessage,
  }) {
    return SettingsState(
      isLoading: isLoading ?? this.isLoading,
      settingsEntity: settingsEntity ?? this.settingsEntity,
      rideNotificationsEnabled:
          rideNotificationsEnabled ?? this.rideNotificationsEnabled,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      actionMessage: actionMessage,
      isLoggedOut: isLoggedOut ?? this.isLoggedOut,
      errorMessage: errorMessage,
    );
  }
}
