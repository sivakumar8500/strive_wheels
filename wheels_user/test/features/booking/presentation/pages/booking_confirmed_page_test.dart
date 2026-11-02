import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wheels_user/core/di/injection_container.dart';
import 'package:wheels_user/core/network/customer_ws_controller.dart';
import 'package:wheels_user/core/services/active_booking_service.dart';
import 'package:wheels_user/features/booking/presentation/pages/booking_confirmed_page.dart';
import 'package:wheels_user/features/home/presentation/bloc/home_bloc.dart';
import 'package:wheels_user/features/home/presentation/bloc/home_event.dart';
import 'package:wheels_user/features/home/presentation/bloc/home_state.dart';
import 'package:wheels_user/features/home/presentation/pages/home_page.dart';

class MockHomeBloc extends MockBloc<HomeEvent, HomeState> implements HomeBloc {}
class MockCustomerWSController extends Mock implements CustomerWSController {}
class MockDio extends Mock implements Dio {}

void main() {
  late MockHomeBloc mockHomeBloc;
  late MockCustomerWSController mockWs;
  late MockDio mockDio;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    mockHomeBloc = MockHomeBloc();
    when(() => mockHomeBloc.state).thenReturn(const HomeState());
    when(() => mockHomeBloc.stream).thenAnswer((_) => const Stream.empty());

    mockWs = MockCustomerWSController();
    when(() => mockWs.bookingEventStream).thenAnswer((_) => const Stream.empty());

    mockDio = MockDio();
    when(() => mockDio.get(any())).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 200,
          data: {'status': 'RIDER_ACCEPTED'},
        ));

    if (!sl.isRegistered<SharedPreferences>()) {
      sl.registerSingleton<SharedPreferences>(prefs);
    }
    if (!sl.isRegistered<ActiveBookingService>()) {
      sl.registerSingleton<ActiveBookingService>(ActiveBookingService(prefs));
    }
    if (!sl.isRegistered<HomeBloc>()) {
      sl.registerFactory<HomeBloc>(() => mockHomeBloc);
    }
    if (!sl.isRegistered<CustomerWSController>()) {
      sl.registerSingleton<CustomerWSController>(mockWs);
    }
    if (!sl.isRegistered<Dio>()) {
      sl.registerSingleton<Dio>(mockDio);
    }
  });

  Widget buildTestWidget() {
    return const MaterialApp(
      home: BookingConfirmedPage(
        bookingId: 'ER-9921-X4B',
        driverName: 'Marcus Thorne',
        driverRating: 4.9,
        vehicleModel: 'BMW i7 xDrive60',
        licensePlate: '7396',
        pickupAddress: 'The Ritz-Carlton',
        dropAddress: 'JFK Airport',
        startOtp: '4589',
        totalAmount: '₹124.00',
      ),
    );
  }

  testWidgets('renders BookingConfirmedPage with back button, driver details, and OTP', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    // Verify back button is present in AppBar
    expect(find.byKey(const Key('booking_confirmed_back_button')), findsOneWidget);

    // Verify booking confirmed title and driver name
    expect(find.text('Booking Confirmed!'), findsOneWidget);
    expect(find.text('Marcus Thorne'), findsOneWidget);
    expect(find.text('4589'), findsOneWidget);
  });

  testWidgets('tapping back button on BookingConfirmedPage navigates to HomePage', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    final backButton = find.byKey(const Key('booking_confirmed_back_button'));
    expect(backButton, findsOneWidget);

    await tester.tap(backButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    // ActiveBookingService should have saved the active booking
    final activeBooking = sl<ActiveBookingService>().activeBooking;
    expect(activeBooking, isNotNull);
    expect(activeBooking?.driverName, 'Marcus Thorne');
    expect(find.byType(HomePage), findsOneWidget);
  });
}
