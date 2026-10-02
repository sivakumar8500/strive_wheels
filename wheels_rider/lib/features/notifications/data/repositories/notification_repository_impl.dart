import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_remote_data_source.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<NotificationEntity>> getNotifications({int limit = 50, int skip = 0}) async {
    final models = await remoteDataSource.getNotifications(limit: limit, skip: skip);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<int> getUnreadCount() async {
    return await remoteDataSource.getUnreadCount();
  }

  @override
  Future<bool> markAsRead(int notificationId) async {
    return await remoteDataSource.markAsRead(notificationId);
  }

  @override
  Future<int> markAllAsRead() async {
    return await remoteDataSource.markAllAsRead();
  }
}
