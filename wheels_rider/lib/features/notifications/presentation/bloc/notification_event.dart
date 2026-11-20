abstract class NotificationEvent {
  const NotificationEvent();
}

class LoadNotificationsEvent extends NotificationEvent {
  final int limit;
  final int skip;

  const LoadNotificationsEvent({this.limit = 50, this.skip = 0});
}

class LoadUnreadCountEvent extends NotificationEvent {
  const LoadUnreadCountEvent();
}

class MarkNotificationAsReadEvent extends NotificationEvent {
  final int notificationId;

  const MarkNotificationAsReadEvent(this.notificationId);
}

class MarkAllNotificationsAsReadEvent extends NotificationEvent {
  const MarkAllNotificationsAsReadEvent();
}
