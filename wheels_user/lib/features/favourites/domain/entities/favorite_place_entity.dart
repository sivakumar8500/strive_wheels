class FavoritePlaceEntity {
  final String id;
  final String title;
  final String address;
  final String iconType; // 'home', 'office', 'airport', 'metro'

  const FavoritePlaceEntity({
    required this.id,
    required this.title,
    required this.address,
    required this.iconType,
  });
}
