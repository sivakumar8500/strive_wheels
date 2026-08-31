import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile();
  Future<ProfileModel> updateProfile(Map<String, dynamic> data);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiClient _apiClient;

  ProfileRemoteDataSourceImpl(this._apiClient);

  @override
  Future<ProfileModel> getProfile() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.riderProfile);
      return ProfileModel.fromJson(response.data['data'] ?? response.data);
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Failed to get profile');
    }
  }

  Future<String> _uploadFile(String filePath) async {
    MultipartFile multipartFile;
    final filename = filePath.split('/').last.split('\\').last;

    if (kIsWeb || filePath.startsWith('blob:') || filePath.startsWith('http')) {
      final xfile = XFile(filePath);
      final bytes = await xfile.readAsBytes();
      multipartFile = MultipartFile.fromBytes(
        bytes,
        filename: filename.contains('.') ? filename : 'upload.jpg',
      );
    } else {
      multipartFile = await MultipartFile.fromFile(filePath, filename: filename);
    }

    final formData = FormData.fromMap({
      'file': multipartFile,
    });

    final response = await _apiClient.post(ApiEndpoints.fileUpload, data: formData);

    if (response.data is Map) {
      final responseMap = response.data as Map;
      if (responseMap['data'] is Map && responseMap['data']['file_url'] is String) {
        return ApiEndpoints.getImageUrl(responseMap['data']['file_url'] as String);
      }
      if (responseMap['data'] is String) {
        return ApiEndpoints.getImageUrl(responseMap['data'] as String);
      } else if (responseMap['url'] is String) {
        return ApiEndpoints.getImageUrl(responseMap['url'] as String);
      } else if (responseMap['data'] is Map && responseMap['data']['url'] is String) {
        return ApiEndpoints.getImageUrl(responseMap['data']['url'] as String);
      }
    }
    return ApiEndpoints.getImageUrl(response.data.toString());
  }

  @override
  Future<ProfileModel> updateProfile(Map<String, dynamic> data) async {
    try {
      String photoUrl = data['profile_photo_url'] ?? '';
      if (photoUrl.isNotEmpty && !photoUrl.startsWith('http')) {
        photoUrl = await _uploadFile(photoUrl);
      }

      String formattedDob = data['dob'] ?? '';
      if (formattedDob.isNotEmpty) {
        try {
          if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(formattedDob)) {
            final parts = formattedDob.split('/');
            if (parts.length == 3) {
              final month = parts[0].padLeft(2, '0');
              final day = parts[1].padLeft(2, '0');
              final year = parts[2];
              formattedDob = "$year-$month-$day";
            }
          }
        } catch (_) {}
      }

      final payload = {
        "first_name": data['first_name'] ?? "",
        "last_name": data['last_name'] ?? "",
        "mobile_number": data['mobile_number'] ?? "",
        "email": data['email'] ?? "",
        "dob": formattedDob,
        "gender": (data['gender'] ?? "").toString().toUpperCase(),
        "referral_code": data['referral_code'] ?? "",
        "profile_photo_url": photoUrl,
      };

      await _apiClient.put(
        ApiEndpoints.registrationPersonal,
        data: payload,
      );

      // Fetch the updated profile to return the correct ProfileModel
      final profileResponse = await _apiClient.get(ApiEndpoints.riderProfile);
      return ProfileModel.fromJson(profileResponse.data['data'] ?? profileResponse.data);
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Failed to update profile');
    }
  }
}
