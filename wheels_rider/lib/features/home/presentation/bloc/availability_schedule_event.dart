import 'package:freezed_annotation/freezed_annotation.dart';

part 'availability_schedule_event.freezed.dart';

@freezed
abstract class AvailabilityScheduleEvent with _$AvailabilityScheduleEvent {
  const factory AvailabilityScheduleEvent.fetch() = _Fetch;
}
