import 'package:freezed_annotation/freezed_annotation.dart';

part 'availability_schedule_state.freezed.dart';

@freezed
abstract class AvailabilityScheduleState with _$AvailabilityScheduleState {
  const factory AvailabilityScheduleState.initial() = _Initial;
  const factory AvailabilityScheduleState.loading() = _Loading;
  const factory AvailabilityScheduleState.loaded(List<DateTime> dates) = _Loaded;
  const factory AvailabilityScheduleState.failure(String message) = _Failure;
}
