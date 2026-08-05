import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/core/constants/app_strings.dart';
import 'package:wheels_user/features/splash/presentation/bloc/splash_bloc.dart';
import 'package:wheels_user/features/splash/presentation/bloc/splash_event.dart';
import 'package:wheels_user/features/splash/presentation/bloc/splash_state.dart';
import 'package:wheels_user/features/splash/presentation/pages/splash_page.dart';

class MockSplashBloc extends Mock implements SplashBloc {}

class FakeSplashEvent extends Fake implements SplashEvent {}

void main() {
  late MockSplashBloc mockSplashBloc;

  setUpAll(() {
    registerFallbackValue(FakeSplashEvent());
  });

  setUp(() {
    mockSplashBloc = MockSplashBloc();
    when(() => mockSplashBloc.state).thenReturn(const SplashInitial());
    when(() => mockSplashBloc.stream)
        .thenAnswer((_) => const Stream<SplashState>.empty());
    when(() => mockSplashBloc.add(any())).thenReturn(null);
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<SplashBloc>.value(
        value: mockSplashBloc,
        child: const SplashPage(),
      ),
    );
  }

  testWidgets('renders SplashPage with app name and branding text', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text(AppStrings.appName), findsOneWidget);
    expect(find.text(AppStrings.ownedBy), findsOneWidget);
    expect(find.text(AppStrings.backedBy), findsOneWidget);
    expect(find.text(AppStrings.striveGroup), findsOneWidget);
    expect(find.text(AppStrings.infinitumTechniques), findsOneWidget);

    verify(() => mockSplashBloc.add(any())).called(1);
  });
}
