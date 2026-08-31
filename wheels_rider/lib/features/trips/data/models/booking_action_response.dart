import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking_action_response.freezed.dart';
part 'booking_action_response.g.dart';

@freezed
abstract class BookingActionResponse with _$BookingActionResponse {
  const factory BookingActionResponse({
    required bool success,
    required BookingActionData data,
  }) = _BookingActionResponse;

  factory BookingActionResponse.fromJson(Map<String, dynamic> json) => _$BookingActionResponseFromJson(json);
}

@freezed
abstract class BookingActionData with _$BookingActionData {
  const factory BookingActionData({
    required int id,
    required String status,
    @JsonKey(name: 'final_fare') double? finalFare,
  }) = _BookingActionData;

  factory BookingActionData.fromJson(Map<String, dynamic> json) => _$BookingActionDataFromJson(json);
}
