import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/history/domain/entities/past_ride_item_entity.dart';
import 'package:wheels_user/features/history/domain/entities/ride_history_entity.dart';
import 'package:wheels_user/features/history/presentation/bloc/ride_history_bloc.dart';
import 'package:wheels_user/features/history/presentation/bloc/ride_history_event.dart';
import 'package:wheels_user/features/history/presentation/bloc/ride_history_state.dart';
import 'package:wheels_user/features/history/presentation/pages/ride_history_page.dart';

class MockRideHistoryBloc
    extends MockBloc<RideHistoryEvent, RideHistoryState>
    implements RideHistoryBloc {}

void main() {
  late MockRideHistoryBloc mockBloc;

  const tEntity = RideHistoryEntity(
    monthlySummaryTitle: 'June ride summary',
    tripCountText: '12 trips',
    distanceText: '184 km this month',
    spentText: '₹2,486 spent',
    pastRides: [
      PastRideItemEntity(
        id: '1',
        title: 'Mindspace IT Park ➔ Home',
        dateAndVehicle: 'Yesterday · 6:42 PM · Bike',
        status: 'Completed',
        amount: '₹185',
        serviceType: 'Bike',
      ),
      PastRideItemEntity(
        id: '2',
        title: 'Home ➔ Rajiv Gandhi Airport',
        dateAndVehicle: 'Jun 18 · 5:15 AM · Mini',
        status: 'Completed',
        amount: '₹528',
        serviceType: 'Mini',
      ),
    ],
  );

  setUpAll(() {
    registerFallbackValue(const LoadRideHistoryEvent());
    registerFallbackValue(const FilterTripsTabEvent(0));
    registerFallbackValue(const BookAgainEvent(rideId: '1', rideTitle: ''));
  });

  setUp(() {
    mockBloc = MockRideHistoryBloc();
  });

  Widget buildTestWidget({VoidCallback? onMenuTap, VoidCallback? onNotificationTap}) {
    return MaterialApp(
      home: BlocProvider<RideHistoryBloc>.value(
        value: mockBloc,
        child: RideHistoryPage(
          onMenuTap: onMenuTap,
          onNotificationTap: onNotificationTap,
        ),
      ),
    );
  }

  testWidgets('renders loading indicator when state is loading', (tester) async {
    when(() => mockBloc.state).thenReturn(const RideHistoryState(isLoading: true));

    await tester.pumpWidget(buildTestWidget());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('renders Ride History header, summary card, and ride cards when loaded', (tester) async {
    when(() => mockBloc.state).thenReturn(const RideHistoryState(
      isLoading: false,
      historyEntity: tEntity,
    ));

    await tester.pumpWidget(buildTestWidget());

    expect(find.text('Strive'), findsOneWidget);
    expect(find.text('Ride history'), findsOneWidget);
    expect(find.text('Every trip, right where you need it.'), findsOneWidget);
    expect(find.text('June ride summary'), findsOneWidget);
    expect(find.text('12 trips'), findsOneWidget);
    expect(find.text('Mindspace IT Park ➔ Home'), findsOneWidget);
    expect(find.text('Home ➔ Rajiv Gandhi Airport'), findsOneWidget);
  });

  testWidgets('tapping filter tab fires FilterTripsTabEvent', (tester) async {
    when(() => mockBloc.state).thenReturn(const RideHistoryState(
      isLoading: false,
      historyEntity: tEntity,
      selectedFilterIndex: 0,
    ));

    await tester.pumpWidget(buildTestWidget());

    await tester.tap(find.byKey(const Key('filter_tab_1')));
    await tester.pump();

    verify(() => mockBloc.add(const FilterTripsTabEvent(1))).called(1);
  });

  testWidgets('tapping Book again button fires BookAgainEvent', (tester) async {
    when(() => mockBloc.state).thenReturn(const RideHistoryState(
      isLoading: false,
      historyEntity: tEntity,
    ));

    await tester.pumpWidget(buildTestWidget());

    await tester.tap(find.byKey(const Key('book_again_button_1')));
    await tester.pump();

    verify(() => mockBloc.add(const BookAgainEvent(
      rideId: '1',
      rideTitle: 'Mindspace IT Park ➔ Home',
    ))).called(1);
  });
}
