import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/contacts/presentation/bloc/contacts_bloc.dart';
import 'package:wheels_user/features/contacts/presentation/bloc/contacts_event.dart';
import 'package:wheels_user/features/contacts/presentation/bloc/contacts_state.dart';
import 'package:wheels_user/features/contacts/presentation/pages/contacts_permission_page.dart';

class MockContactsBloc extends MockBloc<ContactsEvent, ContactsState>
    implements ContactsBloc {}

void main() {
  late MockContactsBloc mockContactsBloc;

  setUp(() {
    mockContactsBloc = MockContactsBloc();
  });

  Widget buildTestableWidget() {
    return MaterialApp(
      home: BlocProvider<ContactsBloc>.value(
        value: mockContactsBloc,
        child: const ContactsPermissionPage(),
      ),
    );
  }

  testWidgets('ContactsPermissionPage renders title, subtitle, allow button, and skip link',
      (WidgetTester tester) async {
    when(() => mockContactsBloc.state).thenReturn(const ContactsState());

    await tester.pumpWidget(buildTestableWidget());

    expect(find.text('Find Your Contacts'), findsOneWidget);
    expect(find.textContaining('Allow access to contacts'), findsOneWidget);
    expect(find.text('Allow Contacts'), findsOneWidget);
    expect(find.text('Skip'), findsOneWidget);
  });

  testWidgets('tapping Allow Contacts triggers AllowContactsEvent',
      (WidgetTester tester) async {
    when(() => mockContactsBloc.state).thenReturn(const ContactsState());

    await tester.pumpWidget(buildTestableWidget());

    final finder = find.text('Allow Contacts');
    await tester.ensureVisible(finder);
    await tester.tap(finder);
    verify(() => mockContactsBloc.add(const AllowContactsEvent())).called(1);
  });

  testWidgets('tapping Skip triggers SkipContactsEvent',
      (WidgetTester tester) async {
    when(() => mockContactsBloc.state).thenReturn(const ContactsState());

    await tester.pumpWidget(buildTestableWidget());

    final finder = find.text('Skip');
    await tester.ensureVisible(finder);
    await tester.tap(finder);
    verify(() => mockContactsBloc.add(const SkipContactsEvent())).called(1);
  });

  testWidgets('displays SnackBar when contacts permission is granted',
      (WidgetTester tester) async {
    whenListen(
      mockContactsBloc,
      Stream.fromIterable([
        const ContactsState(isPermissionGranted: true),
      ]),
      initialState: const ContactsState(),
    );

    await tester.pumpWidget(buildTestableWidget());
    await tester.pump();

    expect(find.text('Contacts permission granted successfully!'), findsOneWidget);
  });

  testWidgets('displays SnackBar when contacts permission is skipped',
      (WidgetTester tester) async {
    whenListen(
      mockContactsBloc,
      Stream.fromIterable([
        const ContactsState(isSkipped: true),
      ]),
      initialState: const ContactsState(),
    );

    await tester.pumpWidget(buildTestableWidget());
    await tester.pump();

    expect(find.text('Contacts permission skipped.'), findsOneWidget);
  });
}
