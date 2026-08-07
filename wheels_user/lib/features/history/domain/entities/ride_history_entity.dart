import 'past_ride_item_entity.dart';

/// Entity representing Ride History summary and past ride list.
class RideHistoryEntity {
  final String monthlySummaryTitle;
  final String tripCountText;
  final String distanceText;
  final String spentText;
  final List<PastRideItemEntity> pastRides;

  const RideHistoryEntity({
    required this.monthlySummaryTitle,
    required this.tripCountText,
    required this.distanceText,
    required this.spentText,
    required this.pastRides,
  });
}
