import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_rider/core/constants/app_strings.dart';
import 'package:wheels_rider/features/splash/presentation/bloc/splash_bloc.dart';
import 'package:wheels_rider/features/splash/presentation/bloc/splash_event.dart';
import 'package:wheels_rider/features/splash/presentation/bloc/splash_state.dart';
import 'package:wheels_rider/features/splash/presentation/pages/splash_page.dart';

class MockSplashBloc extends MockBloc<SplashEvent, SplashState>
    implements SplashBloc {}

void main() {
  late MockSplashBloc mockSplashBloc;

  setUp(() {
    mockSplashBloc = MockSplashBloc();
    when(() => mockSplashBloc.state).thenReturn(SplashInitial());
  });

  Widget buildTestableWidget() {
    return MaterialApp(
      home: BlocProvider<SplashBloc>.value(
        value: mockSplashBloc,
        child: const SplashPage(),
      ),
    );
  }

  testWidgets('renders all brand strings and images properly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestableWidget());

    expect(find.text(AppStrings.appName), findsOneWidget);
    expect(find.text(AppStrings.ownedBy), findsOneWidget);
    expect(find.text(AppStrings.striveGroup), findsOneWidget);
    expect(find.text(AppStrings.striveSubtext), findsOneWidget);
    expect(find.text(AppStrings.backedBy), findsOneWidget);
    expect(find.text(AppStrings.infinitumTechniques), findsOneWidget);
    expect(find.text(AppStrings.infinitumSubtext), findsOneWidget);
  });
}
