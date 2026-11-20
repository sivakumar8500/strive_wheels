import 'package:shared_preferences/shared_preferences.dart';
import '../models/contacts_permission_model.dart';

abstract class ContactsLocalDataSource {
  Future<bool> savePermissionStatus(ContactsPermissionModel model);
}

class ContactsLocalDataSourceImpl implements ContactsLocalDataSource {
  final SharedPreferences? sharedPreferences;
  static const String _key = 'contacts_permission_enabled';

  ContactsLocalDataSourceImpl({this.sharedPreferences});

  @override
  Future<bool> savePermissionStatus(ContactsPermissionModel model) async {
    if (sharedPreferences != null) {
      await sharedPreferences!.setBool(_key, model.isEnabled);
    }
    return true;
  }
}
