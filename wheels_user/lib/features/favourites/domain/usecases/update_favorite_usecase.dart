import '../entities/favorite_place_entity.dart';
import '../repositories/favourites_repository.dart';

class UpdateFavoriteUseCase {
  final FavouritesRepository repository;

  UpdateFavoriteUseCase(this.repository);

  Future<void> call(FavoritePlaceEntity place) async {
    return await repository.updateFavorite(place);
  }
}
