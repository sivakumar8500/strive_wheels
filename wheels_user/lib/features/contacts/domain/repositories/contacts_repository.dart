import '../entities/contacts_permission_entity.dart';

/// Abstract repository contract for contacts feature.
abstract class ContactsRepository {
  Future<bool> setPermissionStatus(ContactsPermissionEntity entity);
}
