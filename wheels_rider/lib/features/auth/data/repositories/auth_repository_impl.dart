import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<bool> loginWithPhone(String phoneNumber) async {
    try {
      // Assuming country code +91 as default for now based on the API example
      final response = await remoteDataSource.sendOtp(
        countryCode: '+91', 
        phoneNumber: phoneNumber,
      );
      
      if (response.success) {
        print('OTP Received (dev): ${response.data.devOtp}');
        return true;
      }
      throw Exception(response.message);
    } catch (e) {
      final msg = e.toString().replaceAll('Exception: ', '');
      throw Exception(msg);
    }
  }

  @override
  Future<AuthStatus> verifyOtp(String phoneNumber, String otp) async {
    try {
      final response = await remoteDataSource.verifyOtp(
        countryCode: '+91', 
        phoneNumber: phoneNumber,
        code: otp,
        fullName: '', // Provide a default if not collected before OTP
        role: 'RIDER',
      );

      final token = response.data.accessToken;
      final driverRegistration = response.data.riderProfile?.driverRegistration ?? response.data.driverRegistration;

      // Cache token
      await localDataSource.cacheUserToken(token);
      
      if (driverRegistration == null) {
        return AuthStatus.registrationPending;
      }

      final status = driverRegistration.status?.toUpperCase() ?? '';
      
      switch(status) {
        case 'DRAFT': return AuthStatus.registrationDraft;
        case 'SUBMITTED': return AuthStatus.registrationSubmitted;
        case 'APPROVED': return AuthStatus.approved;
        case 'REJECTED': return AuthStatus.registrationRejected;
        default: return AuthStatus.registrationPending;
      }
    } catch (e) {
      final msg = e.toString().replaceAll('Exception: ', '');
      throw Exception(msg);
    }
  }
}
