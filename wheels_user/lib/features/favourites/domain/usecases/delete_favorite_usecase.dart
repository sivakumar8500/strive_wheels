import '../repositories/favourites_repository.dart';

class DeleteFavoriteUseCase {
  final FavouritesRepository repository;

  DeleteFavoriteUseCase(this.repository);

  Future<void> call(String id) async {
    return await repository.deleteFavorite(id);
  }
}
