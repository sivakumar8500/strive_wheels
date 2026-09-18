import 'package:dio/dio.dart';

import '../../../../core/network/api_constants.dart';
import '../models/user_profile_model.dart';

abstract class SettingsRemoteDataSource {
  Future<UserProfileModel> getCustomerProfile();
}

class SettingsRemoteDataSourceImpl implements SettingsRemoteDataSource {
  final Dio dio;

  SettingsRemoteDataSourceImpl({required this.dio});

  @override
  Future<UserProfileModel> getCustomerProfile() async {
    try {
      final response = await dio.get(ApiConstants.customerProfile);
      if (response.statusCode == 200 && response.data != null) {
        return UserProfileModel.fromJson(response.data);
      }
      throw Exception('Failed to load profile');
    } catch (e) {
      rethrow;
    }
  }
}
