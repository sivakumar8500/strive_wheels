import '../entities/favorite_place_entity.dart';
import '../repositories/favourites_repository.dart';

class AddFavoriteUseCase {
  final FavouritesRepository repository;

  AddFavoriteUseCase(this.repository);

  Future<void> call(FavoritePlaceEntity place) async {
    return await repository.addFavorite(place);
  }
}
