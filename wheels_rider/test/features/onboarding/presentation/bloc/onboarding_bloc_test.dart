import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_rider/core/constants/app_strings.dart';
import 'package:wheels_rider/features/onboarding/domain/entities/onboarding_item.dart';
import 'package:wheels_rider/features/onboarding/domain/usecases/complete_onboarding.dart';
import 'package:wheels_rider/features/onboarding/domain/usecases/get_onboarding_items.dart';
import 'package:wheels_rider/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:wheels_rider/features/onboarding/presentation/bloc/onboarding_event.dart';
import 'package:wheels_rider/features/onboarding/presentation/bloc/onboarding_state.dart';

class MockGetOnboardingItems extends Mock implements GetOnboardingItems {}

class MockCompleteOnboarding extends Mock implements CompleteOnboarding {}

void main() {
  late MockGetOnboardingItems mockGetOnboardingItems;
  late MockCompleteOnboarding mockCompleteOnboarding;

  const sampleItems = [
    OnboardingItem(
      title: AppStrings.onboardingTitle1,
      subtitle: AppStrings.onboardingSubtitle1,
      imagePath: 'path1',
    ),
    OnboardingItem(
      title: AppStrings.onboardingTitle2,
      subtitle: AppStrings.onboardingSubtitle2,
      imagePath: 'path2',
    ),
  ];

  setUp(() {
    mockGetOnboardingItems = MockGetOnboardingItems();
    mockCompleteOnboarding = MockCompleteOnboarding();
  });

  group('OnboardingBloc Tests', () {
    test('initial state is OnboardingInitialState', () {
      final bloc = OnboardingBloc(
        getOnboardingItems: mockGetOnboardingItems,
        completeOnboarding: mockCompleteOnboarding,
      );
      expect(bloc.state, isA<OnboardingInitialState>());
      bloc.close();
    });

    blocTest<OnboardingBloc, OnboardingState>(
      'emits [OnboardingLoadingState, OnboardingLoadedState] when CheckFirstTimeEvent added',
      build: () {
        when(() => mockGetOnboardingItems()).thenReturn(sampleItems);
        return OnboardingBloc(
          getOnboardingItems: mockGetOnboardingItems,
          completeOnboarding: mockCompleteOnboarding,
        );
      },
      act: (bloc) => bloc.add(const CheckFirstTimeEvent()),
      expect: () => [
        isA<OnboardingLoadingState>(),
        isA<OnboardingLoadedState>(),
      ],
    );

    blocTest<OnboardingBloc, OnboardingState>(
      'updates currentPageIndex on OnboardingPageChangedEvent',
      build: () {
        when(() => mockGetOnboardingItems()).thenReturn(sampleItems);
        return OnboardingBloc(
          getOnboardingItems: mockGetOnboardingItems,
          completeOnboarding: mockCompleteOnboarding,
        );
      },
      seed: () =>
          const OnboardingLoadedState(items: sampleItems, currentPageIndex: 0),
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
      'advances to next page or emits OnboardingCompletedState when NextOnboardingPageEvent added',
      build: () {
        when(() => mockGetOnboardingItems()).thenReturn(sampleItems);
        when(() => mockCompleteOnboarding()).thenAnswer((_) async {});
        return OnboardingBloc(
          getOnboardingItems: mockGetOnboardingItems,
          completeOnboarding: mockCompleteOnboarding,
        );
      },
      seed: () =>
          const OnboardingLoadedState(items: sampleItems, currentPageIndex: 1),
      act: (bloc) => bloc.add(const NextOnboardingPageEvent()),
      expect: () => [isA<OnboardingCompletedState>()],
    );
  });
}
