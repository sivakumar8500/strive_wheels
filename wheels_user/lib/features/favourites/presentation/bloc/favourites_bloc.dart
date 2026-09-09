import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/favorite_place_entity.dart';
import '../../domain/usecases/add_favorite_usecase.dart';
import '../../domain/usecases/delete_favorite_usecase.dart';
import '../../domain/usecases/get_favourites_usecase.dart';
import '../../domain/usecases/update_favorite_usecase.dart';
import 'favourites_event.dart';
import 'favourites_state.dart';

class FavouritesBloc extends Bloc<FavouritesEvent, FavouritesState> {
  final GetFavouritesUseCase getFavouritesUseCase;
  final AddFavoriteUseCase addFavoriteUseCase;
  final UpdateFavoriteUseCase updateFavoriteUseCase;
  final DeleteFavoriteUseCase deleteFavoriteUseCase;

  FavouritesBloc({
    required this.getFavouritesUseCase,
    required this.addFavoriteUseCase,
    required this.updateFavoriteUseCase,
    required this.deleteFavoriteUseCase,
  }) : super(const FavouritesState(isLoading: true)) {
    on<LoadFavouritesEvent>(_onLoadFavourites);
    on<RideHereEvent>(_onRideHere);
    on<SaveAnotherPlaceEvent>(_onSaveAnotherPlace);
    on<AddFavoriteEvent>(_onAddFavorite);
    on<UpdateFavoriteEvent>(_onUpdateFavorite);
    on<DeleteFavoriteEvent>(_onDeleteFavorite);
  }

  Future<void> _onLoadFavourites(
    LoadFavouritesEvent event,
    Emitter<FavouritesState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final entity = await getFavouritesUseCase();
      emit(state.copyWith(
        isLoading: false,
        favouritesEntity: entity,
      ));
    } catch (e) {
      print('====== LOAD FAVOURITES ERROR: $e ======');
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load saved places',
      ));
    }
  }

  void _onRideHere(
    RideHereEvent event,
    Emitter<FavouritesState> emit,
  ) {
    emit(state.copyWith(
      rideMessage: 'Setting destination to ${event.placeTitle}...',
    ));
  }

  void _onSaveAnotherPlace(
    SaveAnotherPlaceEvent event,
    Emitter<FavouritesState> emit,
  ) {
    emit(state.copyWith(
      actionMessage: 'Opening search to save new place...',
    ));
  }

  Future<void> _onAddFavorite(
    AddFavoriteEvent event,
    Emitter<FavouritesState> emit,
  ) async {
    try {
      await addFavoriteUseCase(FavoritePlaceEntity(
        id: '', // Backend should generate this
        title: event.title,
        address: event.address,
        iconType: event.iconType,
        latitude: event.latitude,
        longitude: event.longitude,
      ));
      emit(state.copyWith(actionMessage: 'Location saved successfully!'));
      add(const LoadFavouritesEvent()); // Refresh list
    } catch (e) {
      print('====== ADD FAVORITE ERROR: $e ======');
      emit(state.copyWith(errorMessage: 'Failed to save location'));
    }
  }

  Future<void> _onUpdateFavorite(
    UpdateFavoriteEvent event,
    Emitter<FavouritesState> emit,
  ) async {
    try {
      await updateFavoriteUseCase(FavoritePlaceEntity(
        id: event.id,
        title: event.title,
        address: event.address,
        iconType: event.iconType,
      ));
      emit(state.copyWith(actionMessage: 'Location updated successfully!'));
      add(const LoadFavouritesEvent()); // Refresh list
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Failed to update location'));
    }
  }

  Future<void> _onDeleteFavorite(
    DeleteFavoriteEvent event,
    Emitter<FavouritesState> emit,
  ) async {
    try {
      await deleteFavoriteUseCase(event.id);
      emit(state.copyWith(actionMessage: 'Location deleted successfully!'));
      add(const LoadFavouritesEvent()); // Refresh list
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Failed to delete location'));
    }
  }
}
