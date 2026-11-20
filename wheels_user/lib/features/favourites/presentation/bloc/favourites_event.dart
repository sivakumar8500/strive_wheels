abstract class FavouritesEvent {
  const FavouritesEvent();
}

class LoadFavouritesEvent extends FavouritesEvent {
  const LoadFavouritesEvent();
}

class RideHereEvent extends FavouritesEvent {
  final String placeId;
  final String placeTitle;

  const RideHereEvent({
    required this.placeId,
    required this.placeTitle,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RideHereEvent &&
          runtimeType == other.runtimeType &&
          placeId == other.placeId &&
          placeTitle == other.placeTitle;

  @override
  int get hashCode => placeId.hashCode ^ placeTitle.hashCode;
}

class SaveAnotherPlaceEvent extends FavouritesEvent {
  const SaveAnotherPlaceEvent();
}

class AddFavoriteEvent extends FavouritesEvent {
  final String title;
  final String address;
  final String iconType;
  final double latitude;
  final double longitude;

  const AddFavoriteEvent({
    required this.title,
    required this.address,
    required this.iconType,
    required this.latitude,
    required this.longitude,
  });
}

class UpdateFavoriteEvent extends FavouritesEvent {
  final String id;
  final String title;
  final String address;
  final String iconType;

  const UpdateFavoriteEvent({
    required this.id,
    required this.title,
    required this.address,
    required this.iconType,
  });
}

class DeleteFavoriteEvent extends FavouritesEvent {
  final String id;

  const DeleteFavoriteEvent(this.id);
}
