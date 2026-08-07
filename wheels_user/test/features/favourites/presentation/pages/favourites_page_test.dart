import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/favourites/domain/entities/favorite_place_entity.dart';
import 'package:wheels_user/features/favourites/domain/entities/favourites_entity.dart';
import 'package:wheels_user/features/favourites/presentation/bloc/favourites_bloc.dart';
import 'package:wheels_user/features/favourites/presentation/bloc/favourites_event.dart';
import 'package:wheels_user/features/favourites/presentation/bloc/favourites_state.dart';
import 'package:wheels_user/features/favourites/presentation/pages/favourites_page.dart';

class MockFavouritesBloc extends MockBloc<FavouritesEvent, FavouritesState>
    implements FavouritesBloc {}

void main() {
  late MockFavouritesBloc mockBloc;

  const tEntity = FavouritesEntity(
    shortcutTitle: 'Places you ride to most',
    shortcutSubtitle: 'Tap a place to use it as your next destination.',
    places: [
      FavoritePlaceEntity(
        id: '1',
        title: 'Home',
        address: 'Nanakramguda, Hyderabad',
        iconType: 'home',
      ),
      FavoritePlaceEntity(
        id: '2',
        title: 'Office',
        address: 'Mindspace IT Park, Madhapur',
        iconType: 'office',
      ),
    ],
  );

  setUpAll(() {
    registerFallbackValue(const LoadFavouritesEvent());
    registerFallbackValue(const RideHereEvent(placeId: '1', placeTitle: 'Home'));
  });

  setUp(() {
    mockBloc = MockFavouritesBloc();
  });

  Widget buildTestWidget() {
    return MaterialApp(
      home: BlocProvider<FavouritesBloc>.value(
        value: mockBloc,
        child: const FavouritesPage(),
      ),
    );
  }

  testWidgets('renders loading indicator when state is loading', (tester) async {
    when(() => mockBloc.state).thenReturn(const FavouritesState(isLoading: true));

    await tester.pumpWidget(buildTestWidget());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('renders Saved Places header, shortcut shelf, and place cards when loaded', (tester) async {
    when(() => mockBloc.state).thenReturn(const FavouritesState(
      isLoading: false,
      favouritesEntity: tEntity,
    ));

    await tester.pumpWidget(buildTestWidget());

    expect(find.text('Favorites'), findsOneWidget);
    expect(find.text('Get moving with fewer taps.'), findsOneWidget);
    expect(find.text('Places you ride to most'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Nanakramguda, Hyderabad'), findsOneWidget);
    expect(find.text('Office'), findsOneWidget);
    expect(find.text('Save another place'), findsOneWidget);
  });

  testWidgets('tapping Ride here button fires RideHereEvent', (tester) async {
    when(() => mockBloc.state).thenReturn(const FavouritesState(
      isLoading: false,
      favouritesEntity: tEntity,
    ));

    await tester.pumpWidget(buildTestWidget());

    await tester.tap(find.byKey(const Key('ride_here_button_1')));
    await tester.pump();

    verify(() => mockBloc.add(const RideHereEvent(
          placeId: '1',
          placeTitle: 'Home',
        ))).called(1);
  });
}
