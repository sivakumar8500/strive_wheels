import 'package:flutter_test/flutter_test.dart';
import 'package:wheels_rider/features/notifications/domain/entities/notification_entity.dart';
import 'package:wheels_rider/features/notifications/domain/repositories/notification_repository.dart';
import 'package:wheels_rider/features/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:wheels_rider/features/notifications/domain/usecases/get_unread_count_usecase.dart';
import 'package:wheels_rider/features/notifications/domain/usecases/mark_notification_read_usecase.dart';
import 'package:wheels_rider/features/notifications/domain/usecases/mark_all_read_usecase.dart';

class FakeNotificationRepository implements NotificationRepository {
  final List<NotificationEntity> items = [
    NotificationEntity(
      id: 1,
      userId: 1,
      title: 'Promo Offer',
      body: 'Get 20% surge bonus',
      notificationType: 'PROMOTIONAL',
      isRead: false,
      createdAt: DateTime.now(),
    ),
  ];

  @override
  Future<List<NotificationEntity>> getNotifications({int limit = 50, int skip = 0}) async {
    return items;
  }

  @override
  Future<int> getUnreadCount() async {
    return items.where((n) => !n.isRead).length;
  }

  @override
  Future<bool> markAsRead(int notificationId) async {
    return true;
  }

  @override
  Future<int> markAllAsRead() async {
    return items.length;
  }
}

void main() {
  late FakeNotificationRepository repository;
  late GetNotificationsUseCase getNotificationsUseCase;
  late GetUnreadCountUseCase getUnreadCountUseCase;
  late MarkNotificationReadUseCase markNotificationReadUseCase;
  late MarkAllReadUseCase markAllReadUseCase;

  setUp(() {
    repository = FakeNotificationRepository();
    getNotificationsUseCase = GetNotificationsUseCase(repository);
    getUnreadCountUseCase = GetUnreadCountUseCase(repository);
    markNotificationReadUseCase = MarkNotificationReadUseCase(repository);
    markAllReadUseCase = MarkAllReadUseCase(repository);
  });

  group('Notification UseCases Tests', () {
    test('GetNotificationsUseCase should fetch list of notifications', () async {
      final res = await getNotificationsUseCase();
      expect(res.length, 1);
      expect(res.first.title, 'Promo Offer');
    });

    test('GetUnreadCountUseCase should return unread count', () async {
      final count = await getUnreadCountUseCase();
      expect(count, 1);
    });

    test('MarkNotificationReadUseCase should call repo and return true', () async {
      final success = await markNotificationReadUseCase(1);
      expect(success, true);
    });

    test('MarkAllReadUseCase should call repo and return updated count', () async {
      final count = await markAllReadUseCase();
      expect(count, 1);
    });
  });
}
