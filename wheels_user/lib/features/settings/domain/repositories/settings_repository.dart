import '../entities/settings_entity.dart';
import '../entities/user_profile_entity.dart';

abstract class SettingsRepository {
  Future<SettingsEntity> getSettings();
  Future<UserProfileEntity> updateUserProfile({
    String? name,
    String? phone,
    String? email,
    String? gender,
    String? profileImagePath,
  });
}
