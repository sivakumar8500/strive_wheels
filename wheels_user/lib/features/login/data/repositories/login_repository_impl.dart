import '../../domain/entities/login_request_entity.dart';
import '../../domain/repositories/login_repository.dart';
import '../datasources/login_remote_datasource.dart';
import '../models/login_request_model.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginRemoteDataSource remoteDataSource;

  LoginRepositoryImpl({required this.remoteDataSource});

  @override
  Future<bool> sendOtp(LoginRequestEntity requestEntity) async {
    final model = LoginRequestModel.fromEntity(requestEntity);
    return await remoteDataSource.sendOtp(model);
  }
}
