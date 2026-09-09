import '../entities/favourites_entity.dart';
import '../repositories/favourites_repository.dart';

class GetFavouritesUseCase {
  final FavouritesRepository repository;

  GetFavouritesUseCase(this.repository);

  Future<FavouritesEntity> call() async {
    return await repository.getFavourites();
  }
}
