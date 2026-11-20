import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:wheels_user/features/notifications/domain/entities/notification_entity.dart';
import 'package:wheels_user/features/notifications/domain/repositories/notification_repository.dart';
import 'package:wheels_user/features/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:wheels_user/features/notifications/domain/usecases/get_unread_count_usecase.dart';
import 'package:wheels_user/features/notifications/domain/usecases/mark_notification_read_usecase.dart';
import 'package:wheels_user/features/notifications/domain/usecases/mark_all_read_usecase.dart';
import 'package:wheels_user/features/notifications/presentation/bloc/notification_bloc.dart';
import 'package:wheels_user/features/notifications/presentation/bloc/notification_event.dart';
import 'package:wheels_user/features/notifications/presentation/bloc/notification_state.dart';

class MockNotificationRepository implements NotificationRepository {
  final List<NotificationEntity> notifications;

  MockNotificationRepository({required this.notifications});

  @override
  Future<List<NotificationEntity>> getNotifications({int limit = 50, int skip = 0}) async {
    return notifications;
  }

  @override
  Future<int> getUnreadCount() async {
    return notifications.where((n) => !n.isRead).length;
  }

  @override
  Future<bool> markAsRead(int notificationId) async {
    return true;
  }

  @override
  Future<int> markAllAsRead() async {
    return notifications.length;
  }
}

void main() {
  final testList = [
    NotificationEntity(
      id: 1,
      userId: 10,
      title: 'Flat ₹50 OFF',
      body: 'Welcome to StriveWheels',
      notificationType: 'PROMOTIONAL',
      isRead: false,
      createdAt: DateTime.parse('2026-10-01T08:00:00.000Z'),
    ),
    NotificationEntity(
      id: 2,
      userId: 10,
      title: 'Ride Completed',
      body: 'Ride #123 completed',
      notificationType: 'BOOKING',
      isRead: true,
      createdAt: DateTime.parse('2026-10-01T07:00:00.000Z'),
    ),
  ];

  late MockNotificationRepository mockRepo;
  late GetNotificationsUseCase getNotificationsUseCase;
  late GetUnreadCountUseCase getUnreadCountUseCase;
  late MarkNotificationReadUseCase markNotificationReadUseCase;
  late MarkAllReadUseCase markAllReadUseCase;

  setUp(() {
    mockRepo = MockNotificationRepository(notifications: testList);
    getNotificationsUseCase = GetNotificationsUseCase(mockRepo);
    getUnreadCountUseCase = GetUnreadCountUseCase(mockRepo);
    markNotificationReadUseCase = MarkNotificationReadUseCase(mockRepo);
    markAllReadUseCase = MarkAllReadUseCase(mockRepo);
  });

  group('NotificationBloc Tests', () {
    test('initial state is NotificationInitial', () {
      final bloc = NotificationBloc(
        getNotificationsUseCase: getNotificationsUseCase,
        getUnreadCountUseCase: getUnreadCountUseCase,
        markNotificationReadUseCase: markNotificationReadUseCase,
        markAllReadUseCase: markAllReadUseCase,
      );
      expect(bloc.state, isA<NotificationInitial>());
      bloc.close();
    });

    blocTest<NotificationBloc, NotificationState>(
      'emits [NotificationLoading, NotificationLoaded] when LoadNotificationsEvent is added',
      build: () => NotificationBloc(
        getNotificationsUseCase: getNotificationsUseCase,
        getUnreadCountUseCase: getUnreadCountUseCase,
        markNotificationReadUseCase: markNotificationReadUseCase,
        markAllReadUseCase: markAllReadUseCase,
      ),
      act: (bloc) => bloc.add(const LoadNotificationsEvent()),
      expect: () => [
        isA<NotificationLoading>(),
        isA<NotificationLoaded>()
            .having((s) => s.notifications.length, 'length', 2)
            .having((s) => s.unreadCount, 'unreadCount', 1),
      ],
    );

    blocTest<NotificationBloc, NotificationState>(
      'marks notification as read on MarkNotificationAsReadEvent',
      build: () => NotificationBloc(
        getNotificationsUseCase: getNotificationsUseCase,
        getUnreadCountUseCase: getUnreadCountUseCase,
        markNotificationReadUseCase: markNotificationReadUseCase,
        markAllReadUseCase: markAllReadUseCase,
      ),
      seed: () => NotificationLoaded(notifications: testList, unreadCount: 1),
      act: (bloc) => bloc.add(const MarkNotificationAsReadEvent(1)),
      expect: () => [
        isA<NotificationLoaded>()
            .having((s) => s.notifications.first.isRead, 'first.isRead', true)
            .having((s) => s.unreadCount, 'unreadCount', 0),
      ],
    );

    blocTest<NotificationBloc, NotificationState>(
      'marks all notifications as read on MarkAllNotificationsAsReadEvent',
      build: () => NotificationBloc(
        getNotificationsUseCase: getNotificationsUseCase,
        getUnreadCountUseCase: getUnreadCountUseCase,
        markNotificationReadUseCase: markNotificationReadUseCase,
        markAllReadUseCase: markAllReadUseCase,
      ),
      seed: () => NotificationLoaded(notifications: testList, unreadCount: 1),
      act: (bloc) => bloc.add(const MarkAllNotificationsAsReadEvent()),
      expect: () => [
        isA<NotificationLoaded>()
            .having((s) => s.unreadCount, 'unreadCount', 0),
      ],
    );
  });
}
