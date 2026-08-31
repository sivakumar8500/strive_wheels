import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_rider/features/profile/domain/entities/profile_entity.dart';
import 'package:wheels_rider/features/profile/domain/repositories/profile_repository.dart';
import 'package:wheels_rider/features/profile/domain/usecases/get_profile_usecase.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late GetProfileUseCase usecase;
  late MockProfileRepository mockProfileRepository;

  setUp(() {
    mockProfileRepository = MockProfileRepository();
    usecase = GetProfileUseCase(mockProfileRepository);
  });

  const tProfileEntity = ProfileEntity(id: 1, name: 'Alex', rating: 4.98, profileImageUrl: 'url', totalEarnings: 0.0, walletBalance: 0.0, phone: '1234567890', email: 'test@test.com', dob: '1990-01-01', gender: 'Male');

  test('should get profile from repository', () async {
    when(() => mockProfileRepository.getProfile())
        .thenAnswer((_) async => tProfileEntity);

    final result = await usecase();

    expect(result, tProfileEntity);
    verify(() => mockProfileRepository.getProfile());
    verifyNoMoreInteractions(mockProfileRepository);
  });
}
