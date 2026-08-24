import 'package:freezed_annotation/freezed_annotation.dart';

part 'availability_response.freezed.dart';
part 'availability_response.g.dart';

@freezed
abstract class AvailabilityResponse with _$AvailabilityResponse {
  const factory AvailabilityResponse({
    required bool success,
    required AvailabilityData data,
  }) = _AvailabilityResponse;

  factory AvailabilityResponse.fromJson(Map<String, dynamic> json) => _$AvailabilityResponseFromJson(json);
}

@freezed
abstract class AvailabilityData with _$AvailabilityData {
  const factory AvailabilityData({
    @JsonKey(name: 'availability_mode') required String availabilityMode,
    @JsonKey(name: 'is_online') required bool isOnline,
  }) = _AvailabilityData;

  factory AvailabilityData.fromJson(Map<String, dynamic> json) => _$AvailabilityDataFromJson(json);
}
