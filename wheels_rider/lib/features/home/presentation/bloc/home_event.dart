import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_event.freezed.dart';

@freezed
abstract class HomeEvent with _$HomeEvent {
  const factory HomeEvent.updateLocation({
    required double lat,
    required double lng,
  }) = _UpdateLocation;

  const factory HomeEvent.updateAvailability({
    required String availabilityMode,
    required bool isOnline,
    List<DateTime>? selectedDates,
  }) = _UpdateAvailability;
}
