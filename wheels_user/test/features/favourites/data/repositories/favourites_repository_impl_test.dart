import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/favourites/data/datasources/favourites_local_datasource.dart';
import 'package:wheels_user/features/favourites/data/models/favorite_place_model.dart';
import 'package:wheels_user/features/favourites/data/models/favourites_model.dart';
import 'package:wheels_user/features/favourites/data/repositories/favourites_repository_impl.dart';

class MockFavouritesLocalDataSource extends Mock
    implements FavouritesLocalDataSource {}

void main() {
  late FavouritesRepositoryImpl repository;
  late MockFavouritesLocalDataSource mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockFavouritesLocalDataSource();
    repository =
        FavouritesRepositoryImpl(localDataSource: mockLocalDataSource);
  });

  const tModel = FavouritesModel(
    shortcutTitle: 'Places you ride to most',
    shortcutSubtitle: 'Tap a place to use it as your next destination.',
    places: [
      FavoritePlaceModel(
        id: '1',
        title: 'Home',
        address: 'Nanakramguda, Hyderabad',
        iconType: 'home',
      ),
    ],
  );

  test('should return FavouritesEntity when local data source succeeds',
      () async {
    when(() => mockLocalDataSource.getFavouritesData())
        .thenAnswer((_) async => tModel);

    final result = await repository.getFavourites();

    expect(result.shortcutTitle, equals('Places you ride to most'));
    expect(result.places.length, equals(1));
    expect(result.places.first.title, equals('Home'));
    verify(() => mockLocalDataSource.getFavouritesData()).called(1);
    verifyNoMoreInteractions(mockLocalDataSource);
  });
}
