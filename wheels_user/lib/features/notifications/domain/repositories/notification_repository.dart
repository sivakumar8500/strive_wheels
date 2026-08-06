import '../entities/notification_permission_entity.dart';

/// Abstract repository contract for notifications feature.
abstract class NotificationRepository {
  Future<bool> setPermissionStatus(NotificationPermissionEntity entity);
}
