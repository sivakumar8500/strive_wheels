import '../entities/favorite_place_entity.dart';
import '../entities/favourites_entity.dart';

abstract class FavouritesRepository {
  Future<FavouritesEntity> getFavourites();
  Future<void> addFavorite(FavoritePlaceEntity place);
  Future<void> updateFavorite(FavoritePlaceEntity place);
  Future<void> deleteFavorite(String id);
}
