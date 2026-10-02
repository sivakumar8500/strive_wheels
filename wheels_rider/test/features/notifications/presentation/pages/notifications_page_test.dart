import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wheels_rider/core/di/injection_container.dart';
import 'package:wheels_rider/features/notifications/domain/entities/notification_entity.dart';
import 'package:wheels_rider/features/notifications/domain/repositories/notification_repository.dart';
import 'package:wheels_rider/features/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:wheels_rider/features/notifications/domain/usecases/get_unread_count_usecase.dart';
import 'package:wheels_rider/features/notifications/domain/usecases/mark_notification_read_usecase.dart';
import 'package:wheels_rider/features/notifications/domain/usecases/mark_all_read_usecase.dart';
import 'package:wheels_rider/features/notifications/presentation/bloc/notification_bloc.dart';
import 'package:wheels_rider/features/notifications/presentation/pages/notifications_page.dart';

class MockNotificationRepository implements NotificationRepository {
  @override
  Future<List<NotificationEntity>> getNotifications({int limit = 50, int skip = 0}) async {
    return [
      NotificationEntity(
        id: 1,
        userId: 10,
        title: '🔥 Weekend Surge: 20% Extra Payout',
        body: 'Peak hours active between 5 PM – 10 PM.',
        notificationType: 'PROMOTIONAL',
        isRead: false,
        createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
      ),
      NotificationEntity(
        id: 2,
        userId: 10,
        title: 'Corporate Fleet Priority Activated',
        body: 'Your profile is approved for corporate routes.',
        notificationType: 'BOOKING',
        isRead: true,
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),
    ];
  }

  @override
  Future<int> getUnreadCount() async => 1;

  @override
  Future<bool> markAsRead(int notificationId) async => true;

  @override
  Future<int> markAllAsRead() async => 2;
}

void main() {
  setUp(() async {
    await sl.reset();
    final mockRepo = MockNotificationRepository();
    sl.registerLazySingleton<GetNotificationsUseCase>(() => GetNotificationsUseCase(mockRepo));
    sl.registerLazySingleton<GetUnreadCountUseCase>(() => GetUnreadCountUseCase(mockRepo));
    sl.registerLazySingleton<MarkNotificationReadUseCase>(() => MarkNotificationReadUseCase(mockRepo));
    sl.registerLazySingleton<MarkAllReadUseCase>(() => MarkAllReadUseCase(mockRepo));
    sl.registerFactory<NotificationBloc>(() => NotificationBloc(
      getNotificationsUseCase: sl(),
      getUnreadCountUseCase: sl(),
      markNotificationReadUseCase: sl(),
      markAllReadUseCase: sl(),
    ));
  });

  tearDown(() async {
    await sl.reset();
  });

  testWidgets('NotificationsPage renders app bar, filter chips, and notification items', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: NotificationsPage(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Notifications'), findsOneWidget);
    expect(find.text('All'), findsOneWidget);
    expect(find.text('🔥 Offers & Promos'), findsOneWidget);
    expect(find.text('🚗 Rides & Trips'), findsOneWidget);
    expect(find.text('🔔 System & Alerts'), findsOneWidget);

    expect(find.text('🔥 Weekend Surge: 20% Extra Payout'), findsOneWidget);
    expect(find.text('Corporate Fleet Priority Activated'), findsOneWidget);
    expect(find.text('Mark all read'), findsOneWidget);
  });
}
