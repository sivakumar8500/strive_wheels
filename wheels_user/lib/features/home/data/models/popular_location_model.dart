import 'package:freezed_annotation/freezed_annotation.dart';

part 'popular_location_model.freezed.dart';
part 'popular_location_model.g.dart';

@freezed
abstract class PopularLocationModel with _$PopularLocationModel {
  const factory PopularLocationModel({
    required int id,
    @JsonKey(name: 'name') required String title,
    required String address,
    @JsonKey(name: 'category') required String type,
  }) = _PopularLocationModel;

  factory PopularLocationModel.fromJson(Map<String, dynamic> json) =>
      _$PopularLocationModelFromJson(json);
}
