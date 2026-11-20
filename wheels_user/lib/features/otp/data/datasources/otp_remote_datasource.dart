import '../models/otp_verification_model.dart';

abstract class OtpRemoteDataSource {
  Future<bool> verifyOtp(OtpVerificationModel model);
  Future<bool> resendOtp(String fullPhoneNumber);
}

class OtpRemoteDataSourceImpl implements OtpRemoteDataSource {
  const OtpRemoteDataSourceImpl();

  @override
  Future<bool> verifyOtp(OtpVerificationModel model) async {
    // Simulate remote API delay
    await Future.delayed(const Duration(milliseconds: 800));
    return true;
  }

  @override
  Future<bool> resendOtp(String fullPhoneNumber) async {
    // Simulate remote API delay
    await Future.delayed(const Duration(milliseconds: 600));
    return true;
  }
}
