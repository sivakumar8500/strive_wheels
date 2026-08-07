// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_overview_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TripOverviewModel _$TripOverviewModelFromJson(Map<String, dynamic> json) =>
    _TripOverviewModel(
      pickupLocation: json['pickupLocation'] as String,
      destination: json['destination'] as String,
      tripType: json['tripType'] as String,
      distanceText: json['distanceText'] as String,
      vehicleName: json['vehicleName'] as String,
      vehicleSeats: json['vehicleSeats'] as String,
      vehicleLuggage: json['vehicleLuggage'] as String,
      vehicleAmenity: json['vehicleAmenity'] as String,
      vehicleImagePath: json['vehicleImagePath'] as String,
      walletBalance: (json['walletBalance'] as num).toDouble(),
      baseFare: (json['baseFare'] as num).toDouble(),
      distanceCharge: (json['distanceCharge'] as num).toDouble(),
      serviceSurcharge: (json['serviceSurcharge'] as num).toDouble(),
      taxesFees: (json['taxesFees'] as num).toDouble(),
      grandTotal: (json['grandTotal'] as num).toDouble(),
      currency: json['currency'] as String,
    );

Map<String, dynamic> _$TripOverviewModelToJson(_TripOverviewModel instance) =>
    <String, dynamic>{
      'pickupLocation': instance.pickupLocation,
      'destination': instance.destination,
      'tripType': instance.tripType,
      'distanceText': instance.distanceText,
      'vehicleName': instance.vehicleName,
      'vehicleSeats': instance.vehicleSeats,
      'vehicleLuggage': instance.vehicleLuggage,
      'vehicleAmenity': instance.vehicleAmenity,
      'vehicleImagePath': instance.vehicleImagePath,
      'walletBalance': instance.walletBalance,
      'baseFare': instance.baseFare,
      'distanceCharge': instance.distanceCharge,
      'serviceSurcharge': instance.serviceSurcharge,
      'taxesFees': instance.taxesFees,
      'grandTotal': instance.grandTotal,
      'currency': instance.currency,
    };
