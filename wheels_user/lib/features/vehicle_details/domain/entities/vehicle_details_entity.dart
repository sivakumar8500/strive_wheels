class VehicleDetailsEntity {
  final String id;
  final String vehicleName;
  final String operatorName;
  final bool isEcoFriendly;
  final bool isTopRated;
  final String capacity;
  final String luggage;
  final String amenities;
  final String climate;
  final String driverName;
  final String driverRating;
  final String driverTrips;
  final String driverBio;
  final String estimatedDuration;
  final String pickupLocation;
  final String dropoffLocation;
  final String price;
  final String imagePath;

  const VehicleDetailsEntity({
    required this.id,
    required this.vehicleName,
    required this.operatorName,
    required this.isEcoFriendly,
    required this.isTopRated,
    required this.capacity,
    required this.luggage,
    required this.amenities,
    required this.climate,
    required this.driverName,
    required this.driverRating,
    required this.driverTrips,
    required this.driverBio,
    required this.estimatedDuration,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.price,
    required this.imagePath,
  });
}
