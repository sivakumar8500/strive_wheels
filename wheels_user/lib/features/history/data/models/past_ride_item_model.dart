import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/past_ride_item_entity.dart';

part 'past_ride_item_model.freezed.dart';
part 'past_ride_item_model.g.dart';

@freezed
abstract class PastRideItemModel with _$PastRideItemModel {
  const factory PastRideItemModel({
    required String id,
    required String title,
    required String dateAndVehicle,
    required String status,
    required String amount,
    required String serviceType,
  }) = _PastRideItemModel;

  factory PastRideItemModel.fromJson(Map<String, dynamic> json) =>
      _$PastRideItemModelFromJson(json);
}

extension PastRideItemModelX on PastRideItemModel {
  PastRideItemEntity toEntity() => PastRideItemEntity(
        id: id,
        title: title,
        dateAndVehicle: dateAndVehicle,
        status: status,
        amount: amount,
        serviceType: serviceType,
      );
}
