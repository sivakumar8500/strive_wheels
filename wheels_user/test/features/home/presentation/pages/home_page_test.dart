import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/home/domain/entities/home_dashboard_entity.dart';
import 'package:wheels_user/features/home/presentation/bloc/home_bloc.dart';
import 'package:wheels_user/features/home/presentation/bloc/home_event.dart';
import 'package:wheels_user/features/home/presentation/bloc/home_state.dart';
import 'package:wheels_user/features/home/presentation/pages/home_page.dart';

class MockHomeBloc extends MockBloc<HomeEvent, HomeState> implements HomeBloc {}

void main() {
  late MockHomeBloc mockHomeBloc;

  setUp(() {
    mockHomeBloc = MockHomeBloc();
  });

  const tEntity = HomeDashboardEntity(
    userName: 'JW',
    greetingTitle: 'Good Morning 👋',
    greetingSubtitle: 'Siri, ready for your next ride?',
    recentRideTitle: 'Office ➔ Home',
    recentRideDetails: 'Yesterday • Bike • ₹185',
  );

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<HomeBloc>.value(
        value: mockHomeBloc,
        child: const HomePage(),
      ),
    );
  }

  testWidgets('renders CircularProgressIndicator when state is loading',
      (widgetTester) async {
    when(() => mockHomeBloc.state).thenReturn(const HomeState(isLoading: true));

    await widgetTester.pumpWidget(createWidgetUnderTest());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('renders Home Dashboard elements when loaded', (widgetTester) async {
    when(() => mockHomeBloc.state).thenReturn(
      const HomeState(
        isLoading: false,
        dashboardEntity: tEntity,
        selectedNavIndex: 0,
      ),
    );

    await widgetTester.pumpWidget(createWidgetUnderTest());
    await widgetTester.pumpAndSettle();

    expect(find.text('Good Morning 👋'), findsOneWidget);
    expect(find.text('Siri, ready for your next ride?'), findsOneWidget);
    expect(find.text('Office ➔ Home'), findsOneWidget);
    expect(find.text('Quick ride services'), findsOneWidget);
    expect(find.text('Bike'), findsOneWidget);
    expect(find.text('Auto'), findsOneWidget);
    expect(find.text('Offers for you'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
  });

  testWidgets('entering text in search bar triggers SearchQueryChangedEvent',
      (widgetTester) async {
    when(() => mockHomeBloc.state).thenReturn(
      const HomeState(
        isLoading: false,
        dashboardEntity: tEntity,
        selectedNavIndex: 0,
      ),
    );

    await widgetTester.pumpWidget(createWidgetUnderTest());
    await widgetTester.pumpAndSettle();

    final searchTextField = find.byKey(const Key('home_search_text_field'));
    expect(searchTextField, findsOneWidget);

    await widgetTester.tap(searchTextField);
    await widgetTester.enterText(searchTextField, 'Charminar');
    await widgetTester.pump();
    verify(() => mockHomeBloc.add(const SearchQueryChangedEvent('Charminar'))).called(greaterThanOrEqualTo(1));
  });

  testWidgets('tapping menu, mic, notifications, and avatar buttons triggers respective events',
      (widgetTester) async {
    when(() => mockHomeBloc.state).thenReturn(
      const HomeState(
        isLoading: false,
        dashboardEntity: tEntity,
        selectedNavIndex: 0,
      ),
    );

    await widgetTester.pumpWidget(createWidgetUnderTest());
    await widgetTester.pumpAndSettle();

    await widgetTester.tap(find.byKey(const Key('home_search_menu_button')));
    verify(() => mockHomeBloc.add(const OpenMenuEvent())).called(1);

    await widgetTester.tap(find.byKey(const Key('home_search_mic_button')));
    verify(() => mockHomeBloc.add(const OpenMicEvent())).called(1);

    await widgetTester.tap(find.byKey(const Key('home_search_notifications_button')));
    verify(() => mockHomeBloc.add(const OpenNotificationsEvent())).called(1);

    await widgetTester.tap(find.byKey(const Key('home_search_avatar_button')));
    verify(() => mockHomeBloc.add(const OpenProfileEvent())).called(1);
  });
}
