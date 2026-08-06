import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/otp/domain/entities/otp_verification_entity.dart';
import 'package:wheels_user/features/otp/domain/repositories/otp_repository.dart';
import 'package:wheels_user/features/otp/domain/usecases/resend_otp_usecase.dart';
import 'package:wheels_user/features/otp/domain/usecases/verify_otp_usecase.dart';

class MockOtpRepository extends Mock implements OtpRepository {}

void main() {
  late VerifyOtpUseCase verifyOtpUseCase;
  late ResendOtpUseCase resendOtpUseCase;
  late MockOtpRepository mockRepository;

  setUp(() {
    mockRepository = MockOtpRepository();
    verifyOtpUseCase = VerifyOtpUseCase(mockRepository);
    resendOtpUseCase = ResendOtpUseCase(mockRepository);
  });

  const tEntity = OtpVerificationEntity(
    fullPhoneNumber: '+919876543210',
    otpCode: '702315',
  );

  test('verifyOtpUseCase calls repository.verifyOtp', () async {
    when(() => mockRepository.verifyOtp(tEntity))
        .thenAnswer((_) async => true);

    final result = await verifyOtpUseCase(tEntity);

    expect(result, isTrue);
    verify(() => mockRepository.verifyOtp(tEntity)).called(1);
  });

  test('resendOtpUseCase calls repository.resendOtp', () async {
    when(() => mockRepository.resendOtp('+919876543210'))
        .thenAnswer((_) async => true);

    final result = await resendOtpUseCase('+919876543210');

    expect(result, isTrue);
    verify(() => mockRepository.resendOtp('+919876543210')).called(1);
  });
}
