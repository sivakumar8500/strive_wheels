import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/core/di/injection_container.dart';
import 'package:wheels_user/features/booking/presentation/bloc/booking_bloc.dart';
import 'package:wheels_user/features/booking/presentation/bloc/booking_event.dart';
import 'package:wheels_user/features/booking/presentation/bloc/booking_state.dart';
import 'package:wheels_user/features/booking/presentation/pages/location_search_page.dart';
import 'package:wheels_user/features/home/domain/entities/home_dashboard_entity.dart';
import 'package:wheels_user/features/home/presentation/bloc/home_bloc.dart';
import 'package:wheels_user/features/home/presentation/bloc/home_event.dart';
import 'package:wheels_user/features/home/presentation/bloc/home_state.dart';
import 'package:wheels_user/features/home/presentation/pages/home_page.dart';

class MockHomeBloc extends MockBloc<HomeEvent, HomeState> implements HomeBloc {}
class MockBookingBloc extends MockBloc<BookingEvent, BookingState> implements BookingBloc {}

void main() {
  late MockHomeBloc mockHomeBloc;
  late MockBookingBloc mockBookingBloc;

  setUpAll(() {
    registerFallbackValue(const LoadBookingDataEvent());
    mockBookingBloc = MockBookingBloc();
    when(() => mockBookingBloc.state).thenReturn(const BookingState());
    if (!sl.isRegistered<BookingBloc>()) {
      sl.registerFactory<BookingBloc>(() => mockBookingBloc);
    }
  });

  setUp(() {
    mockHomeBloc = MockHomeBloc();
  });

  const tEntity = HomeDashboardEntity(
    userName: 'JW',
    greetingTitle: 'Good Morning 👋',
    greetingSubtitle: 'Siri, ready for your next ride?',
    recentRideTitle: 'Office ➔ Home',
    recentRideDetails: 'Yesterday • Bike • ₹185',
    quickServices: [
      QuickServiceEntity(id: '1', title: 'Bike', subtitle: 'Quick', iconUrl: ''),
      QuickServiceEntity(id: '2', title: 'Auto', subtitle: 'Standard', iconUrl: ''),
    ],
    popularLocations: [
      PopularLocationEntity(id: '1', title: 'Work', address: '123 Main St', type: 'work'),
    ],
    coupons: [
      CouponEntity(id: '1', title: 'Get 50% Off', code: 'OFFER10', description: '10% off'),
    ],
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
    await widgetTester.pump();
    await widgetTester.pump(const Duration(milliseconds: 500));

    expect(find.text('Good Morning 👋'), findsOneWidget);
    expect(find.text('Siri, ready for your next ride?'), findsOneWidget);
    expect(find.text('Office ➔ Home'), findsOneWidget);
    expect(find.text('Quick ride services'), findsOneWidget);
    expect(find.text('Bike'), findsOneWidget);
    expect(find.text('Auto'), findsOneWidget);
    expect(find.text('Work'), findsOneWidget);
    expect(find.text('Offers for you'), findsOneWidget);
    expect(find.text('Get 50% Off'), findsOneWidget);
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
    await widgetTester.pump();
    await widgetTester.pump(const Duration(milliseconds: 500));

    final searchTextField = find.byKey(const Key('home_search_text_field'));
    expect(searchTextField, findsOneWidget);

    await widgetTester.enterText(searchTextField, 'Charminar');
    await widgetTester.pump();
    verify(() => mockHomeBloc.add(const SearchQueryChangedEvent('Charminar'))).called(greaterThanOrEqualTo(1));
  });

  testWidgets('tapping search bar navigates to LocationSearchPage',
      (widgetTester) async {
    when(() => mockHomeBloc.state).thenReturn(
      const HomeState(
        isLoading: false,
        dashboardEntity: tEntity,
        selectedNavIndex: 0,
      ),
    );

    await widgetTester.pumpWidget(createWidgetUnderTest());
    await widgetTester.pump();
    await widgetTester.pump(const Duration(milliseconds: 500));

    final searchTextField = find.byKey(const Key('home_search_text_field'));
    await widgetTester.tap(searchTextField);
    await widgetTester.pumpAndSettle();

    expect(find.byType(LocationSearchPage), findsOneWidget);
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
    await widgetTester.pump();
    await widgetTester.pump(const Duration(milliseconds: 500));

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
