import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/permissions_model.dart';

abstract class PermissionsLocalDataSource {
  Future<bool> savePermissions(PermissionsModel permissions);
  Future<PermissionsModel> getPermissions();
}

class PermissionsLocalDataSourceImpl implements PermissionsLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String _permissionsKey = 'cached_permissions';

  PermissionsLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<bool> savePermissions(PermissionsModel permissions) async {
    final jsonString = json.encode(permissions.toJson());
    return await sharedPreferences.setString(_permissionsKey, jsonString);
  }

  @override
  Future<PermissionsModel> getPermissions() async {
    final jsonString = sharedPreferences.getString(_permissionsKey);
    if (jsonString != null) {
      return PermissionsModel.fromJson(json.decode(jsonString));
    } else {
      return const PermissionsModel();
    }
  }
}
