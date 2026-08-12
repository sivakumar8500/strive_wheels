import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_rider/core/constants/app_strings.dart';
import 'package:wheels_rider/features/onboarding/domain/entities/onboarding_item.dart';
import 'package:wheels_rider/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:wheels_rider/features/onboarding/presentation/bloc/onboarding_event.dart';
import 'package:wheels_rider/features/onboarding/presentation/bloc/onboarding_state.dart';
import 'package:wheels_rider/features/onboarding/presentation/pages/onboarding_page.dart';

class MockOnboardingBloc extends MockBloc<OnboardingEvent, OnboardingState>
    implements OnboardingBloc {}

void main() {
  late MockOnboardingBloc mockBloc;

  const sampleItems = [
    OnboardingItem(
      title: AppStrings.onboardingTitle1,
      subtitle: AppStrings.onboardingSubtitle1,
      imagePath: 'assets/images/onboarding_1.png',
    ),
    OnboardingItem(
      title: AppStrings.onboardingTitle2,
      subtitle: AppStrings.onboardingSubtitle2,
      imagePath: 'assets/images/onboarding_2.png',
    ),
  ];

  setUp(() {
    mockBloc = MockOnboardingBloc();
  });

  Widget buildTestableWidget() {
    return MaterialApp(
      home: BlocProvider<OnboardingBloc>.value(
        value: mockBloc,
        child: const OnboardingPage(),
      ),
    );
  }

  testWidgets('renders Onboarding items and title properly', (tester) async {
    when(() => mockBloc.state).thenReturn(
      const OnboardingLoadedState(items: sampleItems, currentPageIndex: 0),
    );

    await tester.pumpWidget(buildTestableWidget());

    expect(find.text(AppStrings.onboardingTitle1), findsOneWidget);
    expect(find.text(AppStrings.onboardingSubtitle1), findsOneWidget);
  });
}
