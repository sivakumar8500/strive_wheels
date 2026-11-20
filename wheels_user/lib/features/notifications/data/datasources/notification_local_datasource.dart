import 'package:shared_preferences/shared_preferences.dart';
import '../models/notification_permission_model.dart';

abstract class NotificationLocalDataSource {
  Future<bool> savePermissionStatus(NotificationPermissionModel model);
}

class NotificationLocalDataSourceImpl implements NotificationLocalDataSource {
  final SharedPreferences? sharedPreferences;
  static const String _key = 'notifications_enabled';

  NotificationLocalDataSourceImpl({this.sharedPreferences});

  @override
  Future<bool> savePermissionStatus(NotificationPermissionModel model) async {
    if (sharedPreferences != null) {
      await sharedPreferences!.setBool(_key, model.isEnabled);
    }
    return true;
  }
}
