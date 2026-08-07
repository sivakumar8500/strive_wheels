class ScheduleRideEntity {
  final String pickupPoint;
  final String destination;
  final double distanceKm;
  final int durationMins;
  final double fareAmount;
  final String currencySymbol;
  final String selectedDate;
  final String selectedTime;
  final bool isAm;
  final bool instantNotification;
  final List<String> checklistItems;

  const ScheduleRideEntity({
    required this.pickupPoint,
    required this.destination,
    required this.distanceKm,
    required this.durationMins,
    required this.fareAmount,
    required this.currencySymbol,
    required this.selectedDate,
    required this.selectedTime,
    required this.isAm,
    required this.instantNotification,
    required this.checklistItems,
  });
}
