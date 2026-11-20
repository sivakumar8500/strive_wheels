import 'package:freezed_annotation/freezed_annotation.dart';

part 'ride_request_entity.freezed.dart';

@freezed
abstract class RideRequestEntity with _$RideRequestEntity {
  const factory RideRequestEntity({
    required int id,
    required String pickupAddress,
    required String dropAddress,
    required double estimatedFare,
    required double pickupLat,
    required double pickupLng,
    required double dropLat,
    required double dropLng,
  }) = _RideRequestEntity;
}
