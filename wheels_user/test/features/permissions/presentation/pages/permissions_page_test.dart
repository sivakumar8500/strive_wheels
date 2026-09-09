import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheels_user/core/widgets/app_button.dart';
import 'package:wheels_user/features/permissions/presentation/bloc/permissions_bloc.dart';
import 'package:wheels_user/features/permissions/presentation/bloc/permissions_event.dart';
import 'package:wheels_user/features/permissions/presentation/bloc/permissions_state.dart';
import 'package:wheels_user/features/permissions/presentation/pages/permissions_page.dart';

class MockPermissionsBloc extends MockBloc<PermissionsEvent, PermissionsState> implements PermissionsBloc {}

void main() {
  late MockPermissionsBloc mockBloc;

  setUp(() {
    mockBloc = MockPermissionsBloc();
  });

  Widget buildTestWidget() {
    return MaterialApp(
      home: BlocProvider<PermissionsBloc>.value(
        value: mockBloc,
        child: const PermissionsPage(),
      ),
    );
  }

  testWidgets('shows CircularProgressIndicator when isLoading is true', (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(const PermissionsState(isLoading: true));

    await tester.pumpWidget(buildTestWidget());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('renders permissions list cards and dispatches toggle events', (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(const PermissionsState(
      isLoading: false,
      notificationsAllowed: false,
      contactsAllowed: true,
      locationAllowed: false,
    ));

    await tester.pumpWidget(buildTestWidget());

    // Verify UI texts
    expect(find.text('App Permissions'), findsOneWidget);
    expect(find.text('Notifications'), findsOneWidget);
    expect(find.text('Contacts'), findsOneWidget);
    expect(find.text('Location'), findsOneWidget);

    // Verify switches
    final switches = tester.widgetList<Switch>(find.byType(Switch)).toList();
    expect(switches.length, 3);
    
    // Switch 0 = notifications (false)
    expect(switches[0].value, false);
    // Switch 1 = contacts (true)
    expect(switches[1].value, true);
    // Switch 2 = location (false)
    expect(switches[2].value, false);

    // Tap Notifications switch
    await tester.tap(find.byType(Switch).first);
    await tester.pump();
    verify(() => mockBloc.add(const ToggleNotificationEvent(true))).called(1);
    
    // Tap Continue button
    await tester.tap(find.byType(AppButton));
    await tester.pump();
    verify(() => mockBloc.add(const SubmitPermissionsEvent())).called(1);
  });
}
