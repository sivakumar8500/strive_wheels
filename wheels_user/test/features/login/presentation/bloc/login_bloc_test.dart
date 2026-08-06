import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/login/domain/entities/login_request_entity.dart';
import 'package:wheels_user/features/login/domain/usecases/send_otp_usecase.dart';
import 'package:wheels_user/features/login/presentation/bloc/login_bloc.dart';
import 'package:wheels_user/features/login/presentation/bloc/login_event.dart';
import 'package:wheels_user/features/login/presentation/bloc/login_state.dart';

class MockSendOtpUseCase extends Mock implements SendOtpUseCase {}

void main() {
  late LoginBloc loginBloc;
  late MockSendOtpUseCase mockSendOtpUseCase;

  setUp(() {
    mockSendOtpUseCase = MockSendOtpUseCase();
    loginBloc = LoginBloc(sendOtpUseCase: mockSendOtpUseCase);
    registerFallbackValue(
      const LoginRequestEntity(countryCode: '+91', phoneNumber: '9876543210'),
    );
  });

  tearDown(() {
    loginBloc.close();
  });

  test('initial state has default countryCode and invalid phoneNumber', () {
    expect(loginBloc.state.countryCode, '+91');
    expect(loginBloc.state.phoneNumber, '');
    expect(loginBloc.state.isPhoneNumberValid, isFalse);
    expect(loginBloc.state.isSubmitting, isFalse);
    expect(loginBloc.state.isSuccess, isFalse);
  });

  blocTest<LoginBloc, LoginState>(
    'emits state with isPhoneNumberValid true when 10-digit number entered',
    build: () => loginBloc,
    act: (bloc) => bloc.add(const PhoneNumberChangedEvent('9876543210')),
    expect: () => [
      const LoginState(
        countryCode: '+91',
        phoneNumber: '9876543210',
        isPhoneNumberValid: true,
      ),
    ],
  );

  blocTest<LoginBloc, LoginState>(
    'emits state with isPhoneNumberValid false when invalid number entered',
    build: () => loginBloc,
    act: (bloc) => bloc.add(const PhoneNumberChangedEvent('123')),
    expect: () => [
      const LoginState(
        countryCode: '+91',
        phoneNumber: '123',
        isPhoneNumberValid: false,
      ),
    ],
  );

  blocTest<LoginBloc, LoginState>(
    'emits updated countryCode on CountryCodeChangedEvent',
    build: () => loginBloc,
    act: (bloc) => bloc.add(const CountryCodeChangedEvent('+1')),
    expect: () => [
      const LoginState(
        countryCode: '+1',
        phoneNumber: '',
        isPhoneNumberValid: false,
      ),
    ],
  );

  blocTest<LoginBloc, LoginState>(
    'emits isSubmitting true and then isSuccess true on successful SubmitLoginEvent',
    build: () {
      when(() => mockSendOtpUseCase(any()))
          .thenAnswer((_) async => true);
      return loginBloc;
    },
    act: (bloc) {
      bloc.add(const PhoneNumberChangedEvent('9876543210'));
      bloc.add(const SubmitLoginEvent());
    },
    expect: () => [
      const LoginState(
        countryCode: '+91',
        phoneNumber: '9876543210',
        isPhoneNumberValid: true,
      ),
      const LoginState(
        countryCode: '+91',
        phoneNumber: '9876543210',
        isPhoneNumberValid: true,
        isSubmitting: true,
      ),
      const LoginState(
        countryCode: '+91',
        phoneNumber: '9876543210',
        isPhoneNumberValid: true,
        isSubmitting: false,
        isSuccess: true,
      ),
    ],
  );

  blocTest<LoginBloc, LoginState>(
    'emits errorMessage when sendOtp returns false',
    build: () {
      when(() => mockSendOtpUseCase(any()))
          .thenAnswer((_) async => false);
      return loginBloc;
    },
    act: (bloc) {
      bloc.add(const PhoneNumberChangedEvent('9876543210'));
      bloc.add(const SubmitLoginEvent());
    },
    expect: () => [
      const LoginState(
        countryCode: '+91',
        phoneNumber: '9876543210',
        isPhoneNumberValid: true,
      ),
      const LoginState(
        countryCode: '+91',
        phoneNumber: '9876543210',
        isPhoneNumberValid: true,
        isSubmitting: true,
      ),
      const LoginState(
        countryCode: '+91',
        phoneNumber: '9876543210',
        isPhoneNumberValid: true,
        isSubmitting: false,
        errorMessage: 'Failed to send OTP. Please try again.',
      ),
    ],
  );

  blocTest<LoginBloc, LoginState>(
    'emits errorMessage when sendOtp throws Exception',
    build: () {
      when(() => mockSendOtpUseCase(any()))
          .thenThrow(Exception('Server failure'));
      return loginBloc;
    },
    act: (bloc) {
      bloc.add(const PhoneNumberChangedEvent('9876543210'));
      bloc.add(const SubmitLoginEvent());
    },
    expect: () => [
      const LoginState(
        countryCode: '+91',
        phoneNumber: '9876543210',
        isPhoneNumberValid: true,
      ),
      const LoginState(
        countryCode: '+91',
        phoneNumber: '9876543210',
        isPhoneNumberValid: true,
        isSubmitting: true,
      ),
      const LoginState(
        countryCode: '+91',
        phoneNumber: '9876543210',
        isPhoneNumberValid: true,
        isSubmitting: false,
        errorMessage: 'An unexpected error occurred.',
      ),
    ],
  );
}
