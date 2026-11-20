import '../entities/notification_permission_entity.dart';
import '../repositories/notification_repository.dart';

/// UseCase for requesting or updating notification permission preference.
class RequestNotificationPermissionUseCase {
  final NotificationRepository repository;

  RequestNotificationPermissionUseCase(this.repository);

  Future<bool> call(NotificationPermissionEntity params) async {
    return await repository.setPermissionStatus(params);
  }
}
