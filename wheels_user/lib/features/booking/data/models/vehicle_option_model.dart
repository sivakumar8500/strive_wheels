import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/vehicle_option_entity.dart';

part 'vehicle_option_model.freezed.dart';
part 'vehicle_option_model.g.dart';

@freezed
abstract class VehicleOptionModel with _$VehicleOptionModel {
  const factory VehicleOptionModel({
    required String id,
    required String name,
    required String specs,
    required String price,
    required String rating,
    required String eta,
    required String imagePath,
  }) = _VehicleOptionModel;

  factory VehicleOptionModel.fromJson(Map<String, dynamic> json) =>
      _$VehicleOptionModelFromJson(json);
}

extension VehicleOptionModelX on VehicleOptionModel {
  VehicleOptionEntity toEntity() => VehicleOptionEntity(
        id: id,
        name: name,
        specs: specs,
        price: price,
        rating: rating,
        eta: eta,
        imagePath: imagePath,
      );
}
