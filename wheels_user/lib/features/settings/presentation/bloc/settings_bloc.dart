import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/settings_entity.dart';
import '../../domain/entities/user_profile_entity.dart';
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
    on<UpdateUserProfileEvent>(_onUpdateUserProfile);
    on<LogoutEvent>(_onLogout);
  }

  void _onUpdateUserProfile(
    UpdateUserProfileEvent event,
    Emitter<SettingsState> emit,
  ) {
    if (state.settingsEntity != null) {
      final currentProfile = state.settingsEntity!.profile;
      final updatedProfile = UserProfileEntity(
        name: event.name.trim().isNotEmpty ? event.name.trim() : currentProfile.name,
        membershipTier: currentProfile.membershipTier,
        totalRides: currentProfile.totalRides,
        rating: currentProfile.rating,
        phone: event.phone.trim().isNotEmpty ? event.phone.trim() : currentProfile.phone,
        email: event.email.trim().isNotEmpty ? event.email.trim() : currentProfile.email,
        gender: event.gender.trim().isNotEmpty ? event.gender.trim() : currentProfile.gender,
        isCorporate: currentProfile.isCorporate,
        companyName: currentProfile.companyName,
        corporateEmail: currentProfile.corporateEmail,
        corporateId: currentProfile.corporateId,
        department: currentProfile.department,
        designation: currentProfile.designation,
      );

      final updatedSettings = SettingsEntity(
        profile: updatedProfile,
        rideNotificationsEnabled: state.settingsEntity!.rideNotificationsEnabled,
        isDarkMode: state.settingsEntity!.isDarkMode,
        selectedLanguage: state.settingsEntity!.selectedLanguage,
        appVersion: state.settingsEntity!.appVersion,
      );

      emit(state.copyWith(
        settingsEntity: updatedSettings,
        actionMessage: 'Profile updated successfully!',
      ));
    }
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
