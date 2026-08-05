import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/onboarding/domain/usecases/check_first_time_usecase.dart';
import 'package:wheels_user/features/onboarding/domain/usecases/complete_onboarding_usecase.dart';
import 'package:wheels_user/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:wheels_user/features/onboarding/presentation/bloc/onboarding_event.dart';
import 'package:wheels_user/features/onboarding/presentation/bloc/onboarding_state.dart';

class MockCheckFirstTimeUseCase extends Mock
    implements CheckFirstTimeUseCase {}

class MockCompleteOnboardingUseCase extends Mock
    implements CompleteOnboardingUseCase {}

void main() {
  late MockCheckFirstTimeUseCase mockCheckFirstTimeUseCase;
  late MockCompleteOnboardingUseCase mockCompleteOnboardingUseCase;
  late OnboardingBloc onboardingBloc;

  setUp(() {
    mockCheckFirstTimeUseCase = MockCheckFirstTimeUseCase();
    mockCompleteOnboardingUseCase = MockCompleteOnboardingUseCase();
    onboardingBloc = OnboardingBloc(
      checkFirstTimeUseCase: mockCheckFirstTimeUseCase,
      completeOnboardingUseCase: mockCompleteOnboardingUseCase,
    );
  });

  tearDown(() {
    onboardingBloc.close();
  });

  group('OnboardingBloc', () {
    test('initial state is OnboardingInitialState', () {
      expect(onboardingBloc.state, isA<OnboardingInitialState>());
    });

    blocTest<OnboardingBloc, OnboardingState>(
      'emits [OnboardingLoadingState, OnboardingLoadedState] when CheckFirstTimeEvent is added and isFirstTime is true',
      build: () {
        when(() => mockCheckFirstTimeUseCase()).thenAnswer((_) async => true);
        return onboardingBloc;
      },
      act: (bloc) => bloc.add(const CheckFirstTimeEvent()),
      expect: () => [
        isA<OnboardingLoadingState>(),
        isA<OnboardingLoadedState>().having(
          (s) => s.currentPageIndex,
          'currentPageIndex',
          0,
        ),
      ],
    );

    blocTest<OnboardingBloc, OnboardingState>(
      'emits [OnboardingLoadingState, OnboardingCompletedState] when CheckFirstTimeEvent is added and isFirstTime is false',
      build: () {
        when(() => mockCheckFirstTimeUseCase()).thenAnswer((_) async => false);
        return onboardingBloc;
      },
      act: (bloc) => bloc.add(const CheckFirstTimeEvent()),
      expect: () => [
        isA<OnboardingLoadingState>(),
        isA<OnboardingCompletedState>(),
      ],
    );

    blocTest<OnboardingBloc, OnboardingState>(
      'updates page index on OnboardingPageChangedEvent',
      build: () => onboardingBloc,
      seed: () => const OnboardingLoadedState(
        items: OnboardingBloc.onboardingItems,
        currentPageIndex: 0,
        isFirstTime: true,
      ),
      act: (bloc) => bloc.add(const OnboardingPageChangedEvent(1)),
      expect: () => [
        isA<OnboardingLoadedState>().having(
          (s) => s.currentPageIndex,
          'currentPageIndex',
          1,
        ),
      ],
    );

    blocTest<OnboardingBloc, OnboardingState>(
      'advances to next page on NextOnboardingPageEvent',
      build: () => onboardingBloc,
      seed: () => const OnboardingLoadedState(
        items: OnboardingBloc.onboardingItems,
        currentPageIndex: 0,
        isFirstTime: true,
      ),
      act: (bloc) => bloc.add(const NextOnboardingPageEvent()),
      expect: () => [
        isA<OnboardingLoadedState>().having(
          (s) => s.currentPageIndex,
          'currentPageIndex',
          1,
        ),
      ],
    );

    blocTest<OnboardingBloc, OnboardingState>(
      'completes onboarding when NextOnboardingPageEvent is fired on last page',
      build: () {
        when(() => mockCompleteOnboardingUseCase()).thenAnswer((_) async {});
        return onboardingBloc;
      },
      seed: () => const OnboardingLoadedState(
        items: OnboardingBloc.onboardingItems,
        currentPageIndex: 1,
        isFirstTime: true,
      ),
      act: (bloc) => bloc.add(const NextOnboardingPageEvent()),
      expect: () => [
        isA<OnboardingCompletedState>(),
      ],
      verify: (_) {
        verify(() => mockCompleteOnboardingUseCase()).called(1);
      },
    );
  });
}
