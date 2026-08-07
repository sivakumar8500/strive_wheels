import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/trip_overview_entity.dart';

part 'trip_overview_model.freezed.dart';
part 'trip_overview_model.g.dart';

@freezed
abstract class TripOverviewModel with _$TripOverviewModel {
  const factory TripOverviewModel({
    required String pickupLocation,
    required String destination,
    required String tripType,
    required String distanceText,
    required String vehicleName,
    required String vehicleSeats,
    required String vehicleLuggage,
    required String vehicleAmenity,
    required String vehicleImagePath,
    required double walletBalance,
    required double baseFare,
    required double distanceCharge,
    required double serviceSurcharge,
    required double taxesFees,
    required double grandTotal,
    required String currency,
  }) = _TripOverviewModel;

  factory TripOverviewModel.fromJson(Map<String, dynamic> json) =>
      _$TripOverviewModelFromJson(json);
}

extension TripOverviewModelX on TripOverviewModel {
  TripOverviewEntity toEntity() => TripOverviewEntity(
        pickupLocation: pickupLocation,
        destination: destination,
        tripType: tripType,
        distanceText: distanceText,
        vehicleName: vehicleName,
        vehicleSeats: vehicleSeats,
        vehicleLuggage: vehicleLuggage,
        vehicleAmenity: vehicleAmenity,
        vehicleImagePath: vehicleImagePath,
        walletBalance: walletBalance,
        baseFare: baseFare,
        distanceCharge: distanceCharge,
        serviceSurcharge: serviceSurcharge,
        taxesFees: taxesFees,
        grandTotal: grandTotal,
        currency: currency,
      );
}
