import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/registration_step_response.dart';

abstract class RegistrationRemoteDataSource {
  Future<RegistrationStepResponse> getRegistrationState();
  Future<RegistrationStepResponse> submitInstantRegistration();
  Future<RegistrationStepResponse> submitPersonalInfo(Map<String, dynamic> data);
  Future<RegistrationStepResponse> submitAddress(Map<String, dynamic> data);
  Future<RegistrationStepResponse> submitKyc(Map<String, dynamic> data);
  Future<RegistrationStepResponse> submitVehicleDetails(Map<String, dynamic> data);
  Future<RegistrationStepResponse> submitVehicleDocuments(Map<String, dynamic> data);
  Future<RegistrationStepResponse> submitBankDetails(Map<String, dynamic> data);
  Future<RegistrationStepResponse> submitEmergencyContact(Map<String, dynamic> data);
  Future<RegistrationStepResponse> submitRegistration(Map<String, dynamic> data);
  Future<String> uploadFile(String filePath);
  Future<List<dynamic>> getVehicleTypes();
}

class RegistrationRemoteDataSourceImpl implements RegistrationRemoteDataSource {
  final ApiClient apiClient;

  RegistrationRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<dynamic>> getVehicleTypes() async {
    final response = await apiClient.get(ApiEndpoints.registrationVehicleTypes);
    if (response.data is Map && response.data['data'] is List) {
      return response.data['data'] as List<dynamic>;
    } else if (response.data is List) {
      return response.data as List<dynamic>;
    }
    return [];
  }

  @override
  Future<RegistrationStepResponse> getRegistrationState() async {
    final response = await apiClient.get(ApiEndpoints.registrationDraft);
    return RegistrationStepResponse.fromJson(response.data);
  }

  @override
  Future<RegistrationStepResponse> submitInstantRegistration() async {
    final response = await apiClient.post(ApiEndpoints.registrationInstant, data: {});
    return RegistrationStepResponse.fromJson(response.data);
  }

  @override
  Future<RegistrationStepResponse> submitPersonalInfo(Map<String, dynamic> data) async {
    final response = await apiClient.post(ApiEndpoints.registrationPersonal, data: data);
    return RegistrationStepResponse.fromJson(response.data);
  }

  @override
  Future<RegistrationStepResponse> submitAddress(Map<String, dynamic> data) async {
    final response = await apiClient.post(ApiEndpoints.registrationAddress, data: data);
    return RegistrationStepResponse.fromJson(response.data);
  }

  @override
  Future<RegistrationStepResponse> submitKyc(Map<String, dynamic> data) async {
    final response = await apiClient.post(ApiEndpoints.registrationKyc, data: data);
    return RegistrationStepResponse.fromJson(response.data);
  }

  @override
  Future<RegistrationStepResponse> submitVehicleDetails(Map<String, dynamic> data) async {
    final response = await apiClient.post(ApiEndpoints.registrationVehicle, data: data);
    return RegistrationStepResponse.fromJson(response.data);
  }

  @override
  Future<RegistrationStepResponse> submitVehicleDocuments(Map<String, dynamic> data) async {
    final response = await apiClient.post(ApiEndpoints.registrationVehicleDocs, data: data);
    return RegistrationStepResponse.fromJson(response.data);
  }

  @override
  Future<RegistrationStepResponse> submitBankDetails(Map<String, dynamic> data) async {
    final response = await apiClient.post(ApiEndpoints.registrationBankDetails, data: data);
    return RegistrationStepResponse.fromJson(response.data);
  }

  @override
  Future<RegistrationStepResponse> submitEmergencyContact(Map<String, dynamic> data) async {
    final response = await apiClient.post(ApiEndpoints.registrationEmergencyContact, data: data);
    return RegistrationStepResponse.fromJson(response.data);
  }

  @override
  Future<RegistrationStepResponse> submitRegistration(Map<String, dynamic> data) async {
    final response = await apiClient.post(ApiEndpoints.registrationSubmit, data: data);
    return RegistrationStepResponse.fromJson(response.data);
  }

  @override
  Future<String> uploadFile(String filePath) async {
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
    
    final response = await apiClient.post(ApiEndpoints.fileUpload, data: formData);
    
    if (response.data is Map) {
      final responseMap = response.data as Map;
      
      // Handle the server response: { success: true, data: { file_url: "/static/uploads/..." } }
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
}
