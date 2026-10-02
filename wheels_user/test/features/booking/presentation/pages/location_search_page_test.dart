import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/core/constants/app_strings.dart';
import 'package:wheels_user/features/booking/domain/entities/recent_journey_entity.dart';
import 'package:wheels_user/features/booking/domain/entities/vehicle_option_entity.dart';
import 'package:wheels_user/features/booking/presentation/bloc/booking_bloc.dart';
import 'package:wheels_user/features/booking/presentation/bloc/booking_event.dart';
import 'package:wheels_user/features/booking/presentation/bloc/booking_state.dart';
import 'package:wheels_user/features/booking/presentation/pages/location_search_page.dart';
import 'package:wheels_user/features/booking/presentation/pages/map_location_picker_page.dart';
import 'package:wheels_user/features/booking/presentation/pages/ride_route_map_page.dart';
import 'package:wheels_user/features/favourites/domain/entities/favorite_place_entity.dart';
import 'package:wheels_user/features/favourites/domain/entities/favourites_entity.dart';
import 'package:wheels_user/features/favourites/presentation/bloc/favourites_bloc.dart';
import 'package:wheels_user/features/favourites/presentation/bloc/favourites_event.dart';
import 'package:wheels_user/features/favourites/presentation/bloc/favourites_state.dart';

class MockBookingBloc extends MockBloc<BookingEvent, BookingState>
    implements BookingBloc {}

class MockFavouritesBloc extends MockBloc<FavouritesEvent, FavouritesState>
    implements FavouritesBloc {}

void main() {
  late MockBookingBloc mockBookingBloc;
  late MockFavouritesBloc mockFavouritesBloc;

  const tJourneys = [
    RecentJourneyEntity(
      id: '1',
      title: 'JFK International Airport',
      origin: 'From Lower Manhattan',
      timestamp: '2 days ago',
      iconType: 'history',
    ),
  ];

  const tVehicles = [
    VehicleOptionEntity(
      id: 'v1',
      name: 'Mercedes E-Class',
      specs: '4 Seats · AC · Automatic',
      price: '₹450',
      rating: '4.9 (48)',
      eta: '4 min',
      imagePath: 'assets/images/mercedes_car.png',
    ),
  ];

  const tFavourites = FavouritesEntity(
    shortcutTitle: 'Places you ride to most',
    shortcutSubtitle: 'Tap a place to use as your destination',
    places: [
      FavoritePlaceEntity(
        id: 'fav-1',
        title: 'home-2',
        address: '603, 9th Phase Rd, KPHB Phase III, KPHB Ph...',
        iconType: 'home',
        latitude: 17.4925,
        longitude: 78.3950,
      ),
    ],
  );

  setUpAll(() {
    registerFallbackValue(const LoadBookingDataEvent());
    registerFallbackValue(const LoadFavouritesEvent());
  });

  setUp(() {
    mockBookingBloc = MockBookingBloc();
    mockFavouritesBloc = MockFavouritesBloc();
    when(() => mockFavouritesBloc.state).thenReturn(
      const FavouritesState(
        isLoading: false,
        favouritesEntity: tFavourites,
      ),
    );
  });

  Widget buildTestWidget() {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<BookingBloc>.value(value: mockBookingBloc),
          BlocProvider<FavouritesBloc>.value(value: mockFavouritesBloc),
        ],
        child: const LocationSearchPage(),
      ),
    );
  }

  testWidgets('renders loading indicator when state is loading', (tester) async {
    when(() => mockBookingBloc.state).thenReturn(const BookingState(isLoading: true));

    await tester.pumpWidget(buildTestWidget());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('renders Drop screen header, for me chip, route card, and action pills', (tester) async {
    when(() => mockBookingBloc.state).thenReturn(const BookingState(
      isLoading: false,
      pickupLocation: '5th Avenue, NYC',
      destination: '',
      recentJourneys: tJourneys,
      availableVehicles: tVehicles,
    ));

    await tester.pumpWidget(buildTestWidget());

    expect(find.text(AppStrings.dropTitle), findsOneWidget);
    expect(find.text('Self'), findsOneWidget);
    expect(find.byKey(const Key('route_pickup_text_field')), findsOneWidget);
    expect(find.byKey(const Key('route_drop_text_field')), findsOneWidget);
    expect(find.text('Instant'), findsOneWidget);
    expect(find.text('One-Way'), findsOneWidget);
    expect(find.text('Round Trip'), findsOneWidget);
    expect(find.text('home-2'), findsOneWidget);
  });

  testWidgets('Book Now button is always visible on bottom, initially disabled, and enables when From and To are selected', (tester) async {
    when(() => mockBookingBloc.state).thenReturn(const BookingState(
      isLoading: false,
      pickupLocation: '5th Avenue, NYC',
      destination: '',
      recentJourneys: tJourneys,
      availableVehicles: tVehicles,
    ));

    await tester.pumpWidget(buildTestWidget());

    // 1. Book Now button is rendered at the bottom initially
    final bookBtnFinder = find.byKey(const Key('book_location_button'));
    expect(bookBtnFinder, findsOneWidget);
    expect(find.text(AppStrings.bookNow), findsOneWidget);

    // 2. Button is disabled before drop is selected
    var bookBtn = tester.widget<ElevatedButton>(bookBtnFinder);
    expect(bookBtn.enabled, isFalse);

    // 3. Select a saved location for drop
    final placeFinder = find.text('home-2');
    expect(placeFinder, findsOneWidget);
    await tester.tap(placeFinder);
    await tester.pumpAndSettle();

    // 4. Button is now enabled
    bookBtn = tester.widget<ElevatedButton>(bookBtnFinder);
    expect(bookBtn.enabled, isTrue);
  });

  testWidgets('tapping enabled Book Now button navigates to RideRouteMapPage', (tester) async {
    when(() => mockBookingBloc.state).thenReturn(const BookingState(
      isLoading: false,
      pickupLocation: 'Mindspace Madhapur, Hyderabad',
      destination: '',
      recentJourneys: tJourneys,
      availableVehicles: tVehicles,
    ));

    await tester.pumpWidget(buildTestWidget());

    // Select drop place
    await tester.tap(find.text('home-2'));
    await tester.pumpAndSettle();

    final bookBtn = find.byKey(const Key('book_location_button'));
    expect(bookBtn, findsOneWidget);
    expect(tester.widget<ElevatedButton>(bookBtn).enabled, isTrue);

    await tester.tap(bookBtn);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(RideRouteMapPage), findsOneWidget);
  });

  testWidgets('tapping Set location on map button opens MapLocationPickerPage', (tester) async {
    when(() => mockBookingBloc.state).thenReturn(const BookingState(
      isLoading: false,
      pickupLocation: 'Mindspace Madhapur, Hyderabad',
      destination: '',
      recentJourneys: tJourneys,
      availableVehicles: tVehicles,
    ));

    await tester.pumpWidget(buildTestWidget());

    final setMapBtn = find.byKey(const Key('set_location_on_map_button'));
    expect(setMapBtn, findsOneWidget);

    await tester.tap(setMapBtn);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(MapLocationPickerPage), findsOneWidget);
  });

  testWidgets('shows error message and prevents navigation when distance is <= 500 meters', (tester) async {
    // Both pickup and drop at same / close location
    when(() => mockBookingBloc.state).thenReturn(const BookingState(
      isLoading: false,
      pickupLocation: 'Mindspace Madhapur, Hyderabad',
      destination: '',
      recentJourneys: tJourneys,
      availableVehicles: tVehicles,
    ));

    // Create favourite place that is within 100 meters of Mindspace (17.4401, 78.3811)
    const closeFavourites = FavouritesEntity(
      shortcutTitle: 'Places you ride to most',
      shortcutSubtitle: 'Tap a place to use as your destination',
      places: [
        FavoritePlaceEntity(
          id: 'fav-close',
          title: 'Nearby Gate',
          address: 'Mindspace Gate 2',
          iconType: 'work',
          latitude: 17.4402, // ~15 meters away
          longitude: 78.3812,
        ),
      ],
    );

    when(() => mockFavouritesBloc.state).thenReturn(
      const FavouritesState(
        isLoading: false,
        favouritesEntity: closeFavourites,
      ),
    );

    await tester.pumpWidget(buildTestWidget());

    // Select the nearby location for drop
    await tester.tap(find.text('Nearby Gate'));
    await tester.pumpAndSettle();

    final bookBtn = find.byKey(const Key('book_location_button'));
    expect(tester.widget<ElevatedButton>(bookBtn).enabled, isTrue);

    await tester.tap(bookBtn);
    await tester.pump();

    // Verify error message is shown
    expect(find.text(AppStrings.minDistanceError), findsOneWidget);
    // Verify navigation did NOT happen
    expect(find.byType(RideRouteMapPage), findsNothing);
  });

  testWidgets('selecting favorite location fills the drop point with its address rather than name', (tester) async {
    when(() => mockBookingBloc.state).thenReturn(const BookingState(
      isLoading: false,
      pickupLocation: 'Mindspace Madhapur, Hyderabad',
      destination: '',
      recentJourneys: tJourneys,
      availableVehicles: tVehicles,
    ));

    await tester.pumpWidget(buildTestWidget());

    // Tap favourite item 'home-2'
    await tester.tap(find.text('home-2'));
    await tester.pumpAndSettle();

    // Verify drop text field contains the address, not just the name
    expect(find.text('603, 9th Phase Rd, KPHB Phase III, KPHB Ph...'), findsWidgets);
  });
}

