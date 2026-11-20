import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/otp/data/datasources/otp_remote_datasource.dart';
import 'package:wheels_user/features/otp/data/models/otp_verification_model.dart';
import 'package:wheels_user/features/otp/data/repositories/otp_repository_impl.dart';
import 'package:wheels_user/features/otp/domain/entities/otp_verification_entity.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockDio extends Mock implements Dio {}
class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockOtpRemoteDataSource extends Mock implements OtpRemoteDataSource {}

void main() {
  late OtpRepositoryImpl repository;
  late MockOtpRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockOtpRemoteDataSource();
    repository = OtpRepositoryImpl(remoteDataSource: mockRemoteDataSource);
    registerFallbackValue(
      const OtpVerificationModel(
        fullPhoneNumber: '+919876543210',
        otpCode: '702315',
      ),
    );
  });

  const tEntity = OtpVerificationEntity(
    fullPhoneNumber: '+919876543210',
    otpCode: '702315',
  );

  test('fromEntity converts entity to model correctly', () {
    final model = OtpVerificationModel.fromEntity(tEntity);
    expect(model.fullPhoneNumber, '+919876543210');
    expect(model.otpCode, '702315');
  });

  test('fromJson and toJson work on OtpVerificationModel', () {
    const model = OtpVerificationModel(
      fullPhoneNumber: '+919876543210',
      otpCode: '702315',
    );
    final json = model.toJson();
    final fromJsonModel = OtpVerificationModel.fromJson(json);
    expect(fromJsonModel, model);
  });

  test('verifyOtp calls remoteDataSource.verifyOtp and returns true', () async {
    when(() => mockRemoteDataSource.verifyOtp(any()))
        .thenAnswer((_) async => true);

    final result = await repository.verifyOtp(tEntity);

    expect(result, isTrue);
    verify(() => mockRemoteDataSource.verifyOtp(any())).called(1);
  });

  test('resendOtp calls remoteDataSource.resendOtp and returns true', () async {
    when(() => mockRemoteDataSource.resendOtp('+919876543210'))
        .thenAnswer((_) async => true);

    final result = await repository.resendOtp('+919876543210');

    expect(result, isTrue);
    verify(() => mockRemoteDataSource.resendOtp('+919876543210')).called(1);
  });

  test('OtpRemoteDataSourceImpl executes successfully', () async {
    final mockDio = MockDio();
    final mockPrefs = MockSharedPreferences();
    
    when(() => mockDio.post(any(), data: any(named: 'data')))
        .thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: ''),
              statusCode: 200,
              data: {'token': 'fake_token', 'otp': '123456'},
            ));
    when(() => mockPrefs.setString(any(), any())).thenAnswer((_) async => true);
            
    final dataSource = OtpRemoteDataSourceImpl(dio: mockDio, sharedPreferences: mockPrefs);
    const model = OtpVerificationModel(
      fullPhoneNumber: '+919876543210',
      otpCode: '702315',
    );
    final vResult = await dataSource.verifyOtp(model);
    final rResult = await dataSource.resendOtp('+919876543210');
    expect(vResult, isTrue);
    expect(rResult, isTrue);
  });
}
