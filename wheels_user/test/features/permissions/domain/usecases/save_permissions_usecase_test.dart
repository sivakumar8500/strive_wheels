import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/permissions/domain/entities/permissions_entity.dart';
import 'package:wheels_user/features/permissions/domain/repositories/permissions_repository.dart';
import 'package:wheels_user/features/permissions/domain/usecases/save_permissions_usecase.dart';

class MockPermissionsRepository extends Mock implements PermissionsRepository {}
class FakePermissionsEntity extends Fake implements PermissionsEntity {}

void main() {
  late SavePermissionsUseCase usecase;
  late MockPermissionsRepository mockPermissionsRepository;

  setUpAll(() {
    registerFallbackValue(FakePermissionsEntity());
  });

  setUp(() {
    mockPermissionsRepository = MockPermissionsRepository();
    usecase = SavePermissionsUseCase(mockPermissionsRepository);
  });

  const tPermissionsEntity = PermissionsEntity(
    notificationsAllowed: true,
    contactsAllowed: false,
    locationAllowed: true,
  );

  test(
    'should save permissions via repository',
    () async {
      // arrange
      when(() => mockPermissionsRepository.savePermissions(any()))
          .thenAnswer((_) async => true);
      // act
      final result = await usecase(tPermissionsEntity);
      // assert
      expect(result, true);
      verify(() => mockPermissionsRepository.savePermissions(tPermissionsEntity)).called(1);
      verifyNoMoreInteractions(mockPermissionsRepository);
    },
  );
}
