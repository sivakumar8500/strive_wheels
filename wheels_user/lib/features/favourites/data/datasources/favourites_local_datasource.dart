import '../../../../core/constants/app_strings.dart';
import '../models/favorite_place_model.dart';
import '../models/favourites_model.dart';

abstract class FavouritesLocalDataSource {
  Future<FavouritesModel> getFavouritesData();
}

class FavouritesLocalDataSourceImpl implements FavouritesLocalDataSource {
  const FavouritesLocalDataSourceImpl();

  @override
  Future<FavouritesModel> getFavouritesData() async {
    return const FavouritesModel(
      shortcutTitle: AppStrings.placesYouRideToMost,
      shortcutSubtitle: AppStrings.tapPlaceToUseAsDestination,
      places: [
        FavoritePlaceModel(
          id: 1,
          title: 'Home',
          address: 'Nanakramguda, Hyderabad',
        ),
        FavoritePlaceModel(
          id: 2,
          title: 'Office',
          address: 'Mindspace IT Park, Madhapur',
        ),
        FavoritePlaceModel(
          id: 3,
          title: 'Rajiv Gandhi Airport',
          address: 'Shamshabad, Hyderabad',
        ),
        FavoritePlaceModel(
          id: 4,
          title: 'Raidurg Metro',
          address: 'HITEC City, Hyderabad',
        ),
      ],
    );
  }
}
