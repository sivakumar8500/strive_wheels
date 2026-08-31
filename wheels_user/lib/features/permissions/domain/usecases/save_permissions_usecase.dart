import '../entities/permissions_entity.dart';
import '../repositories/permissions_repository.dart';

class SavePermissionsUseCase {
  final PermissionsRepository repository;

  SavePermissionsUseCase(this.repository);

  Future<bool> call(PermissionsEntity params) async {
    return await repository.savePermissions(params);
  }
}
