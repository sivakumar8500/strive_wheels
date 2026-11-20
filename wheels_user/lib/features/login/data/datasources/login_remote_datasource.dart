import '../models/login_request_model.dart';

abstract class LoginRemoteDataSource {
  Future<bool> sendOtp(LoginRequestModel model);
}

class LoginRemoteDataSourceImpl implements LoginRemoteDataSource {
  const LoginRemoteDataSourceImpl();

  @override
  Future<bool> sendOtp(LoginRequestModel model) async {
    // Simulate remote API network call delay
    await Future.delayed(const Duration(milliseconds: 800));
    return true;
  }
}
