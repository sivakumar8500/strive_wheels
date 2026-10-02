import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/settings/domain/entities/user_profile_entity.dart';
import 'package:wheels_user/features/settings/domain/repositories/settings_repository.dart';
import 'package:wheels_user/features/settings/domain/usecases/update_user_profile_usecase.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  late UpdateUserProfileUseCase useCase;
  late MockSettingsRepository mockRepository;

  const tProfile = UserProfileEntity(
    name: 'Alexander Pierce',
    membershipTier: 'DIAMOND MEMBER',
    totalRides: '48',
    rating: '4.98',
    phone: '+91 98765 43210',
    email: 'alexander@example.com',
    gender: 'Male',
    profileImageUrl: '/path/to/avatar.png',
    isCorporate: false,
  );

  setUp(() {
    mockRepository = MockSettingsRepository();
    useCase = UpdateUserProfileUseCase(mockRepository);
  });

  test('should call repository.updateUserProfile with correct parameters', () async {
    when(() => mockRepository.updateUserProfile(
          name: any(named: 'name'),
          phone: any(named: 'phone'),
          email: any(named: 'email'),
          gender: any(named: 'gender'),
          profileImagePath: any(named: 'profileImagePath'),
        )).thenAnswer((_) async => tProfile);

    final result = await useCase(
      name: 'Alexander Pierce',
      phone: '+91 98765 43210',
      email: 'alexander@example.com',
      gender: 'Male',
      profileImagePath: '/path/to/avatar.png',
    );

    expect(result, tProfile);
    verify(() => mockRepository.updateUserProfile(
          name: 'Alexander Pierce',
          phone: '+91 98765 43210',
          email: 'alexander@example.com',
          gender: 'Male',
          profileImagePath: '/path/to/avatar.png',
        )).called(1);
  });
}
