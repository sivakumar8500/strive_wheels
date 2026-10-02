import '../../domain/entities/settings_entity.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_datasource.dart';
import '../datasources/settings_remote_datasource.dart';
import '../models/settings_model.dart';
import '../models/user_profile_model.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource localDataSource;
  final SettingsRemoteDataSource? remoteDataSource;

  SettingsRepositoryImpl({
    required this.localDataSource,
    this.remoteDataSource,
  });

  @override
  Future<SettingsEntity> getSettings() async {
    final localModel = await localDataSource.getSettingsData();
    if (remoteDataSource != null) {
      try {
        final remoteProfile = await remoteDataSource!.getCustomerProfile();
        final updatedModel = localModel.copyWith(profile: remoteProfile);
        return updatedModel.toEntity();
      } catch (_) {
        // Fallback to local model if network call fails or endpoint offline
      }
    }
    return localModel.toEntity();
  }

  @override
  Future<UserProfileEntity> updateUserProfile({
    String? name,
    String? phone,
    String? email,
    String? gender,
    String? profileImagePath,
  }) async {
    String? remoteImageUrl;
    if (profileImagePath != null && profileImagePath.trim().isNotEmpty) {
      if (remoteDataSource != null && !profileImagePath.startsWith('http')) {
        try {
          remoteImageUrl = await remoteDataSource!.uploadProfilePhoto(profileImagePath);
        } catch (_) {}
      }
      remoteImageUrl ??= profileImagePath;
    }

    if (remoteDataSource != null) {
      try {
        final remoteProfile = await remoteDataSource!.updateCustomerProfile(
          name: name,
          email: email,
          phone: phone,
          gender: gender,
          profileImageUrl: remoteImageUrl,
        );
        return remoteProfile.toEntity();
      } catch (_) {}
    }

    final localModel = await localDataSource.getSettingsData();
    final current = localModel.profile;
    final updated = current.copyWith(
      name: (name != null && name.trim().isNotEmpty) ? name.trim() : current.name,
      phone: (phone != null && phone.trim().isNotEmpty) ? phone.trim() : current.phone,
      email: (email != null && email.trim().isNotEmpty) ? email.trim() : current.email,
      gender: (gender != null && gender.trim().isNotEmpty) ? gender.trim() : current.gender,
      profileImageUrl: remoteImageUrl ?? current.profileImageUrl,
    );
    return updated.toEntity();
  }
}
