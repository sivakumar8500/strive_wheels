import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/settings/domain/entities/settings_entity.dart';
import 'package:wheels_user/features/settings/domain/entities/user_profile_entity.dart';
import 'package:wheels_user/features/settings/domain/usecases/get_settings_usecase.dart';
import 'package:wheels_user/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:wheels_user/features/settings/presentation/bloc/settings_event.dart';
import 'package:wheels_user/features/settings/presentation/bloc/settings_state.dart';

class MockGetSettingsUseCase extends Mock implements GetSettingsUseCase {}

void main() {
  late SettingsBloc bloc;
  late MockGetSettingsUseCase mockGetSettingsUseCase;

  const tEntity = SettingsEntity(
    profile: UserProfileEntity(
      name: 'Alexander Pierce',
      membershipTier: 'DIAMOND MEMBER',
      totalRides: '48',
      rating: '4.98',
      phone: '+91 98765 43210',
      email: 'alexander@example.com',
      gender: 'Male',
      isCorporate: false,
    ),
    rideNotificationsEnabled: true,
    isDarkMode: false,
    selectedLanguage: 'English (India)',
    appVersion: 'Version 2.4.12 (Build 4492)',
  );

  setUp(() {
    mockGetSettingsUseCase = MockGetSettingsUseCase();
    bloc = SettingsBloc(getSettingsUseCase: mockGetSettingsUseCase);
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state is SettingsState with isLoading true', () {
    expect(bloc.state.isLoading, isTrue);
  });

  blocTest<SettingsBloc, SettingsState>(
    'emits state with settingsEntity on LoadSettingsEvent success',
    build: () {
      when(() => mockGetSettingsUseCase())
          .thenAnswer((_) async => tEntity);
      return bloc;
    },
    act: (bloc) => bloc.add(const LoadSettingsEvent()),
    expect: () => [
      isA<SettingsState>().having((s) => s.isLoading, 'isLoading', isTrue),
      isA<SettingsState>()
          .having((s) => s.isLoading, 'isLoading', isFalse)
          .having((s) => s.settingsEntity, 'settingsEntity', tEntity),
    ],
    verify: (_) {
      verify(() => mockGetSettingsUseCase()).called(1);
    },
  );

  blocTest<SettingsBloc, SettingsState>(
    'toggles ride notifications on ToggleRideNotificationsEvent',
    build: () => bloc,
    act: (bloc) => bloc.add(const ToggleRideNotificationsEvent(false)),
    expect: () => [
      isA<SettingsState>()
          .having((s) => s.rideNotificationsEnabled, 'rideNotificationsEnabled', false),
    ],
  );

  blocTest<SettingsBloc, SettingsState>(
    'toggles dark mode on ToggleDarkModeEvent',
    build: () => bloc,
    act: (bloc) => bloc.add(const ToggleDarkModeEvent(true)),
    expect: () => [
      isA<SettingsState>().having((s) => s.isDarkMode, 'isDarkMode', true),
    ],
  );

  blocTest<SettingsBloc, SettingsState>(
    'emits isLoggedOut true on LogoutEvent',
    build: () => bloc,
    act: (bloc) => bloc.add(const LogoutEvent()),
    expect: () => [
      isA<SettingsState>().having((s) => s.isLoggedOut, 'isLoggedOut', true),
    ],
  );

  blocTest<SettingsBloc, SettingsState>(
    'updates profile with new image on UpdateUserProfileEvent',
    build: () => bloc,
    seed: () => const SettingsState(isLoading: false, settingsEntity: tEntity),
    act: (bloc) => bloc.add(const UpdateUserProfileEvent(
      name: 'Jane Doe',
      phone: '+91 99887 76655',
      email: 'jane@example.com',
      gender: 'Female',
      profileImagePath: '/path/to/image.jpg',
    )),
    expect: () => [
      isA<SettingsState>()
          .having((s) => s.settingsEntity?.profile.name, 'name', 'Jane Doe')
          .having((s) => s.settingsEntity?.profile.phone, 'phone', '+91 99887 76655')
          .having((s) => s.settingsEntity?.profile.email, 'email', 'jane@example.com')
          .having((s) => s.settingsEntity?.profile.gender, 'gender', 'Female')
          .having((s) => s.settingsEntity?.profile.profileImageUrl, 'profileImageUrl', '/path/to/image.jpg')
          .having((s) => s.actionMessage, 'actionMessage', 'Profile updated successfully!'),
    ],
  );

  blocTest<SettingsBloc, SettingsState>(
    'updates profile without image on UpdateUserProfileEvent (non-mandatory image)',
    build: () => bloc,
    seed: () => const SettingsState(isLoading: false, settingsEntity: tEntity),
    act: (bloc) => bloc.add(const UpdateUserProfileEvent(
      name: 'Jane Doe',
      phone: '+91 99887 76655',
      email: 'jane@example.com',
      gender: 'Female',
    )),
    expect: () => [
      isA<SettingsState>()
          .having((s) => s.settingsEntity?.profile.name, 'name', 'Jane Doe')
          .having((s) => s.settingsEntity?.profile.gender, 'gender', 'Female')
          .having((s) => s.settingsEntity?.profile.profileImageUrl, 'profileImageUrl', null)
          .having((s) => s.actionMessage, 'actionMessage', 'Profile updated successfully!'),
    ],
  );
}
