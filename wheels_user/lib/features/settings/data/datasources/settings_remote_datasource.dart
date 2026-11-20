import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/network/api_constants.dart';
import '../models/user_profile_model.dart';

abstract class SettingsRemoteDataSource {
  Future<UserProfileModel> getCustomerProfile();
  Future<UserProfileModel> updateCustomerProfile({
    String? name,
    String? email,
    String? phone,
    String? gender,
    String? profileImageUrl,
  });
  Future<String?> uploadProfilePhoto(String filePath);
}

class SettingsRemoteDataSourceImpl implements SettingsRemoteDataSource {
  final Dio dio;
  final SharedPreferences? sharedPreferences;

  SettingsRemoteDataSourceImpl({required this.dio, this.sharedPreferences});

  @override
  Future<UserProfileModel> getCustomerProfile() async {
    try {
      final response = await dio.get(ApiConstants.customerProfile);
      if (response.statusCode == 200 && response.data != null) {
        final profile = UserProfileModel.fromJson(response.data);
        final prefs = sharedPreferences ?? (sl.isRegistered<SharedPreferences>() ? sl<SharedPreferences>() : null);
        if (prefs != null) {
          await _persistProfilePreferences(prefs, profile, response.data);
        }
        return profile;
      }
      throw Exception('Failed to load profile');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserProfileModel> updateCustomerProfile({
    String? name,
    String? email,
    String? phone,
    String? gender,
    String? profileImageUrl,
  }) async {
    try {
      final Map<String, dynamic> updatePayload = {};
      if (name != null && name.trim().isNotEmpty) {
        updatePayload['full_name'] = name.trim();
      }
      if (email != null && email.trim().isNotEmpty) {
        updatePayload['email'] = email.trim();
      }
      if (profileImageUrl != null && profileImageUrl.trim().isNotEmpty) {
        updatePayload['profile_image_url'] = profileImageUrl.trim();
      }

      if (updatePayload.isNotEmpty) {
        await dio.put(ApiConstants.customerProfile, data: updatePayload);
      }

      return await getCustomerProfile();
    } catch (e) {
      debugPrint('[SettingsRemoteDataSource] updateCustomerProfile error: $e');
      rethrow;
    }
  }

  @override
  Future<String?> uploadProfilePhoto(String filePath) async {
    try {
      final fileName = filePath.split(RegExp(r'[\\/]')).last;
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath, filename: fileName),
      });
      final response = await dio.post('/api/v1/files/upload', data: formData);
      if (response.statusCode == 200 && response.data != null) {
        final Map<String, dynamic> resData = (response.data is Map && response.data['data'] is Map)
            ? Map<String, dynamic>.from(response.data['data'])
            : (response.data is Map ? Map<String, dynamic>.from(response.data) : {});
        final fileUrl = resData['file_url'] ?? resData['url'];
        if (fileUrl != null) {
          return fileUrl.toString();
        }
      }
    } catch (e) {
      debugPrint('[SettingsRemoteDataSource] uploadProfilePhoto error: $e');
    }
    return null;
  }

  Future<void> _persistProfilePreferences(
    SharedPreferences prefs,
    UserProfileModel profile,
    dynamic rawResponse,
  ) async {
    try {
      final Map<String, dynamic> data = (rawResponse is Map && rawResponse['data'] is Map)
          ? Map<String, dynamic>.from(rawResponse['data'])
          : (rawResponse is Map ? Map<String, dynamic>.from(rawResponse) : {});

      final bool isCorp = profile.isCorporate ||
          (profile.companyName != null && profile.companyName!.trim().isNotEmpty);

      await prefs.setBool('is_corporate_user', isCorp);

      if (profile.name.isNotEmpty && profile.name != 'User') {
        await prefs.setString('user_name', profile.name);
      }
      if (profile.phone.isNotEmpty) {
        await prefs.setString('user_phone', profile.phone);
      }
      if (profile.email.isNotEmpty) {
        await prefs.setString('user_email', profile.email);
      }
      if (profile.profileImageUrl != null && profile.profileImageUrl!.isNotEmpty) {
        await prefs.setString('user_profile_image', profile.profileImageUrl!);
      }

      if (isCorp && profile.companyName != null) {
        await prefs.setString('corporate_company_name', profile.companyName!);
        if (profile.corporateId != null && profile.corporateId!.isNotEmpty) {
          await prefs.setString('corporate_employee_code', profile.corporateId!);
        }
        if (profile.spendingLimit != null && profile.spendingLimit!.isNotEmpty) {
          await prefs.setString('corporate_spending_limit', profile.spendingLimit!);
        }
        if (profile.corporateEmail != null && profile.corporateEmail!.isNotEmpty) {
          await prefs.setString('corporate_email', profile.corporateEmail!);
        }
        if (profile.companyLocation != null && profile.companyLocation!.isNotEmpty) {
          await prefs.setString('corporate_location', profile.companyLocation!);
        }

        final activeComp = data['active_company'] is Map ? data['active_company'] : null;
        final corpInfo = data['corporate_info'] is Map ? data['corporate_info'] : null;
        final compIdVal = activeComp?['id'] ?? corpInfo?['company_id'] ?? data['company_id'];
        if (compIdVal != null) {
          final compId = int.tryParse(compIdVal.toString());
          if (compId != null) {
            await prefs.setInt('corporate_company_id', compId);
          }
        }
      }

      await prefs.setString('saved_customer_profile', jsonEncode(data));
      debugPrint('[SettingsRemoteDataSource] Synced profile: isCorporate=$isCorp, company=${profile.companyName}');
    } catch (e) {
      debugPrint('[SettingsRemoteDataSource] Error syncing profile preferences: $e');
    }
  }
}
