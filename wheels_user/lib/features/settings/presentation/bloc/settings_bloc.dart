import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_settings_usecase.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final GetSettingsUseCase getSettingsUseCase;

  SettingsBloc({
    required this.getSettingsUseCase,
  }) : super(const SettingsState(isLoading: true)) {
    on<LoadSettingsEvent>(_onLoadSettings);
    on<ToggleRideNotificationsEvent>(_onToggleRideNotifications);
    on<ToggleDarkModeEvent>(_onToggleDarkMode);
    on<SelectSettingItemEvent>(_onSelectSettingItem);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onLoadSettings(
    LoadSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final entity = await getSettingsUseCase();
      emit(state.copyWith(
        isLoading: false,
        settingsEntity: entity,
        rideNotificationsEnabled: entity.rideNotificationsEnabled,
        isDarkMode: entity.isDarkMode,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load settings',
      ));
    }
  }

  void _onToggleRideNotifications(
    ToggleRideNotificationsEvent event,
    Emitter<SettingsState> emit,
  ) {
    emit(state.copyWith(
      rideNotificationsEnabled: event.enabled,
      actionMessage: event.enabled
          ? 'Ride notifications enabled'
          : 'Ride notifications disabled',
    ));
  }

  void _onToggleDarkMode(
    ToggleDarkModeEvent event,
    Emitter<SettingsState> emit,
  ) {
    emit(state.copyWith(
      isDarkMode: event.isDarkMode,
      actionMessage:
          event.isDarkMode ? 'Dark mode enabled' : 'Light mode enabled',
    ));
  }

  void _onSelectSettingItem(
    SelectSettingItemEvent event,
    Emitter<SettingsState> emit,
  ) {
    emit(state.copyWith(
      actionMessage: 'Opening ${event.itemName}...',
    ));
  }

  void _onLogout(
    LogoutEvent event,
    Emitter<SettingsState> emit,
  ) {
    emit(state.copyWith(
      isLoggedOut: true,
      actionMessage: 'Logged out successfully',
    ));
  }
}
