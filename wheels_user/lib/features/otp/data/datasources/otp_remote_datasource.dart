import '../models/otp_verification_model.dart';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/utils/jwt_utils.dart';

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
        debugPrint('====== VERIFY OTP SUCCESS ======');
        debugPrint(response.data.toString());

        final data = response.data['data'] ?? response.data;
        final token = data['access_token'] ?? data['token'] ?? data['access'];
        final refreshToken = data['refresh_token'];

        if (token != null && token.toString().isNotEmpty) {
          final tokenStr = token.toString();
          debugPrint('====== SAVING TOKENS & USER ID ======');
          await sharedPreferences.setString('access_token', tokenStr);
          if (refreshToken != null && refreshToken.toString().isNotEmpty) {
            await sharedPreferences.setString('refresh_token', refreshToken.toString());
          }

          final rawUserId = data['user_id'] ?? data['customer_id'] ?? data['id'] ?? data['customer_profile']?['id'];
          int? userId = rawUserId != null ? int.tryParse(rawUserId.toString()) : null;
          userId ??= JwtUtils.getUserIdFromJwt(tokenStr);

          if (userId != null) {
            await sharedPreferences.setInt('user_id', userId);
            await sharedPreferences.setInt('customer_id', userId);
            debugPrint('====== SAVED USER ID: $userId ======');
          }
        } else {
          debugPrint('====== WARNING: NO TOKEN FOUND IN RESPONSE ======');
        }
        return true;
      }
      debugPrint('====== VERIFY OTP FAILED: ${response.statusCode} ======');
      return false;
    } catch (e) {
      debugPrint('====== VERIFY OTP ERROR ======');
      debugPrint(e.toString());
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
        debugPrint('====== RESEND OTP SUCCESS ======');
        debugPrint(response.data.toString());
        final otp = response.data['data']?['otp'] ?? response.data['otp'];
        debugPrint('=================================');
        debugPrint('NEW OTP FOR LOGIN: $otp');
        debugPrint('=================================');
        return true;
      }
      debugPrint('====== RESEND OTP FAILED: ${response.statusCode} ======');
      return false;
    } catch (e) {
      debugPrint('====== RESEND OTP ERROR ======');
      debugPrint(e.toString());
      throw Exception('Failed to resend OTP: $e');
    }
  }
}
