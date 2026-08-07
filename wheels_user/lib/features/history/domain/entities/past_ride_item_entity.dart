/// Entity representing an individual past ride record.
class PastRideItemEntity {
  final String id;
  final String title;
  final String dateAndVehicle;
  final String status;
  final String amount;
  final String serviceType; // 'Bike', 'Mini', 'Auto', 'Deliveries', etc.

  const PastRideItemEntity({
    required this.id,
    required this.title,
    required this.dateAndVehicle,
    required this.status,
    required this.amount,
    required this.serviceType,
  });
}
