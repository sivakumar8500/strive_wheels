import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/favorite_place_entity.dart';

part 'favorite_place_model.freezed.dart';
part 'favorite_place_model.g.dart';

@freezed
abstract class FavoritePlaceModel with _$FavoritePlaceModel {
  const factory FavoritePlaceModel({
    required String id,
    required String title,
    required String address,
    required String iconType,
  }) = _FavoritePlaceModel;

  factory FavoritePlaceModel.fromJson(Map<String, dynamic> json) =>
      _$FavoritePlaceModelFromJson(json);
}

extension FavoritePlaceModelX on FavoritePlaceModel {
  FavoritePlaceEntity toEntity() => FavoritePlaceEntity(
        id: id,
        title: title,
        address: address,
        iconType: iconType,
      );
}
