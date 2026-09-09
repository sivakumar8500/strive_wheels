import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/permissions/data/datasources/permissions_local_datasource.dart';
import 'package:wheels_user/features/permissions/data/models/permissions_model.dart';
import 'package:wheels_user/features/permissions/data/repositories/permissions_repository_impl.dart';
import 'package:wheels_user/features/permissions/domain/entities/permissions_entity.dart';

class MockPermissionsLocalDataSource extends Mock implements PermissionsLocalDataSource {}
class FakePermissionsModel extends Fake implements PermissionsModel {}

void main() {
  late PermissionsRepositoryImpl repository;
  late MockPermissionsLocalDataSource mockLocalDataSource;

  setUpAll(() {
    registerFallbackValue(FakePermissionsModel());
  });

  setUp(() {
    mockLocalDataSource = MockPermissionsLocalDataSource();
    repository = PermissionsRepositoryImpl(mockLocalDataSource);
  });

  const tPermissionsEntity = PermissionsEntity(
    notificationsAllowed: true,
    contactsAllowed: true,
    locationAllowed: false,
  );

  const tPermissionsModel = PermissionsModel(
    notificationsAllowed: true,
    contactsAllowed: true,
    locationAllowed: false,
  );

  test('should save permissions using local data source', () async {
    // arrange
    when(() => mockLocalDataSource.savePermissions(any())).thenAnswer((_) async => true);
    // act
    final result = await repository.savePermissions(tPermissionsEntity);
    // assert
    expect(result, true);
    verify(() => mockLocalDataSource.savePermissions(tPermissionsModel)).called(1);
    verifyNoMoreInteractions(mockLocalDataSource);
  });

  test('should get permissions from local data source', () async {
    // arrange
    when(() => mockLocalDataSource.getPermissions()).thenAnswer((_) async => tPermissionsModel);
    // act
    final result = await repository.getPermissions();
    // assert
    expect(result, tPermissionsModel);
    verify(() => mockLocalDataSource.getPermissions()).called(1);
    verifyNoMoreInteractions(mockLocalDataSource);
  });
}
