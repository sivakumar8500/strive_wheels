import '../../domain/entities/permissions_entity.dart';
import '../../domain/repositories/permissions_repository.dart';
import '../datasources/permissions_local_datasource.dart';
import '../models/permissions_model.dart';

class PermissionsRepositoryImpl implements PermissionsRepository {
  final PermissionsLocalDataSource localDataSource;

  PermissionsRepositoryImpl(this.localDataSource);

  @override
  Future<bool> savePermissions(PermissionsEntity permissions) async {
    final model = PermissionsModel(
      notificationsAllowed: permissions.notificationsAllowed,
      contactsAllowed: permissions.contactsAllowed,
      locationAllowed: permissions.locationAllowed,
    );
    return await localDataSource.savePermissions(model);
  }

  @override
  Future<PermissionsEntity> getPermissions() async {
    return await localDataSource.getPermissions();
  }
}
