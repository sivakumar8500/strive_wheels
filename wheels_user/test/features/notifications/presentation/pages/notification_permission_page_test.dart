import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/core/di/injection_container.dart';
import 'package:wheels_user/features/contacts/presentation/bloc/contacts_bloc.dart';
import 'package:wheels_user/features/contacts/presentation/bloc/contacts_event.dart';
import 'package:wheels_user/features/contacts/presentation/bloc/contacts_state.dart';
import 'package:wheels_user/features/contacts/presentation/pages/contacts_permission_page.dart';
import 'package:wheels_user/features/notifications/presentation/bloc/notification_bloc.dart';
import 'package:wheels_user/features/notifications/presentation/bloc/notification_event.dart';
import 'package:wheels_user/features/notifications/presentation/bloc/notification_state.dart';
import 'package:wheels_user/features/notifications/presentation/pages/notification_permission_page.dart';

class MockNotificationBloc
    extends MockBloc<NotificationEvent, NotificationState>
    implements NotificationBloc {}

class MockContactsBloc extends MockBloc<ContactsEvent, ContactsState>
    implements ContactsBloc {}

void main() {
  late MockNotificationBloc mockNotificationBloc;
  late MockContactsBloc mockContactsBloc;

  setUp(() {
    mockNotificationBloc = MockNotificationBloc();
    mockContactsBloc = MockContactsBloc();

    if (!sl.isRegistered<ContactsBloc>()) {
      sl.registerFactory<ContactsBloc>(() => mockContactsBloc);
    }

    when(() => mockContactsBloc.state).thenReturn(const ContactsState());
  });

  Widget buildTestableWidget() {
    return MaterialApp(
      home: BlocProvider<NotificationBloc>.value(
        value: mockNotificationBloc,
        child: const NotificationPermissionPage(),
      ),
    );
  }

  testWidgets('NotificationPermissionPage renders title, subtitle, enable button, and maybe later link',
      (WidgetTester tester) async {
    when(() => mockNotificationBloc.state).thenReturn(const NotificationState());

    await tester.pumpWidget(buildTestableWidget());

    expect(find.text('Stay Updated'), findsOneWidget);
    expect(find.textContaining('Receive ride status'), findsOneWidget);
    expect(find.text('Enable Notifications'), findsOneWidget);
    expect(find.text('Maybe Later'), findsOneWidget);
  });

  testWidgets('tapping Enable Notifications triggers EnableNotificationsEvent',
      (WidgetTester tester) async {
    when(() => mockNotificationBloc.state).thenReturn(const NotificationState());

    await tester.pumpWidget(buildTestableWidget());

    final finder = find.text('Enable Notifications');
    await tester.ensureVisible(finder);
    await tester.tap(finder);
    verify(() => mockNotificationBloc.add(const EnableNotificationsEvent()))
        .called(1);
  });

  testWidgets('tapping Maybe Later triggers SkipNotificationsEvent',
      (WidgetTester tester) async {
    when(() => mockNotificationBloc.state).thenReturn(const NotificationState());

    await tester.pumpWidget(buildTestableWidget());

    final finder = find.text('Maybe Later');
    await tester.ensureVisible(finder);
    await tester.tap(finder);
    verify(() => mockNotificationBloc.add(const SkipNotificationsEvent()))
        .called(1);
  });

  testWidgets('navigates to ContactsPermissionPage when permission is granted',
      (WidgetTester tester) async {
    whenListen(
      mockNotificationBloc,
      Stream.fromIterable([
        const NotificationState(isPermissionGranted: true),
      ]),
      initialState: const NotificationState(),
    );

    await tester.pumpWidget(buildTestableWidget());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(ContactsPermissionPage), findsOneWidget);
  });

  testWidgets('navigates to ContactsPermissionPage when permission is skipped',
      (WidgetTester tester) async {
    whenListen(
      mockNotificationBloc,
      Stream.fromIterable([
        const NotificationState(isSkipped: true),
      ]),
      initialState: const NotificationState(),
    );

    await tester.pumpWidget(buildTestableWidget());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(ContactsPermissionPage), findsOneWidget);
  });
}
