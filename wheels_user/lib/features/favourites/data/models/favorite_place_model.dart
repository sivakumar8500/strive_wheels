import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/favorite_place_entity.dart';

part 'favorite_place_model.freezed.dart';
part 'favorite_place_model.g.dart';

@freezed
abstract class FavoritePlaceModel with _$FavoritePlaceModel {
  const factory FavoritePlaceModel({
    @JsonKey(readValue: _readId) required int id,
    @JsonKey(defaultValue: 'Unknown') required String title,
    @JsonKey(defaultValue: '') required String address,
    double? latitude,
    double? longitude,
    @JsonKey(name: 'location_type', defaultValue: 'SELF') @Default('SELF') String locationType,
    @JsonKey(name: 'is_corporate', defaultValue: false) @Default(false) bool isCorporate,
  }) = _FavoritePlaceModel;

  factory FavoritePlaceModel.fromJson(Map<String, dynamic> json) =>
      _$FavoritePlaceModelFromJson(json);
}

Object? _readId(Map<dynamic, dynamic> json, String key) {
  final val = json[key];
  if (val is int) return val;
  if (val is String) return int.tryParse(val) ?? 0;
  return 0;
}

extension FavoritePlaceModelX on FavoritePlaceModel {
  FavoritePlaceEntity toEntity() {
    String resolvedIcon = 'home';
    final t = title.toLowerCase();
    if (t.contains('work') || t.contains('office') || isCorporate || locationType.toUpperCase() == 'CORPORATE') {
      resolvedIcon = 'office';
    } else if (t.contains('airport')) {
      resolvedIcon = 'airport';
    } else if (t.contains('metro') || t.contains('station')) {
      resolvedIcon = 'metro';
    }
    return FavoritePlaceEntity(
      id: id.toString(),
      title: title,
      address: address,
      iconType: resolvedIcon,
      latitude: latitude,
      longitude: longitude,
      locationType: locationType,
      isCorporate: isCorporate || locationType.toUpperCase() == 'CORPORATE',
    );
  }
}

extension FavoritePlaceEntityX on FavoritePlaceEntity {
  FavoritePlaceModel toModel() => FavoritePlaceModel(
        id: int.tryParse(id) ?? 0,
        title: title,
        address: address,
        latitude: latitude,
        longitude: longitude,
        locationType: locationType,
        isCorporate: isCorporate,
      );
}
