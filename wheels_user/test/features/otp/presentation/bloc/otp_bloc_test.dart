import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/otp/domain/entities/otp_verification_entity.dart';
import 'package:wheels_user/features/otp/domain/usecases/resend_otp_usecase.dart';
import 'package:wheels_user/features/otp/domain/usecases/verify_otp_usecase.dart';
import 'package:wheels_user/features/otp/presentation/bloc/otp_bloc.dart';
import 'package:wheels_user/features/otp/presentation/bloc/otp_event.dart';
import 'package:wheels_user/features/otp/presentation/bloc/otp_state.dart';

class MockVerifyOtpUseCase extends Mock implements VerifyOtpUseCase {}
class MockResendOtpUseCase extends Mock implements ResendOtpUseCase {}

void main() {
  late OtpBloc otpBloc;
  late MockVerifyOtpUseCase mockVerifyOtpUseCase;
  late MockResendOtpUseCase mockResendOtpUseCase;

  setUp(() {
    mockVerifyOtpUseCase = MockVerifyOtpUseCase();
    mockResendOtpUseCase = MockResendOtpUseCase();
    registerFallbackValue(
      const OtpVerificationEntity(
        fullPhoneNumber: '+919876543210',
        otpCode: '702315',
      ),
    );
  });

  OtpBloc buildBloc() {
    return OtpBloc(
      fullPhoneNumber: '+919876543210',
      verifyOtpUseCase: mockVerifyOtpUseCase,
      resendOtpUseCase: mockResendOtpUseCase,
    );
  }

  test('initial state sets fullPhoneNumber and default countdown', () {
    otpBloc = buildBloc();
    expect(otpBloc.state.fullPhoneNumber, '+919876543210');
    expect(otpBloc.state.isOtpValid, isFalse);
    otpBloc.close();
  });

  blocTest<OtpBloc, OtpState>(
    'emits isOtpValid true when 6 digits entered',
    build: buildBloc,
    act: (bloc) => bloc.add(const OtpCodeChangedEvent('702315')),
    expect: () => [
      const OtpState(
        fullPhoneNumber: '+919876543210',
        otpCode: '',
        isOtpValid: false,
        countdownSeconds: 30,
      ),
      const OtpState(
        fullPhoneNumber: '+919876543210',
        otpCode: '702315',
        isOtpValid: true,
        countdownSeconds: 30,
      ),
    ],
  );

  blocTest<OtpBloc, OtpState>(
    'emits isSubmitting true and then isSuccess true on successful SubmitOtpEvent',
    build: () {
      when(() => mockVerifyOtpUseCase(any()))
          .thenAnswer((_) async => true);
      return buildBloc();
    },
    act: (bloc) {
      bloc.add(const OtpCodeChangedEvent('702315'));
      bloc.add(const SubmitOtpEvent());
    },
    expect: () => [
      const OtpState(
        fullPhoneNumber: '+919876543210',
        otpCode: '',
        isOtpValid: false,
        countdownSeconds: 30,
      ),
      const OtpState(
        fullPhoneNumber: '+919876543210',
        otpCode: '702315',
        isOtpValid: true,
        countdownSeconds: 30,
      ),
      const OtpState(
        fullPhoneNumber: '+919876543210',
        otpCode: '702315',
        isOtpValid: true,
        countdownSeconds: 30,
        isSubmitting: true,
      ),
      const OtpState(
        fullPhoneNumber: '+919876543210',
        otpCode: '702315',
        isOtpValid: true,
        countdownSeconds: 30,
        isSubmitting: false,
        isSuccess: true,
      ),
    ],
  );

  blocTest<OtpBloc, OtpState>(
    'emits errorMessage when verifyOtp fails',
    build: () {
      when(() => mockVerifyOtpUseCase(any()))
          .thenAnswer((_) async => false);
      return buildBloc();
    },
    act: (bloc) {
      bloc.add(const OtpCodeChangedEvent('702315'));
      bloc.add(const SubmitOtpEvent());
    },
    expect: () => [
      const OtpState(
        fullPhoneNumber: '+919876543210',
        otpCode: '',
        isOtpValid: false,
        countdownSeconds: 30,
      ),
      const OtpState(
        fullPhoneNumber: '+919876543210',
        otpCode: '702315',
        isOtpValid: true,
        countdownSeconds: 30,
      ),
      const OtpState(
        fullPhoneNumber: '+919876543210',
        otpCode: '702315',
        isOtpValid: true,
        countdownSeconds: 30,
        isSubmitting: true,
      ),
      const OtpState(
        fullPhoneNumber: '+919876543210',
        otpCode: '702315',
        isOtpValid: true,
        countdownSeconds: 30,
        isSubmitting: false,
        errorMessage: 'Invalid OTP verification code.',
      ),
    ],
  );
}
