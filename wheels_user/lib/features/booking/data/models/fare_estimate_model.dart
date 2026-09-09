import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/fare_estimate_entity.dart';

part 'fare_estimate_model.freezed.dart';
part 'fare_estimate_model.g.dart';

@freezed
abstract class FareEstimateModel with _$FareEstimateModel {
  const factory FareEstimateModel({
    @JsonKey(name: 'service_mode') @Default('NORMAL') String serviceMode,
    @JsonKey(name: 'vehicle_type_id') @Default(1) int vehicleTypeId,
    @JsonKey(name: 'estimated_distance_km') @Default(0.0) double estimatedDistanceKm,
    @JsonKey(name: 'estimated_duration_mins') @Default(0) int estimatedDurationMins,
    @JsonKey(name: 'base_fare') @Default(0.0) double baseFare,
    @JsonKey(name: 'distance_charge') @Default(0.0) double distanceCharge,
    @JsonKey(name: 'time_charge') @Default(0.0) double timeCharge,
    @JsonKey(name: 'waiting_charge') @Default(0.0) double waitingCharge,
    @JsonKey(name: 'discount_amount') @Default(0.0) double discountAmount,
    @JsonKey(name: 'surge_multiplier') @Default(1.0) double surgeMultiplier,
    @JsonKey(name: 'estimated_fare') @Default(0.0) double estimatedFare,
  }) = _FareEstimateModel;

  factory FareEstimateModel.fromJson(Map<String, dynamic> json) =>
      _$FareEstimateModelFromJson(json);
}

extension FareEstimateModelX on FareEstimateModel {
  FareEstimateEntity toEntity() => FareEstimateEntity(
        serviceMode: serviceMode,
        vehicleTypeId: vehicleTypeId,
        estimatedDistanceKm: estimatedDistanceKm,
        estimatedDurationMins: estimatedDurationMins,
        baseFare: baseFare,
        distanceCharge: distanceCharge,
        timeCharge: timeCharge,
        waitingCharge: waitingCharge,
        discountAmount: discountAmount,
        surgeMultiplier: surgeMultiplier,
        estimatedFare: estimatedFare,
      );
}
