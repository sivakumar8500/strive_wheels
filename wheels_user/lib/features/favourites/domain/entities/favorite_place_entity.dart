class FavoritePlaceEntity {
  final String id;
  final String title;
  final String address;
  final String iconType; // 'home', 'office', 'airport', 'metro'
  final double? latitude;
  final double? longitude;
  final String locationType; // 'SELF' or 'CORPORATE'
  final bool isCorporate;

  const FavoritePlaceEntity({
    required this.id,
    required this.title,
    required this.address,
    required this.iconType,
    this.latitude,
    this.longitude,
    this.locationType = 'SELF',
    this.isCorporate = false,
  });
}

