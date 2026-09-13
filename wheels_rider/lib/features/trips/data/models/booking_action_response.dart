import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking_action_response.freezed.dart';

@freezed
abstract class BookingActionResponse with _$BookingActionResponse {
  const factory BookingActionResponse({
    required bool success,
    required BookingActionData data,
  }) = _BookingActionResponse;

  factory BookingActionResponse.fromJson(Map<String, dynamic> json) {
    final bool isSuccess = (json['success'] as bool?) ?? true;
    Map<String, dynamic> dataMap = {};
    if (json['data'] is Map<String, dynamic>) {
      dataMap = json['data'] as Map<String, dynamic>;
    } else {
      dataMap = json;
    }
    return BookingActionResponse(
      success: isSuccess,
      data: BookingActionData.fromJson(dataMap),
    );
  }
}

@freezed
abstract class BookingActionData with _$BookingActionData {
  const factory BookingActionData({
    required int id,
    required String status,
    @JsonKey(name: 'final_fare') double? finalFare,
  }) = _BookingActionData;

  factory BookingActionData.fromJson(Map<String, dynamic> json) {
    return BookingActionData(
      id: (json['id'] as int?) ?? (json['booking_id'] as int?) ?? 0,
      status: (json['status'] as String?) ?? 'STARTED',
      finalFare: (json['final_fare'] as num?)?.toDouble() ?? (json['estimated_fare'] as num?)?.toDouble(),
    );
  }
}
