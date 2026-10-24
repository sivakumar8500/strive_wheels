import 'package:flutter/foundation.dart';
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
        debugPrint('====== SEND OTP SUCCESS ======');
        debugPrint(response.data.toString());
        final cleanPhone = model.phoneNumber.replaceAll(RegExp(r'\D'), '');
        final isTestNumber = cleanPhone.endsWith('9988774411');
        final otp = isTestNumber
            ? '123456'
            : (response.data['data']?['dev_otp'] ??
                response.data['data']?['otp'] ??
                response.data['otp']);
        debugPrint('=================================');
        debugPrint('OTP FOR LOGIN: $otp${isTestNumber ? " (Play Console Default)" : ""}');
        debugPrint('=================================');
        return true;
      }
      debugPrint('====== SEND OTP FAILED: ${response.statusCode} ======');
      return false;
    } catch (e) {
      debugPrint('====== SEND OTP ERROR ======');
      debugPrint(e.toString());
      throw Exception('Failed to send OTP: $e');
    }
  }
}
