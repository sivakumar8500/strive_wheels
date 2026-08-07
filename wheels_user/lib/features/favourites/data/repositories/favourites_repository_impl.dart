import '../../domain/entities/favourites_entity.dart';
import '../../domain/repositories/favourites_repository.dart';
import '../datasources/favourites_local_datasource.dart';
import '../models/favourites_model.dart';

class FavouritesRepositoryImpl implements FavouritesRepository {
  final FavouritesLocalDataSource localDataSource;

  FavouritesRepositoryImpl({required this.localDataSource});

  @override
  Future<FavouritesEntity> getFavourites() async {
    final model = await localDataSource.getFavouritesData();
    return model.toEntity();
  }
}
