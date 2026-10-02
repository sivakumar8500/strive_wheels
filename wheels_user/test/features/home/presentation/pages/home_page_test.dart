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
import 'package:wheels_user/features/home/presentation/widgets/home_search_bar.dart';

import 'package:wheels_user/features/notifications/domain/entities/notification_entity.dart';
import 'package:wheels_user/features/notifications/domain/repositories/notification_repository.dart';
import 'package:wheels_user/features/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:wheels_user/features/notifications/domain/usecases/get_unread_count_usecase.dart';
import 'package:wheels_user/features/notifications/domain/usecases/mark_notification_read_usecase.dart';
import 'package:wheels_user/features/notifications/domain/usecases/mark_all_read_usecase.dart';
import 'package:wheels_user/features/notifications/presentation/bloc/notification_bloc.dart';
import 'package:wheels_user/features/notifications/presentation/pages/notifications_page.dart';

class MockHomeBloc extends MockBloc<HomeEvent, HomeState> implements HomeBloc {}
class MockBookingBloc extends MockBloc<BookingEvent, BookingState> implements BookingBloc {}
class MockNotificationRepo implements NotificationRepository {
  @override
  Future<List<NotificationEntity>> getNotifications({int limit = 50, int skip = 0}) async => [];
  @override
  Future<int> getUnreadCount() async => 0;
  @override
  Future<bool> markAsRead(int notificationId) async => true;
  @override
  Future<int> markAllAsRead() async => 0;
}

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
    final mockNotifRepo = MockNotificationRepo();
    if (!sl.isRegistered<GetNotificationsUseCase>()) {
      sl.registerLazySingleton<GetNotificationsUseCase>(() => GetNotificationsUseCase(mockNotifRepo));
      sl.registerLazySingleton<GetUnreadCountUseCase>(() => GetUnreadCountUseCase(mockNotifRepo));
      sl.registerLazySingleton<MarkNotificationReadUseCase>(() => MarkNotificationReadUseCase(mockNotifRepo));
      sl.registerLazySingleton<MarkAllReadUseCase>(() => MarkAllReadUseCase(mockNotifRepo));
      sl.registerFactory<NotificationBloc>(() => NotificationBloc(
        getNotificationsUseCase: sl(),
        getUnreadCountUseCase: sl(),
        markNotificationReadUseCase: sl(),
        markAllReadUseCase: sl(),
      ));
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

    expect(find.textContaining('👋'), findsOneWidget);
    expect(find.text('Siri, ready for your next ride?'), findsOneWidget);
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

    final searchBar = widgetTester.widget<HomeSearchBar>(find.byType(HomeSearchBar));
    searchBar.onChanged?.call('Charminar');
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

  testWidgets('tapping avatar button triggers ChangeNavTabEvent to settings tab',
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

    await widgetTester.tap(find.byKey(const Key('home_search_avatar_button')));
    verify(() => mockHomeBloc.add(const ChangeNavTabEvent(3))).called(1);
  });

  testWidgets('tapping notifications button navigates to NotificationsPage',
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

    await widgetTester.tap(find.byKey(const Key('home_search_notifications_button')));
    await widgetTester.pumpAndSettle();

    expect(find.byType(NotificationsPage), findsOneWidget);
  });
}
