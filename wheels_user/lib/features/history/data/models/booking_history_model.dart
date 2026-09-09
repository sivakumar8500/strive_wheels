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

  factory BookingHistoryModel.fromApiJson(Map<String, dynamic> json) {
    final idVal = json['id']?.toString() ?? json['_id']?.toString() ?? '101';
    final pickup = json['pickup_address']?.toString() ?? '';
    final drop = json['drop_address']?.toString() ?? '';
    final titleVal = json['title']?.toString() ??
        (pickup.isNotEmpty && drop.isNotEmpty
            ? '$pickup → $drop'
            : (pickup.isNotEmpty ? pickup : 'Ride #$idVal'));
    final dateVal = json['created_at']?.toString() ??
        json['dateAndVehicle']?.toString() ??
        'Recent';
    final fareVal = json['estimated_fare'] != null
        ? '₹${json['estimated_fare']}'
        : (json['amount']?.toString() ?? '₹0.00');
    final statusVal = json['status']?.toString() ?? 'Completed';
    final serviceVal = json['service_mode']?.toString() ??
        json['booking_mode']?.toString() ??
        json['serviceType']?.toString() ??
        'Instant Ride';

    return BookingHistoryModel(
      id: idVal,
      title: titleVal,
      dateAndVehicle: dateVal,
      status: statusVal,
      amount: fareVal,
      serviceType: serviceVal,
    );
  }
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
