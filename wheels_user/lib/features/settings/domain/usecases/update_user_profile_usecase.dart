import '../entities/user_profile_entity.dart';
import '../repositories/settings_repository.dart';

class UpdateUserProfileUseCase {
  final SettingsRepository repository;

  UpdateUserProfileUseCase(this.repository);

  Future<UserProfileEntity> call({
    String? name,
    String? phone,
    String? email,
    String? gender,
    String? profileImagePath,
  }) async {
    return await repository.updateUserProfile(
      name: name,
      phone: phone,
      email: email,
      gender: gender,
      profileImagePath: profileImagePath,
    );
  }
}
