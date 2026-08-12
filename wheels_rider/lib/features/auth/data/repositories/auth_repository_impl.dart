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

  @override
  Future<bool> verifyOtp(String phoneNumber, String otp) async {
    // TODO: Implement actual remote API call for OTP verification
    await Future.delayed(const Duration(seconds: 1));
    if (otp == '123456') {
      // Dummy verification
      return true;
    }
    throw Exception('Invalid OTP');
  }
}
