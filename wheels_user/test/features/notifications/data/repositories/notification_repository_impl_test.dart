import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/notifications/data/datasources/notification_remote_data_source.dart';
import 'package:wheels_user/features/notifications/data/models/notification_model.dart';
import 'package:wheels_user/features/notifications/data/repositories/notification_repository_impl.dart';

class MockNotificationRemoteDataSource extends Mock
    implements NotificationRemoteDataSource {}

void main() {
  late NotificationRepositoryImpl repository;
  late MockNotificationRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockNotificationRemoteDataSource();
    repository = NotificationRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  final testModel = NotificationModel(
    id: 1,
    userId: 1,
    title: 'Test Promo',
    body: 'Save 20%',
    notificationType: 'PROMOTIONAL',
    isRead: false,
    createdAt: DateTime.now(),
  );

  group('NotificationRepositoryImpl Tests', () {
    test('getNotifications should convert models to entities', () async {
      when(() => mockRemoteDataSource.getNotifications(limit: 50, skip: 0))
          .thenAnswer((_) async => [testModel]);

      final result = await repository.getNotifications();
      expect(result.length, 1);
      expect(result.first.id, 1);
      expect(result.first.title, 'Test Promo');
    });

    test('getUnreadCount delegates to remote data source', () async {
      when(() => mockRemoteDataSource.getUnreadCount())
          .thenAnswer((_) async => 5);

      final count = await repository.getUnreadCount();
      expect(count, 5);
    });

    test('markAsRead delegates to remote data source', () async {
      when(() => mockRemoteDataSource.markAsRead(1))
          .thenAnswer((_) async => true);

      final res = await repository.markAsRead(1);
      expect(res, true);
    });

    test('markAllAsRead delegates to remote data source', () async {
      when(() => mockRemoteDataSource.markAllAsRead())
          .thenAnswer((_) async => 2);

      final count = await repository.markAllAsRead();
      expect(count, 2);
    });
  });
}
