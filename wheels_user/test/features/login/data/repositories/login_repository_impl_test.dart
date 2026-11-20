import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/login/data/datasources/login_remote_datasource.dart';
import 'package:wheels_user/features/login/data/models/login_request_model.dart';
import 'package:wheels_user/features/login/data/repositories/login_repository_impl.dart';
import 'package:wheels_user/features/login/domain/entities/login_request_entity.dart';

class MockLoginRemoteDataSource extends Mock implements LoginRemoteDataSource {}

void main() {
  late LoginRepositoryImpl repository;
  late MockLoginRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockLoginRemoteDataSource();
    repository = LoginRepositoryImpl(remoteDataSource: mockRemoteDataSource);
    registerFallbackValue(
      const LoginRequestModel(countryCode: '+91', phoneNumber: '9876543210'),
    );
  });

  const tEntity = LoginRequestEntity(
    countryCode: '+91',
    phoneNumber: '9876543210',
  );

  test('fromEntity converts entity to model correctly', () {
    final model = LoginRequestModel.fromEntity(tEntity);
    expect(model.countryCode, '+91');
    expect(model.phoneNumber, '9876543210');
  });

  test('fromJson and toJson work correctly on LoginRequestModel', () {
    const model = LoginRequestModel(countryCode: '+91', phoneNumber: '9876543210');
    final json = model.toJson();
    final fromJsonModel = LoginRequestModel.fromJson(json);
    expect(fromJsonModel, model);
  });

  test('sendOtp calls remoteDataSource.sendOtp and returns true', () async {
    when(() => mockRemoteDataSource.sendOtp(any()))
        .thenAnswer((_) async => true);

    final result = await repository.sendOtp(tEntity);

    expect(result, isTrue);
    verify(() => mockRemoteDataSource.sendOtp(any())).called(1);
  });

  test('LoginRemoteDataSourceImpl executes successfully', () async {
    const dataSource = LoginRemoteDataSourceImpl();
    const model = LoginRequestModel(countryCode: '+91', phoneNumber: '9876543210');
    final result = await dataSource.sendOtp(model);
    expect(result, isTrue);
  });
}
