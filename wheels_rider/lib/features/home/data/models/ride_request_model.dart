import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/ride_request_entity.dart';

part 'ride_request_model.freezed.dart';
part 'ride_request_model.g.dart';

@freezed
abstract class RideRequestModel with _$RideRequestModel {
  const RideRequestModel._();

  const factory RideRequestModel({
    @JsonKey(name: 'id') int? id,
    @JsonKey(name: 'booking_id') int? bookingId,
    @JsonKey(name: 'request_id') int? requestId,
    @JsonKey(name: 'pickup_address') String? pickupAddress,
    @JsonKey(name: 'drop_address') String? dropAddress,
    @JsonKey(name: 'estimated_fare') double? estimatedFare,
    @JsonKey(name: 'pickup_lat') double? pickupLat,
    @JsonKey(name: 'pickup_lng') double? pickupLng,
    @JsonKey(name: 'drop_lat') double? dropLat,
    @JsonKey(name: 'drop_lng') double? dropLng,
    @JsonKey(name: 'estimated_distance_km') double? estimatedDistanceKm,
    @JsonKey(name: 'estimated_duration_mins') int? estimatedDurationMins,
    @JsonKey(name: 'booking_code') String? bookingCode,
    @JsonKey(name: 'service_mode') String? serviceMode,
  }) = _RideRequestModel;

  factory RideRequestModel.fromJson(Map<String, dynamic> json) => _$RideRequestModelFromJson(json);

  RideRequestEntity toEntity() {
    final resolvedBookingId = bookingId ?? id ?? requestId ?? 0;
    return RideRequestEntity(
      id: resolvedBookingId,
      pickupAddress: pickupAddress ?? 'Unknown Pickup',
      dropAddress: dropAddress ?? 'Unknown Dropoff',
      estimatedFare: estimatedFare ?? 0.0,
      pickupLat: pickupLat ?? 0.0,
      pickupLng: pickupLng ?? 0.0,
      dropLat: dropLat ?? 0.0,
      dropLng: dropLng ?? 0.0,
      estimatedDistanceKm: estimatedDistanceKm,
      estimatedDurationMins: estimatedDurationMins,
      bookingCode: bookingCode,
      serviceMode: serviceMode,
    );
  }
}
