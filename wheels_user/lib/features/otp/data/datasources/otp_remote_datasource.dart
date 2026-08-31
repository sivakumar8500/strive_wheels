import '../models/otp_verification_model.dart';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/network/api_constants.dart';

abstract class OtpRemoteDataSource {
  Future<bool> verifyOtp(OtpVerificationModel model);
  Future<bool> resendOtp(String fullPhoneNumber);
}

class OtpRemoteDataSourceImpl implements OtpRemoteDataSource {
  final Dio dio;
  final SharedPreferences sharedPreferences;

  const OtpRemoteDataSourceImpl({required this.dio, required this.sharedPreferences});

  @override
  Future<bool> verifyOtp(OtpVerificationModel model) async {
    try {
      final response = await dio.post(
        ApiConstants.verifyOtp,
        data: model.toJson(),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('====== VERIFY OTP SUCCESS ======');
        print(response.data);
        
        final data = response.data['data'] ?? response.data;
        final token = data['access_token'] ?? data['token'] ?? data['access'];
        
        if (token != null && token.toString().isNotEmpty) {
          print('====== SAVING TOKEN ======');
          await sharedPreferences.setString('access_token', token.toString());
        } else {
          print('====== WARNING: NO TOKEN FOUND IN RESPONSE ======');
        }
        return true;
      }
      print('====== VERIFY OTP FAILED: ${response.statusCode} ======');
      return false;
    } catch (e) {
      print('====== VERIFY OTP ERROR ======');
      print(e);
      throw Exception('Failed to verify OTP: $e');
    }
  }

  @override
  Future<bool> resendOtp(String fullPhoneNumber) async {
    try {
      final response = await dio.post(
        ApiConstants.sendOtp,
        data: {'phone': fullPhoneNumber},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('====== RESEND OTP SUCCESS ======');
        print(response.data);
        final otp = response.data['data']?['otp'] ?? response.data['otp'];
        print('=================================');
        print('NEW OTP FOR LOGIN: $otp');
        print('=================================');
        return true;
      }
      print('====== RESEND OTP FAILED: ${response.statusCode} ======');
      return false;
    } catch (e) {
      print('====== RESEND OTP ERROR ======');
      print(e);
      throw Exception('Failed to resend OTP: $e');
    }
  }
}
