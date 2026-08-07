import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/ride_history_entity.dart';
import 'past_ride_item_model.dart';

part 'ride_history_model.freezed.dart';
part 'ride_history_model.g.dart';

@freezed
abstract class RideHistoryModel with _$RideHistoryModel {
  const factory RideHistoryModel({
    required String monthlySummaryTitle,
    required String tripCountText,
    required String distanceText,
    required String spentText,
    required List<PastRideItemModel> pastRides,
  }) = _RideHistoryModel;

  factory RideHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$RideHistoryModelFromJson(json);
}

extension RideHistoryModelX on RideHistoryModel {
  RideHistoryEntity toEntity() => RideHistoryEntity(
        monthlySummaryTitle: monthlySummaryTitle,
        tripCountText: tripCountText,
        distanceText: distanceText,
        spentText: spentText,
        pastRides: pastRides.map((e) => e.toEntity()).toList(),
      );
}
