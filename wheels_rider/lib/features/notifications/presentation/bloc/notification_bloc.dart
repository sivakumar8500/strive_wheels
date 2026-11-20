import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_notifications_usecase.dart';
import '../../domain/usecases/get_unread_count_usecase.dart';
import '../../domain/usecases/mark_notification_read_usecase.dart';
import '../../domain/usecases/mark_all_read_usecase.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetNotificationsUseCase getNotificationsUseCase;
  final GetUnreadCountUseCase getUnreadCountUseCase;
  final MarkNotificationReadUseCase markNotificationReadUseCase;
  final MarkAllReadUseCase markAllReadUseCase;

  NotificationBloc({
    required this.getNotificationsUseCase,
    required this.getUnreadCountUseCase,
    required this.markNotificationReadUseCase,
    required this.markAllReadUseCase,
  }) : super(NotificationInitial()) {
    on<LoadNotificationsEvent>(_onLoadNotifications);
    on<LoadUnreadCountEvent>(_onLoadUnreadCount);
    on<MarkNotificationAsReadEvent>(_onMarkNotificationAsRead);
    on<MarkAllNotificationsAsReadEvent>(_onMarkAllNotificationsAsRead);
  }

  Future<void> _onLoadNotifications(
    LoadNotificationsEvent event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoading());
    try {
      final notifications = await getNotificationsUseCase(limit: event.limit, skip: event.skip);
      final unreadCount = notifications.where((n) => !n.isRead).length;
      emit(NotificationLoaded(
        notifications: notifications,
        unreadCount: unreadCount,
      ));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> _onLoadUnreadCount(
    LoadUnreadCountEvent event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      final count = await getUnreadCountUseCase();
      if (state is NotificationLoaded) {
        final current = state as NotificationLoaded;
        emit(NotificationLoaded(
          notifications: current.notifications,
          unreadCount: count,
        ));
      } else {
        final notifications = await getNotificationsUseCase(limit: 50, skip: 0);
        emit(NotificationLoaded(
          notifications: notifications,
          unreadCount: count > 0 ? count : notifications.where((n) => !n.isRead).length,
        ));
      }
    } catch (_) {
      // Retain state on count fetch failure
    }
  }

  Future<void> _onMarkNotificationAsRead(
    MarkNotificationAsReadEvent event,
    Emitter<NotificationState> emit,
  ) async {
    if (state is NotificationLoaded) {
      final current = state as NotificationLoaded;
      final updatedList = current.notifications.map((n) {
        if (n.id == event.notificationId) {
          return n.copyWith(isRead: true);
        }
        return n;
      }).toList();
      final newUnreadCount = updatedList.where((n) => !n.isRead).length;

      emit(NotificationLoaded(
        notifications: updatedList,
        unreadCount: newUnreadCount,
      ));

      try {
        await markNotificationReadUseCase(event.notificationId);
      } catch (_) {}
    }
  }

  Future<void> _onMarkAllNotificationsAsRead(
    MarkAllNotificationsAsReadEvent event,
    Emitter<NotificationState> emit,
  ) async {
    if (state is NotificationLoaded) {
      final current = state as NotificationLoaded;
      final updatedList = current.notifications.map((n) => n.copyWith(isRead: true)).toList();

      emit(NotificationLoaded(
        notifications: updatedList,
        unreadCount: 0,
      ));

      try {
        await markAllReadUseCase();
      } catch (_) {}
    }
  }
}
