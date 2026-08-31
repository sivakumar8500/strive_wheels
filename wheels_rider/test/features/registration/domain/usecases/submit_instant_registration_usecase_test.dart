import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_rider/features/registration/data/models/registration_step_response.dart';
import 'package:wheels_rider/features/registration/domain/repositories/registration_repository.dart';
import 'package:wheels_rider/features/registration/domain/usecases/submit_instant_registration_usecase.dart';

class MockRegistrationRepository extends Mock implements RegistrationRepository {}

void main() {
  late SubmitInstantRegistrationUseCase usecase;
  late MockRegistrationRepository mockRepository;

  setUp(() {
    mockRepository = MockRegistrationRepository();
    usecase = SubmitInstantRegistrationUseCase(mockRepository);
  });

  const tResponse = RegistrationStepResponse(
    success: true,
    data: RegistrationStepData(
      registrationId: 1,
      status: 'IN_PROGRESS',
      currentStep: 2,
      totalSteps: 9,
      progressPercentage: 11.11,
      completedSteps: [1],
      nextStep: 2,
      message: 'Step completed successfully.',
    ),
  );

  test('should call submitInstantRegistration on repository and return response', () async {
    when(() => mockRepository.submitInstantRegistration())
        .thenAnswer((_) async => tResponse);

    final result = await usecase();

    expect(result, tResponse);
    expect(result.success, isTrue);
    expect(result.data.currentStep, 2);
    expect(result.data.nextStep, 2);
    verify(() => mockRepository.submitInstantRegistration()).called(1);
  });
}
