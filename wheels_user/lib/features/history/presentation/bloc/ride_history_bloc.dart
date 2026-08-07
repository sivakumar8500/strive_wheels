import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_ride_history_usecase.dart';
import 'ride_history_event.dart';
import 'ride_history_state.dart';

class RideHistoryBloc extends Bloc<RideHistoryEvent, RideHistoryState> {
  final GetRideHistoryUseCase getRideHistoryUseCase;

  RideHistoryBloc({
    required this.getRideHistoryUseCase,
  }) : super(const RideHistoryState(isLoading: true)) {
    on<LoadRideHistoryEvent>(_onLoadRideHistory);
    on<FilterTripsTabEvent>(_onFilterTripsTab);
    on<BookAgainEvent>(_onBookAgain);
    on<OpenFilterOptionsEvent>(_onOpenFilterOptions);
  }

  Future<void> _onLoadRideHistory(
    LoadRideHistoryEvent event,
    Emitter<RideHistoryState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final entity = await getRideHistoryUseCase();
      emit(state.copyWith(
        isLoading: false,
        historyEntity: entity,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load ride history',
      ));
    }
  }

  void _onFilterTripsTab(
    FilterTripsTabEvent event,
    Emitter<RideHistoryState> emit,
  ) {
    emit(state.copyWith(selectedFilterIndex: event.filterIndex));
  }

  void _onBookAgain(
    BookAgainEvent event,
    Emitter<RideHistoryState> emit,
  ) {
    emit(state.copyWith(
      bookAgainMessage: 'Booking ${event.rideTitle} again...',
    ));
  }

  void _onOpenFilterOptions(
    OpenFilterOptionsEvent event,
    Emitter<RideHistoryState> emit,
  ) {
    emit(state.copyWith(
      actionMessage: 'Filter options opened',
    ));
  }
}
