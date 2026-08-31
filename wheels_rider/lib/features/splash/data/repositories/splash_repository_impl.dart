import '../../domain/repositories/splash_repository.dart';
import '../datasources/splash_local_datasource.dart';

class SplashRepositoryImpl implements SplashRepository {
  final SplashLocalDataSource localDataSource;

  SplashRepositoryImpl({required this.localDataSource});

  @override
  Future<bool> isUserAuthenticated() async {
    return await localDataSource.isAuthenticated();
  }

  @override
  Future<String?> getAuthStatus() async {
    return await localDataSource.getAuthStatus();
  }

  @override
  Future<int?> getCurrentStep() async {
    return await localDataSource.getCurrentStep();
  }

  @override
  Future<String?> getPhoneNumber() async {
    return await localDataSource.getPhoneNumber();
  }
}
