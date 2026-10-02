/// Entity representing an individual past ride record.
class PastRideItemEntity {
  final String id;
  final String title;
  final String dateAndVehicle;
  final String status;
  final String amount;
  final String serviceType; // 'Bike', 'Mini', 'Auto', 'Deliveries', etc.
  final String serviceMode; // 'SELF', 'CORPORATE'
  final String pickupAddress;
  final String dropAddress;
  final double? pickupLat;
  final double? pickupLng;
  final double? dropLat;
  final double? dropLng;

  const PastRideItemEntity({
    required this.id,
    required this.title,
    required this.dateAndVehicle,
    required this.status,
    required this.amount,
    required this.serviceType,
    this.serviceMode = 'SELF',
    this.pickupAddress = '',
    this.dropAddress = '',
    this.pickupLat,
    this.pickupLng,
    this.dropLat,
    this.dropLng,
  });

  bool get isCorporate =>
      serviceMode.toUpperCase() == 'CORPORATE' ||
      serviceMode.toUpperCase() == 'COMPANY';

  String get effectivePickupAddress {
    if (pickupAddress.trim().isNotEmpty) return pickupAddress.trim();
    if (title.contains('➔')) return title.split('➔').first.trim();
    if (title.contains('→')) return title.split('→').first.trim();
    if (title.contains('->')) return title.split('->').first.trim();
    return 'Mindspace, Hitech City, Hyderabad';
  }

  String get effectiveDropAddress {
    if (dropAddress.trim().isNotEmpty) return dropAddress.trim();
    if (title.contains('➔')) return title.split('➔').last.trim();
    if (title.contains('→')) return title.split('→').last.trim();
    if (title.contains('->')) return title.split('->').last.trim();
    return title.trim().isNotEmpty ? title.trim() : 'Destination Location';
  }
}
