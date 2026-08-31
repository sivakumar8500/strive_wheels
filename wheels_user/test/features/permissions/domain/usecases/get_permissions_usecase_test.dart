import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/permissions/domain/entities/permissions_entity.dart';
import 'package:wheels_user/features/permissions/domain/repositories/permissions_repository.dart';
import 'package:wheels_user/features/permissions/domain/usecases/get_permissions_usecase.dart';

class MockPermissionsRepository extends Mock implements PermissionsRepository {}

void main() {
  late GetPermissionsUseCase usecase;
  late MockPermissionsRepository mockPermissionsRepository;

  setUp(() {
    mockPermissionsRepository = MockPermissionsRepository();
    usecase = GetPermissionsUseCase(mockPermissionsRepository);
  });

  const tPermissionsEntity = PermissionsEntity(
    notificationsAllowed: false,
    contactsAllowed: false,
    locationAllowed: false,
  );

  test(
    'should get permissions from the repository',
    () async {
      // arrange
      when(() => mockPermissionsRepository.getPermissions())
          .thenAnswer((_) async => tPermissionsEntity);
      // act
      final result = await usecase();
      // assert
      expect(result, tPermissionsEntity);
      verify(() => mockPermissionsRepository.getPermissions()).called(1);
      verifyNoMoreInteractions(mockPermissionsRepository);
    },
  );
}
