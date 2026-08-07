import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/settings/domain/entities/settings_entity.dart';
import 'package:wheels_user/features/settings/domain/entities/user_profile_entity.dart';
import 'package:wheels_user/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:wheels_user/features/settings/presentation/bloc/settings_event.dart';
import 'package:wheels_user/features/settings/presentation/bloc/settings_state.dart';
import 'package:wheels_user/features/settings/presentation/pages/settings_page.dart';

class MockSettingsBloc extends MockBloc<SettingsEvent, SettingsState>
    implements SettingsBloc {}

void main() {
  late MockSettingsBloc mockBloc;

  const tEntity = SettingsEntity(
    profile: UserProfileEntity(
      name: 'Alexander Pierce',
      membershipTier: 'DIAMOND MEMBER',
      totalRides: '48',
      rating: '4.98',
    ),
    rideNotificationsEnabled: true,
    isDarkMode: false,
    selectedLanguage: 'English (India)',
    appVersion: 'Version 2.4.12 (Build 4492)',
  );

  setUpAll(() {
    registerFallbackValue(const LoadSettingsEvent());
    registerFallbackValue(const LogoutEvent());
    registerFallbackValue(const ToggleRideNotificationsEvent(false));
  });

  setUp(() {
    mockBloc = MockSettingsBloc();
  });

  Widget buildTestWidget() {
    return MaterialApp(
      home: BlocProvider<SettingsBloc>.value(
        value: mockBloc,
        child: const SettingsPage(),
      ),
    );
  }

  testWidgets('renders loading indicator when state is loading', (tester) async {
    when(() => mockBloc.state).thenReturn(const SettingsState(isLoading: true));

    await tester.pumpWidget(buildTestWidget());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('renders profile header, user stats, account and preference groups when loaded', (tester) async {
    when(() => mockBloc.state).thenReturn(const SettingsState(
      isLoading: false,
      settingsEntity: tEntity,
    ));

    await tester.pumpWidget(buildTestWidget());

    expect(find.text('Alexander Pierce'), findsOneWidget);
    expect(find.text('DIAMOND MEMBER'), findsOneWidget);
    expect(find.text('48'), findsOneWidget);
    expect(find.text('Total Rides'), findsOneWidget);
    expect(find.text('4.98'), findsOneWidget);
    expect(find.text('Rating'), findsOneWidget);
    expect(find.text('Personal details'), findsOneWidget);
    expect(find.text('Wallet & payments'), findsOneWidget);
    expect(find.text('Corporate profile'), findsOneWidget);
    expect(find.text('Ride notifications'), findsOneWidget);
    expect(find.text('Appearance'), findsOneWidget);
    expect(find.text('Language'), findsOneWidget);
    expect(find.text('Logout'), findsOneWidget);
    expect(find.text('Version 2.4.12 (Build 4492)'), findsOneWidget);
  });

  testWidgets('tapping Logout button fires LogoutEvent', (tester) async {
    when(() => mockBloc.state).thenReturn(const SettingsState(
      isLoading: false,
      settingsEntity: tEntity,
    ));

    await tester.pumpWidget(buildTestWidget());

    await tester.ensureVisible(find.byKey(const Key('logout_button')));
    await tester.tap(find.byKey(const Key('logout_button')));
    await tester.pump();

    verify(() => mockBloc.add(const LogoutEvent())).called(1);
  });
}
