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
    @Default('SELF') String serviceMode,
    @Default('') String pickupAddress,
    @Default('') String dropAddress,
    double? pickupLat,
    double? pickupLng,
    double? dropLat,
    double? dropLng,
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

    // Parse vehicle type for icon display (Bike, Auto, Cab/Mini, etc.)
    final vehicleTypeObj = json['vehicle_type'];
    final vehicleTypeName = vehicleTypeObj is Map ? vehicleTypeObj['name']?.toString() : null;
    final serviceVal = vehicleTypeName ??
        json['vehicle_type_name']?.toString() ??
        json['service_type']?.toString() ??
        json['serviceType']?.toString() ??
        'Bike';

    // Parse service mode (Corporate vs Self)
    final rawServiceMode = json['service_mode']?.toString() ??
        json['booking_mode']?.toString() ??
        json['serviceMode']?.toString() ??
        '';
    final isCorp = rawServiceMode.toUpperCase().contains('CORP') || json['company_id'] != null;
    final serviceModeVal = isCorp ? 'CORPORATE' : 'SELF';

    double? parseDouble(dynamic v) {
      if (v == null) return null;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString());
    }

    return BookingHistoryModel(
      id: idVal,
      title: titleVal,
      dateAndVehicle: dateVal,
      status: statusVal,
      amount: fareVal,
      serviceType: serviceVal,
      serviceMode: serviceModeVal,
      pickupAddress: pickup,
      dropAddress: drop,
      pickupLat: parseDouble(json['pickup_lat']),
      pickupLng: parseDouble(json['pickup_lng']),
      dropLat: parseDouble(json['drop_lat']),
      dropLng: parseDouble(json['drop_lng']),
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
        serviceMode: serviceMode,
        pickupAddress: pickupAddress,
        dropAddress: dropAddress,
        pickupLat: pickupLat,
        pickupLng: pickupLng,
        dropLat: dropLat,
        dropLng: dropLng,
      );
}
