import 'package:dio/dio.dart';
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

  @override
  Future<ProfileModel> updateProfile(Map<String, dynamic> data) async {
    try {
      await _apiClient.post(
        ApiEndpoints.registrationPersonal,
        data: data,
      );
      // Fetch the updated profile to return the correct ProfileModel
      final profileResponse = await _apiClient.get(ApiEndpoints.riderProfile);
      return ProfileModel.fromJson(profileResponse.data['data'] ?? profileResponse.data);
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Failed to update profile');
    }
  }
}
