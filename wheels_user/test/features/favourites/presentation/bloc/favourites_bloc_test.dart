import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/favourites/domain/entities/favorite_place_entity.dart';
import 'package:wheels_user/features/favourites/domain/entities/favourites_entity.dart';
import 'package:wheels_user/features/favourites/domain/usecases/add_favorite_usecase.dart';
import 'package:wheels_user/features/favourites/domain/usecases/update_favorite_usecase.dart';
import 'package:wheels_user/features/favourites/domain/usecases/delete_favorite_usecase.dart';
import 'package:wheels_user/features/favourites/domain/usecases/get_favourites_usecase.dart';
import 'package:wheels_user/features/favourites/presentation/bloc/favourites_bloc.dart';
import 'package:wheels_user/features/favourites/presentation/bloc/favourites_event.dart';
import 'package:wheels_user/features/favourites/presentation/bloc/favourites_state.dart';

class MockGetFavouritesUseCase extends Mock implements GetFavouritesUseCase {}
class MockAddFavoriteUseCase extends Mock implements AddFavoriteUseCase {}
class MockUpdateFavoriteUseCase extends Mock implements UpdateFavoriteUseCase {}
class MockDeleteFavoriteUseCase extends Mock implements DeleteFavoriteUseCase {}

void main() {
  late FavouritesBloc bloc;
  late MockGetFavouritesUseCase mockGetFavouritesUseCase;
  late MockAddFavoriteUseCase mockAddFavoriteUseCase;
  late MockUpdateFavoriteUseCase mockUpdateFavoriteUseCase;
  late MockDeleteFavoriteUseCase mockDeleteFavoriteUseCase;

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
    ],
  );

  setUp(() {
    mockGetFavouritesUseCase = MockGetFavouritesUseCase();
    mockAddFavoriteUseCase = MockAddFavoriteUseCase();
    mockUpdateFavoriteUseCase = MockUpdateFavoriteUseCase();
    mockDeleteFavoriteUseCase = MockDeleteFavoriteUseCase();
    bloc = FavouritesBloc(
      getFavouritesUseCase: mockGetFavouritesUseCase,
      addFavoriteUseCase: mockAddFavoriteUseCase,
      updateFavoriteUseCase: mockUpdateFavoriteUseCase,
      deleteFavoriteUseCase: mockDeleteFavoriteUseCase,
    );
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state is FavouritesState with isLoading true', () {
    expect(bloc.state.isLoading, isTrue);
  });

  blocTest<FavouritesBloc, FavouritesState>(
    'emits state with favouritesEntity on LoadFavouritesEvent success',
    build: () {
      when(() => mockGetFavouritesUseCase())
          .thenAnswer((_) async => tEntity);
      return bloc;
    },
    act: (bloc) => bloc.add(const LoadFavouritesEvent()),
    expect: () => [
      isA<FavouritesState>().having((s) => s.isLoading, 'isLoading', isTrue),
      isA<FavouritesState>()
          .having((s) => s.isLoading, 'isLoading', isFalse)
          .having((s) => s.favouritesEntity, 'favouritesEntity', tEntity),
    ],
    verify: (_) {
      verify(() => mockGetFavouritesUseCase()).called(1);
    },
  );

  blocTest<FavouritesBloc, FavouritesState>(
    'emits rideMessage on RideHereEvent',
    build: () => bloc,
    act: (bloc) => bloc.add(const RideHereEvent(placeId: '1', placeTitle: 'Home')),
    expect: () => [
      isA<FavouritesState>().having(
        (s) => s.rideMessage,
        'rideMessage',
        'Setting destination to Home...',
      ),
    ],
  );

  blocTest<FavouritesBloc, FavouritesState>(
    'emits actionMessage on SaveAnotherPlaceEvent',
    build: () => bloc,
    act: (bloc) => bloc.add(const SaveAnotherPlaceEvent()),
    expect: () => [
      isA<FavouritesState>().having(
        (s) => s.actionMessage,
        'actionMessage',
        'Opening search to save new place...',
      ),
    ],
  );
}
