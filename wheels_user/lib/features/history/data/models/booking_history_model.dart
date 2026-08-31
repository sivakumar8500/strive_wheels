import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/past_ride_item_entity.dart';

part 'booking_history_model.freezed.dart';
part 'booking_history_model.g.dart';

@freezed
abstract class BookingHistoryModel with _$BookingHistoryModel {
  const factory BookingHistoryModel({
    @JsonKey(name: '_id') required String id,
    required String title,
    required String dateAndVehicle,
    required String status,
    required String amount,
    required String serviceType,
  }) = _BookingHistoryModel;

  factory BookingHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$BookingHistoryModelFromJson(json);
}

extension BookingHistoryModelX on BookingHistoryModel {
  PastRideItemEntity toEntity() => PastRideItemEntity(
        id: id,
        title: title,
        dateAndVehicle: dateAndVehicle,
        status: status,
        amount: amount,
        serviceType: serviceType,
      );
}
