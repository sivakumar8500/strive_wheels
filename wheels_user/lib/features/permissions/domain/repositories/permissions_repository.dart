import '../entities/permissions_entity.dart';

abstract class PermissionsRepository {
  Future<bool> savePermissions(PermissionsEntity permissions);
  Future<PermissionsEntity> getPermissions();
}
