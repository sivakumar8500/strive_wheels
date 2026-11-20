import '../entities/notification_entity.dart';
import '../repositories/notification_repository.dart';

class GetNotificationsUseCase {
  final NotificationRepository repository;

  GetNotificationsUseCase(this.repository);

  Future<List<NotificationEntity>> call({int limit = 50, int skip = 0}) async {
    return await repository.getNotifications(limit: limit, skip: skip);
  }
}
