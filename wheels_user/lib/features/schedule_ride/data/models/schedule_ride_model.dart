import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/schedule_ride_entity.dart';

part 'schedule_ride_model.freezed.dart';
part 'schedule_ride_model.g.dart';

@freezed
abstract class ScheduleRideModel with _$ScheduleRideModel {
  const factory ScheduleRideModel({
    required String pickupPoint,
    required String destination,
    required double distanceKm,
    required int durationMins,
    required double fareAmount,
    required String currencySymbol,
    required String selectedDate,
    required String selectedTime,
    required bool isAm,
    required bool instantNotification,
    required List<String> checklistItems,
  }) = _ScheduleRideModel;

  factory ScheduleRideModel.fromJson(Map<String, dynamic> json) =>
      _$ScheduleRideModelFromJson(json);
}

extension ScheduleRideModelX on ScheduleRideModel {
  ScheduleRideEntity toEntity() => ScheduleRideEntity(
        pickupPoint: pickupPoint,
        destination: destination,
        distanceKm: distanceKm,
        durationMins: durationMins,
        fareAmount: fareAmount,
        currencySymbol: currencySymbol,
        selectedDate: selectedDate,
        selectedTime: selectedTime,
        isAm: isAm,
        instantNotification: instantNotification,
        checklistItems: checklistItems,
      );
}
