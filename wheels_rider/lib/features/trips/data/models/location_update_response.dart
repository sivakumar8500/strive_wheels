import 'package:freezed_annotation/freezed_annotation.dart';

part 'location_update_response.freezed.dart';
part 'location_update_response.g.dart';

@freezed
abstract class LocationUpdateResponse with _$LocationUpdateResponse {
  const factory LocationUpdateResponse({
    required bool success,
    required LocationData data,
  }) = _LocationUpdateResponse;

  factory LocationUpdateResponse.fromJson(Map<String, dynamic> json) => _$LocationUpdateResponseFromJson(json);
}

@freezed
abstract class LocationData with _$LocationData {
  const factory LocationData({
    required double lat,
    required double lng,
  }) = _LocationData;

  factory LocationData.fromJson(Map<String, dynamic> json) => _$LocationDataFromJson(json);
}
