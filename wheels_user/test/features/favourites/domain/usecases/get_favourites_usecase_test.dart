import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/favourites/domain/entities/favorite_place_entity.dart';
import 'package:wheels_user/features/favourites/domain/entities/favourites_entity.dart';
import 'package:wheels_user/features/favourites/domain/repositories/favourites_repository.dart';
import 'package:wheels_user/features/favourites/domain/usecases/get_favourites_usecase.dart';

class MockFavouritesRepository extends Mock implements FavouritesRepository {}

void main() {
  late GetFavouritesUseCase useCase;
  late MockFavouritesRepository mockRepository;

  setUp(() {
    mockRepository = MockFavouritesRepository();
    useCase = GetFavouritesUseCase(mockRepository);
  });

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

  test('should return FavouritesEntity from repository', () async {
    when(() => mockRepository.getFavourites())
        .thenAnswer((_) async => tEntity);

    final result = await useCase();

    expect(result, equals(tEntity));
    verify(() => mockRepository.getFavourites()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
