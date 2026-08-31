import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepositoryImpl(this._remoteDataSource);

  @override
  Future<ProfileEntity> getProfile() async {
    final result = await _remoteDataSource.getProfile();
    return result.toEntity();
  }

  @override
  Future<ProfileEntity> updateProfile(Map<String, dynamic> data) async {
    final result = await _remoteDataSource.updateProfile(data);
    return result.toEntity();
  }
}
