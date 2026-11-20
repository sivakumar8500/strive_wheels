import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_favourites_usecase.dart';
import 'favourites_event.dart';
import 'favourites_state.dart';

class FavouritesBloc extends Bloc<FavouritesEvent, FavouritesState> {
  final GetFavouritesUseCase getFavouritesUseCase;

  FavouritesBloc({
    required this.getFavouritesUseCase,
  }) : super(const FavouritesState(isLoading: true)) {
    on<LoadFavouritesEvent>(_onLoadFavourites);
    on<RideHereEvent>(_onRideHere);
    on<SaveAnotherPlaceEvent>(_onSaveAnotherPlace);
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
}
