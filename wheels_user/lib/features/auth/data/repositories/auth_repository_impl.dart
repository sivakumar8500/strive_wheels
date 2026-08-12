import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({required this.localDataSource});

  @override
  Future<bool> loginWithPhone(String phoneNumber) async {
    // TODO: Implement actual remote API call for login
    await Future.delayed(const Duration(seconds: 1));
    await localDataSource.cacheUserToken('dummy_token_123');
    return true;
  }
}
