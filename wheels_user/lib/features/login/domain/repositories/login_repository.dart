import '../entities/login_request_entity.dart';

/// Abstract repository contract for login feature.
abstract class LoginRepository {
  Future<bool> sendOtp(LoginRequestEntity requestEntity);
}
