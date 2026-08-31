import '../../data/models/registration_step_response.dart';

abstract class RegistrationRepository {
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
