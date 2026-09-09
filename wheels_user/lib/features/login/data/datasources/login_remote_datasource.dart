import '../models/login_request_model.dart';

import 'package:dio/dio.dart';
import '../../../../core/network/api_constants.dart';

abstract class LoginRemoteDataSource {
  Future<bool> sendOtp(LoginRequestModel model);
}

class LoginRemoteDataSourceImpl implements LoginRemoteDataSource {
  final Dio dio;
  const LoginRemoteDataSourceImpl({required this.dio});

  @override
  Future<bool> sendOtp(LoginRequestModel model) async {
    try {
      final response = await dio.post(
        ApiConstants.sendOtp,
        data: model.toJson(),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('====== SEND OTP SUCCESS ======');
        print(response.data);
        final otp = response.data['data']?['otp'] ?? response.data['otp'];
        print('=================================');
        print('OTP FOR LOGIN: $otp');
        print('=================================');
        return true;
      }
      print('====== SEND OTP FAILED: ${response.statusCode} ======');
      return false;
    } catch (e) {
      print('====== SEND OTP ERROR ======');
      print(e);
      throw Exception('Failed to send OTP: $e');
    }
  }
}
