import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/login/domain/entities/login_request_entity.dart';
import 'package:wheels_user/features/login/domain/repositories/login_repository.dart';
import 'package:wheels_user/features/login/domain/usecases/send_otp_usecase.dart';

class MockLoginRepository extends Mock implements LoginRepository {}

void main() {
  late SendOtpUseCase useCase;
  late MockLoginRepository mockRepository;

  setUp(() {
    mockRepository = MockLoginRepository();
    useCase = SendOtpUseCase(mockRepository);
  });

  const tEntity = LoginRequestEntity(
    countryCode: '+91',
    phoneNumber: '9876543210',
  );

  test('should return full phone number correctly', () {
    expect(tEntity.fullPhoneNumber, '+919876543210');
  });

  test('should call repository.sendOtp with correct entity', () async {
    when(() => mockRepository.sendOtp(tEntity))
        .thenAnswer((_) async => true);

    final result = await useCase(tEntity);

    expect(result, isTrue);
    verify(() => mockRepository.sendOtp(tEntity)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
