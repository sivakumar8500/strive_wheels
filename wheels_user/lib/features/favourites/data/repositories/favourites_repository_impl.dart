import '../../domain/entities/favorite_place_entity.dart';
import '../../domain/entities/favourites_entity.dart';
import '../../domain/repositories/favourites_repository.dart';
import '../datasources/favourites_remote_data_source.dart';
import '../models/favorite_place_model.dart';
import '../models/favourites_model.dart';

class FavouritesRepositoryImpl implements FavouritesRepository {
  final FavouritesRemoteDataSource remoteDataSource;

  FavouritesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<FavouritesEntity> getFavourites() async {
    final model = await remoteDataSource.getFavouritesData();
    return model.toEntity();
  }

  @override
  Future<void> addFavorite(FavoritePlaceEntity place) async {
    await remoteDataSource.addFavorite(place.toModel());
  }

  @override
  Future<void> updateFavorite(FavoritePlaceEntity place) async {
    await remoteDataSource.updateFavorite(place.toModel());
  }

  @override
  Future<void> deleteFavorite(String id) async {
    await remoteDataSource.deleteFavorite(id);
  }
}
