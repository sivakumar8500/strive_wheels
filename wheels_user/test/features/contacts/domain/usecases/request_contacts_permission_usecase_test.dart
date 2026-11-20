import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/contacts/domain/entities/contacts_permission_entity.dart';
import 'package:wheels_user/features/contacts/domain/repositories/contacts_repository.dart';
import 'package:wheels_user/features/contacts/domain/usecases/request_contacts_permission_usecase.dart';

class MockContactsRepository extends Mock implements ContactsRepository {}

void main() {
  late RequestContactsPermissionUseCase useCase;
  late MockContactsRepository mockRepository;

  setUp(() {
    mockRepository = MockContactsRepository();
    useCase = RequestContactsPermissionUseCase(mockRepository);
  });

  const tEntity = ContactsPermissionEntity(isEnabled: true);

  test('should call repository.setPermissionStatus with correct entity', () async {
    when(() => mockRepository.setPermissionStatus(tEntity))
        .thenAnswer((_) async => true);

    final result = await useCase(tEntity);

    expect(result, isTrue);
    verify(() => mockRepository.setPermissionStatus(tEntity)).called(1);
  });
}
