import '../../domain/repositories/registration_repository.dart';
import '../datasources/registration_remote_data_source.dart';
import '../models/registration_step_response.dart';

class RegistrationRepositoryImpl implements RegistrationRepository {
  final RegistrationRemoteDataSource remoteDataSource;

  RegistrationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<RegistrationStepResponse> submitPersonalInfo(Map<String, dynamic> data) async {
    return remoteDataSource.submitPersonalInfo(data);
  }

  @override
  Future<RegistrationStepResponse> submitAddress(Map<String, dynamic> data) async {
    return remoteDataSource.submitAddress(data);
  }

  @override
  Future<RegistrationStepResponse> submitKyc(Map<String, dynamic> data) async {
    return remoteDataSource.submitKyc(data);
  }

  @override
  Future<RegistrationStepResponse> submitVehicleDetails(Map<String, dynamic> data) async {
    return remoteDataSource.submitVehicleDetails(data);
  }

  @override
  Future<RegistrationStepResponse> submitVehicleDocuments(Map<String, dynamic> data) async {
    return remoteDataSource.submitVehicleDocuments(data);
  }

  @override
  Future<RegistrationStepResponse> submitBankDetails(Map<String, dynamic> data) async {
    return remoteDataSource.submitBankDetails(data);
  }

  @override
  Future<RegistrationStepResponse> submitEmergencyContact(Map<String, dynamic> data) async {
    return remoteDataSource.submitEmergencyContact(data);
  }

  @override
  Future<RegistrationStepResponse> submitRegistration(Map<String, dynamic> data) async {
    return remoteDataSource.submitRegistration(data);
  }

  @override
  Future<String> uploadFile(String filePath) async {
    return remoteDataSource.uploadFile(filePath);
  }
}
