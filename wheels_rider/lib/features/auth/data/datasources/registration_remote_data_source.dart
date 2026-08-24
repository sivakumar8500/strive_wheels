import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/registration_step_response.dart';

abstract class RegistrationRemoteDataSource {
  Future<RegistrationStepResponse> submitPersonalInfo(Map<String, dynamic> data);
  Future<RegistrationStepResponse> submitAddress(Map<String, dynamic> data);
  Future<RegistrationStepResponse> submitKyc(Map<String, dynamic> data);
  Future<RegistrationStepResponse> submitVehicleDetails(Map<String, dynamic> data);
  Future<RegistrationStepResponse> submitVehicleDocuments(Map<String, dynamic> data);
  Future<RegistrationStepResponse> submitBankDetails(Map<String, dynamic> data);
  Future<RegistrationStepResponse> submitEmergencyContact(Map<String, dynamic> data);
  Future<RegistrationStepResponse> submitRegistration(Map<String, dynamic> data);
  Future<String> uploadFile(String filePath);
}

class RegistrationRemoteDataSourceImpl implements RegistrationRemoteDataSource {
  final ApiClient apiClient;

  RegistrationRemoteDataSourceImpl({required this.apiClient});

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
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
    });
    
    final response = await apiClient.post(ApiEndpoints.fileUpload, data: formData);
    
    if (response.data is Map) {
      final responseMap = response.data as Map;
      
      // Handle the server response: { success: true, data: { file_url: "/static/uploads/..." } }
      if (responseMap['data'] is Map && responseMap['data']['file_url'] is String) {
        final fileUrl = responseMap['data']['file_url'] as String;
        if (fileUrl.startsWith('http')) {
          return fileUrl;
        }
        return 'http://15.252.129.37:8200$fileUrl';
      }
      
      if (responseMap['data'] is String) {
        return responseMap['data'];
      } else if (responseMap['url'] is String) {
        return responseMap['url'];
      } else if (responseMap['data'] is Map && responseMap['data']['url'] is String) {
        return responseMap['data']['url'];
      }
    }
    return response.data.toString();
  }
}
