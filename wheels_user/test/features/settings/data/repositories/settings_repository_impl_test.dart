import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/settings/data/datasources/settings_local_datasource.dart';
import 'package:wheels_user/features/settings/data/models/settings_model.dart';
import 'package:wheels_user/features/settings/data/models/user_profile_model.dart';
import 'package:wheels_user/features/settings/data/repositories/settings_repository_impl.dart';

class MockSettingsLocalDataSource extends Mock
    implements SettingsLocalDataSource {}

void main() {
  late SettingsRepositoryImpl repository;
  late MockSettingsLocalDataSource mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockSettingsLocalDataSource();
    repository =
        SettingsRepositoryImpl(localDataSource: mockLocalDataSource);
  });

  const tModel = SettingsModel(
    profile: UserProfileModel(
      name: 'Alexander Pierce',
      membershipTier: 'DIAMOND MEMBER',
      totalRides: '48',
      rating: '4.98',
    ),
    rideNotificationsEnabled: true,
    isDarkMode: false,
    selectedLanguage: 'English (India)',
    appVersion: 'Version 2.4.12 (Build 4492)',
  );

  test('should return SettingsEntity when local data source succeeds',
      () async {
    when(() => mockLocalDataSource.getSettingsData())
        .thenAnswer((_) async => tModel);

    final result = await repository.getSettings();

    expect(result.profile.name, equals('Alexander Pierce'));
    expect(result.profile.totalRides, equals('48'));
    verify(() => mockLocalDataSource.getSettingsData()).called(1);
    verifyNoMoreInteractions(mockLocalDataSource);
  });
}
