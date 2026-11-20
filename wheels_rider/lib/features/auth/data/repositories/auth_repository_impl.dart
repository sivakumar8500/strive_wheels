import 'package:flutter/foundation.dart';
import '../../domain/entities/auth_result.dart';
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
      final response = await remoteDataSource.sendOtp(
        countryCode: '+91', 
        phoneNumber: phoneNumber,
      );
      
      if (response.success) {
        debugPrint('OTP Received (dev): ${response.data.devOtp}');
        return true;
      }
      throw Exception(response.message);
    } catch (e) {
      final msg = e.toString().replaceAll('Exception: ', '');
      throw Exception(msg);
    }
  }

  @override
  Future<AuthResult> verifyOtp(String phoneNumber, String otp) async {
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
        return const AuthResult(authStatus: AuthStatus.registrationPending);
      }

      final status = driverRegistration.status?.toUpperCase() ?? '';
      final currentStep = driverRegistration.currentStep;
      
      AuthStatus finalAuthStatus;
      switch(status) {
        case 'DRAFT':
        case 'IN_PROGRESS':
          finalAuthStatus = AuthStatus.registrationDraft;
          break;
        case 'SUBMITTED':
          finalAuthStatus = AuthStatus.registrationSubmitted;
          break;
        case 'APPROVED':
          finalAuthStatus = AuthStatus.approved;
          break;
        case 'REJECTED':
          finalAuthStatus = AuthStatus.registrationRejected;
          break;
        default:
          finalAuthStatus = AuthStatus.registrationPending;
          break;
      }

      await localDataSource.cacheAuthData(
        isAuthenticated: true,
        authStatus: finalAuthStatus.name,
        currentStep: currentStep,
        phoneNumber: phoneNumber,
      );

      return AuthResult(authStatus: finalAuthStatus, currentStep: currentStep);

    } catch (e) {
      final msg = e.toString().replaceAll('Exception: ', '');
      throw Exception(msg);
    }
  }
}

