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
