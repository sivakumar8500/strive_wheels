import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/core/constants/app_strings.dart';
import 'package:wheels_user/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:wheels_user/features/onboarding/presentation/bloc/onboarding_event.dart';
import 'package:wheels_user/features/onboarding/presentation/bloc/onboarding_state.dart';
import 'package:wheels_user/features/onboarding/presentation/pages/onboarding_page.dart';

class MockOnboardingBloc
    extends MockBloc<OnboardingEvent, OnboardingState>
    implements OnboardingBloc {}

void main() {
  late MockOnboardingBloc mockBloc;

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

  testWidgets('renders loading state when initial or loading state',
      (tester) async {
    when(() => mockBloc.state).thenReturn(const OnboardingLoadingState());

    await tester.pumpWidget(buildTestableWidget());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('renders page 1 title, subtitle, and next button when loaded',
      (tester) async {
    when(() => mockBloc.state).thenReturn(
      const OnboardingLoadedState(
        items: OnboardingBloc.onboardingItems,
        currentPageIndex: 0,
        isFirstTime: true,
      ),
    );

    await tester.pumpWidget(buildTestableWidget());

    expect(find.text(AppStrings.onboardingTitle1), findsOneWidget);
    expect(find.text(AppStrings.onboardingSubtitle1), findsOneWidget);
    expect(find.byIcon(Icons.chevron_right), findsOneWidget);
  });
}
