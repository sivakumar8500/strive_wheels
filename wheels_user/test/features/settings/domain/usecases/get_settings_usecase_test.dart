import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/settings/domain/entities/settings_entity.dart';
import 'package:wheels_user/features/settings/domain/entities/user_profile_entity.dart';
import 'package:wheels_user/features/settings/domain/repositories/settings_repository.dart';
import 'package:wheels_user/features/settings/domain/usecases/get_settings_usecase.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  late GetSettingsUseCase useCase;
  late MockSettingsRepository mockRepository;

  setUp(() {
    mockRepository = MockSettingsRepository();
    useCase = GetSettingsUseCase(mockRepository);
  });

  const tEntity = SettingsEntity(
    profile: UserProfileEntity(
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

  test('should return SettingsEntity from repository', () async {
    when(() => mockRepository.getSettings())
        .thenAnswer((_) async => tEntity);

    final result = await useCase();

    expect(result, equals(tEntity));
    verify(() => mockRepository.getSettings()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
