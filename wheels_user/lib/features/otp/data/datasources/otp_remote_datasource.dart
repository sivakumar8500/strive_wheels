import 'dart:convert';
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

          // Extract and store user and corporate company details
          final customerProfile = data['customer_profile'] is Map ? Map<String, dynamic>.from(data['customer_profile']) : null;
          final userObj = (customerProfile?['user'] is Map)
              ? Map<String, dynamic>.from(customerProfile!['user'])
              : ((data['user'] is Map) ? Map<String, dynamic>.from(data['user']) : null);
          final activeCompany = (customerProfile?['active_company'] is Map)
              ? Map<String, dynamic>.from(customerProfile!['active_company'])
              : null;
          final associations = customerProfile?['company_associations'] as List?;
          final firstAssoc = (associations != null && associations.isNotEmpty && associations.first is Map)
              ? Map<String, dynamic>.from(associations.first)
              : null;
          final companyObj = activeCompany ?? (firstAssoc?['company'] is Map ? Map<String, dynamic>.from(firstAssoc!['company']) : null);

          final userName = userObj?['full_name'] ?? data['full_name'] ?? model.fullPhoneNumber;
          final userPhone = userObj?['phone'] ?? data['phone'] ?? model.fullPhoneNumber;
          final userEmail = userObj?['email'] ?? data['email'] ?? companyObj?['contact_email'];

          await sharedPreferences.setString('user_name', userName.toString());
          await sharedPreferences.setString('user_phone', userPhone.toString());
          if (userEmail != null) {
            await sharedPreferences.setString('user_email', userEmail.toString());
          }

          final bool isCorporate = companyObj != null;
          await sharedPreferences.setBool('is_corporate_user', isCorporate);

          if (isCorporate) {
            final compId = int.tryParse(companyObj['id']?.toString() ?? '') ?? 1;
            final compName = companyObj['name']?.toString() ?? '';
            final empCode = firstAssoc?['employee_code']?.toString() ?? '';
            final limit = firstAssoc?['spending_limit']?.toString() ?? '';
            final compEmail = companyObj['contact_email']?.toString() ?? '';
            final compLoc = companyObj['company_location']?.toString() ?? '';

            await sharedPreferences.setInt('corporate_company_id', compId);
            await sharedPreferences.setString('corporate_company_name', compName);
            await sharedPreferences.setString('corporate_employee_code', empCode);
            await sharedPreferences.setString('corporate_spending_limit', limit);
            await sharedPreferences.setString('corporate_email', compEmail);
            await sharedPreferences.setString('corporate_location', compLoc);
            debugPrint('====== SAVED CORPORATE USER: $compName ($empCode, ID: $compId) ======');
          } else {
            await sharedPreferences.remove('corporate_company_id');
            await sharedPreferences.remove('corporate_company_name');
            await sharedPreferences.remove('corporate_employee_code');
            await sharedPreferences.remove('corporate_spending_limit');
            await sharedPreferences.remove('corporate_email');
            await sharedPreferences.remove('corporate_location');
          }

          if (customerProfile != null) {
            await sharedPreferences.setString('saved_customer_profile', jsonEncode(customerProfile));
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
