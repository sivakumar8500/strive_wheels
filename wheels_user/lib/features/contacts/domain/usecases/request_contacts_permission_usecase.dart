import '../entities/contacts_permission_entity.dart';
import '../repositories/contacts_repository.dart';

/// UseCase for requesting or updating contacts permission preference.
class RequestContactsPermissionUseCase {
  final ContactsRepository repository;

  RequestContactsPermissionUseCase(this.repository);

  Future<bool> call(ContactsPermissionEntity params) async {
    return await repository.setPermissionStatus(params);
  }
}
