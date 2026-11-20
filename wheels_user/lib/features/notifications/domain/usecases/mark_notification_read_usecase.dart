import '../repositories/notification_repository.dart';

class MarkNotificationReadUseCase {
  final NotificationRepository repository;

  MarkNotificationReadUseCase(this.repository);

  Future<bool> call(int notificationId) async {
    return await repository.markAsRead(notificationId);
  }
}
