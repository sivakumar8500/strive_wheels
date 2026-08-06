import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/notifications/data/datasources/notification_local_datasource.dart';
import 'package:wheels_user/features/notifications/data/models/notification_permission_model.dart';
import 'package:wheels_user/features/notifications/data/repositories/notification_repository_impl.dart';
import 'package:wheels_user/features/notifications/domain/entities/notification_permission_entity.dart';

class MockNotificationLocalDataSource extends Mock implements NotificationLocalDataSource {}

void main() {
  late NotificationRepositoryImpl repository;
  late MockNotificationLocalDataSource mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockNotificationLocalDataSource();
    repository = NotificationRepositoryImpl(localDataSource: mockLocalDataSource);
    registerFallbackValue(
      const NotificationPermissionModel(isEnabled: true),
    );
  });

  const tEntity = NotificationPermissionEntity(isEnabled: true);

  test('fromEntity converts entity to model correctly', () {
    final model = NotificationPermissionModel.fromEntity(tEntity);
    expect(model.isEnabled, isTrue);
  });

  test('fromJson and toJson work on NotificationPermissionModel', () {
    const model = NotificationPermissionModel(isEnabled: true);
    final json = model.toJson();
    final fromJsonModel = NotificationPermissionModel.fromJson(json);
    expect(fromJsonModel, model);
  });

  test('setPermissionStatus calls localDataSource.savePermissionStatus', () async {
    when(() => mockLocalDataSource.savePermissionStatus(any()))
        .thenAnswer((_) async => true);

    final result = await repository.setPermissionStatus(tEntity);

    expect(result, isTrue);
    verify(() => mockLocalDataSource.savePermissionStatus(any())).called(1);
  });

  test('NotificationLocalDataSourceImpl executes successfully', () async {
    final dataSource = NotificationLocalDataSourceImpl();
    const model = NotificationPermissionModel(isEnabled: true);
    final result = await dataSource.savePermissionStatus(model);
    expect(result, isTrue);
  });
}
