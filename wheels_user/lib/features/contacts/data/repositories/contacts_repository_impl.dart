import '../../domain/entities/contacts_permission_entity.dart';
import '../../domain/repositories/contacts_repository.dart';
import '../datasources/contacts_local_datasource.dart';
import '../models/contacts_permission_model.dart';

class ContactsRepositoryImpl implements ContactsRepository {
  final ContactsLocalDataSource localDataSource;

  ContactsRepositoryImpl({required this.localDataSource});

  @override
  Future<bool> setPermissionStatus(ContactsPermissionEntity entity) async {
    final model = ContactsPermissionModel.fromEntity(entity);
    return await localDataSource.savePermissionStatus(model);
  }
}
