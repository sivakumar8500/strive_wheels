import '../entities/permissions_entity.dart';
import '../repositories/permissions_repository.dart';

class GetPermissionsUseCase {
  final PermissionsRepository repository;

  GetPermissionsUseCase(this.repository);

  Future<PermissionsEntity> call() async {
    return await repository.getPermissions();
  }
}
