import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/favourites_entity.dart';
import 'favorite_place_model.dart';

part 'favourites_model.freezed.dart';
part 'favourites_model.g.dart';

@freezed
abstract class FavouritesModel with _$FavouritesModel {
  const factory FavouritesModel({
    required String shortcutTitle,
    required String shortcutSubtitle,
    required List<FavoritePlaceModel> places,
  }) = _FavouritesModel;

  factory FavouritesModel.fromJson(Map<String, dynamic> json) =>
      _$FavouritesModelFromJson(json);
}

extension FavouritesModelX on FavouritesModel {
  FavouritesEntity toEntity() => FavouritesEntity(
        shortcutTitle: shortcutTitle,
        shortcutSubtitle: shortcutSubtitle,
        places: places.map((e) => e.toEntity()).toList(),
      );
}
