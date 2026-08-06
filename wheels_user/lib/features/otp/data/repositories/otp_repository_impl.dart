import '../../domain/entities/otp_verification_entity.dart';
import '../../domain/repositories/otp_repository.dart';
import '../datasources/otp_remote_datasource.dart';
import '../models/otp_verification_model.dart';

class OtpRepositoryImpl implements OtpRepository {
  final OtpRemoteDataSource remoteDataSource;

  OtpRepositoryImpl({required this.remoteDataSource});

  @override
  Future<bool> verifyOtp(OtpVerificationEntity entity) async {
    final model = OtpVerificationModel.fromEntity(entity);
    return await remoteDataSource.verifyOtp(model);
  }

  @override
  Future<bool> resendOtp(String fullPhoneNumber) async {
    return await remoteDataSource.resendOtp(fullPhoneNumber);
  }
}
