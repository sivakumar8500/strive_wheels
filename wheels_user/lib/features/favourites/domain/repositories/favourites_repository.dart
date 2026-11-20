import '../entities/favourites_entity.dart';

abstract class FavouritesRepository {
  Future<FavouritesEntity> getFavourites();
}
