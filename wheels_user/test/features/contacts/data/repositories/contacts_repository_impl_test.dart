import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/contacts/data/datasources/contacts_local_datasource.dart';
import 'package:wheels_user/features/contacts/data/models/contacts_permission_model.dart';
import 'package:wheels_user/features/contacts/data/repositories/contacts_repository_impl.dart';
import 'package:wheels_user/features/contacts/domain/entities/contacts_permission_entity.dart';

class MockContactsLocalDataSource extends Mock implements ContactsLocalDataSource {}

void main() {
  late ContactsRepositoryImpl repository;
  late MockContactsLocalDataSource mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockContactsLocalDataSource();
    repository = ContactsRepositoryImpl(localDataSource: mockLocalDataSource);
    registerFallbackValue(
      const ContactsPermissionModel(isEnabled: true),
    );
  });

  const tEntity = ContactsPermissionEntity(isEnabled: true);

  test('fromEntity converts entity to model correctly', () {
    final model = ContactsPermissionModel.fromEntity(tEntity);
    expect(model.isEnabled, isTrue);
  });

  test('fromJson and toJson work on ContactsPermissionModel', () {
    const model = ContactsPermissionModel(isEnabled: true);
    final json = model.toJson();
    final fromJsonModel = ContactsPermissionModel.fromJson(json);
    expect(fromJsonModel, model);
  });

  test('setPermissionStatus calls localDataSource.savePermissionStatus', () async {
    when(() => mockLocalDataSource.savePermissionStatus(any()))
        .thenAnswer((_) async => true);

    final result = await repository.setPermissionStatus(tEntity);

    expect(result, isTrue);
    verify(() => mockLocalDataSource.savePermissionStatus(any())).called(1);
  });

  test('ContactsLocalDataSourceImpl executes successfully', () async {
    final dataSource = ContactsLocalDataSourceImpl();
    const model = ContactsPermissionModel(isEnabled: true);
    final result = await dataSource.savePermissionStatus(model);
    expect(result, isTrue);
  });
}
