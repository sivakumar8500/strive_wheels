import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_event.freezed.dart';

@freezed
class NotificationEvent with _$NotificationEvent {
  const factory NotificationEvent.enableNotifications() = EnableNotificationsEvent;
  const factory NotificationEvent.skipNotifications() = SkipNotificationsEvent;
}
