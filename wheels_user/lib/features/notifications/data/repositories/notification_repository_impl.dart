import '../../domain/entities/notification_permission_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_local_datasource.dart';
import '../models/notification_permission_model.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationLocalDataSource localDataSource;

  NotificationRepositoryImpl({required this.localDataSource});

  @override
  Future<bool> setPermissionStatus(NotificationPermissionEntity entity) async {
    final model = NotificationPermissionModel.fromEntity(entity);
    return await localDataSource.savePermissionStatus(model);
  }
}
