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
import 'package:wheels_user/features/home/presentation/bloc/home_bloc.dart';
import 'package:wheels_user/features/home/presentation/bloc/home_event.dart';
import 'package:wheels_user/features/home/presentation/bloc/home_state.dart';
import 'package:wheels_user/features/home/presentation/pages/home_page.dart';

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

  testWidgets('navigates to HomePage when contacts permission is granted',
      (WidgetTester tester) async {
    final mockHomeBloc = MockHomeBloc();
    when(() => mockHomeBloc.state).thenReturn(const HomeState(isLoading: true));

    if (sl.isRegistered<HomeBloc>()) {
      sl.unregister<HomeBloc>();
    }
    sl.registerFactory<HomeBloc>(() => mockHomeBloc);

    whenListen(
      mockContactsBloc,
      Stream.fromIterable([
        const ContactsState(isPermissionGranted: true),
      ]),
      initialState: const ContactsState(),
    );

    await tester.pumpWidget(buildTestableWidget());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(HomePage), findsOneWidget);
  });

  testWidgets('navigates to HomePage when contacts permission is skipped',
      (WidgetTester tester) async {
    final mockHomeBloc = MockHomeBloc();
    when(() => mockHomeBloc.state).thenReturn(const HomeState(isLoading: true));

    if (sl.isRegistered<HomeBloc>()) {
      sl.unregister<HomeBloc>();
    }
    sl.registerFactory<HomeBloc>(() => mockHomeBloc);

    whenListen(
      mockContactsBloc,
      Stream.fromIterable([
        const ContactsState(isSkipped: true),
      ]),
      initialState: const ContactsState(),
    );

    await tester.pumpWidget(buildTestableWidget());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(HomePage), findsOneWidget);
  });
}

class MockHomeBloc extends MockBloc<HomeEvent, HomeState> implements HomeBloc {}

