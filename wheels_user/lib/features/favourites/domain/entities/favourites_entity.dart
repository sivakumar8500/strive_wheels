import 'favorite_place_entity.dart';

class FavouritesEntity {
  final String shortcutTitle;
  final String shortcutSubtitle;
  final List<FavoritePlaceEntity> places;

  const FavouritesEntity({
    required this.shortcutTitle,
    required this.shortcutSubtitle,
    required this.places,
  });
}
