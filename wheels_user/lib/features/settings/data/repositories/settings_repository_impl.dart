import '../../domain/entities/settings_entity.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_datasource.dart';
import '../datasources/settings_remote_datasource.dart';
import '../models/settings_model.dart';

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
}
