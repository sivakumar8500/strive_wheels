import '../../domain/entities/favourites_entity.dart';

class FavouritesState {
  final bool isLoading;
  final FavouritesEntity? favouritesEntity;
  final String? rideMessage;
  final String? actionMessage;
  final String? errorMessage;

  const FavouritesState({
    this.isLoading = false,
    this.favouritesEntity,
    this.rideMessage,
    this.actionMessage,
    this.errorMessage,
  });

  FavouritesState copyWith({
    bool? isLoading,
    FavouritesEntity? favouritesEntity,
    String? rideMessage,
    String? actionMessage,
    String? errorMessage,
  }) {
    return FavouritesState(
      isLoading: isLoading ?? this.isLoading,
      favouritesEntity: favouritesEntity ?? this.favouritesEntity,
      rideMessage: rideMessage,
      actionMessage: actionMessage,
      errorMessage: errorMessage,
    );
  }
}
