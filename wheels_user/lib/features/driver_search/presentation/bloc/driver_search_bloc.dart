import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_driver_search_usecase.dart';
import 'driver_search_event.dart';
import 'driver_search_state.dart';

class DriverSearchBloc extends Bloc<DriverSearchEvent, DriverSearchState> {
  final GetDriverSearchUseCase getDriverSearchUseCase;

  DriverSearchBloc({required this.getDriverSearchUseCase})
      : super(const DriverSearchState(isLoading: true)) {
    on<LoadDriverSearchEvent>(_onLoadDriverSearch);
    on<CancelDriverSearchEvent>(_onCancelDriverSearch);
  }

  Future<void> _onLoadDriverSearch(
    LoadDriverSearchEvent event,
    Emitter<DriverSearchState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final details = await getDriverSearchUseCase();
      emit(state.copyWith(
        isLoading: false,
        driverSearch: details,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load driver search status',
      ));
    }
  }

  void _onCancelDriverSearch(
    CancelDriverSearchEvent event,
    Emitter<DriverSearchState> emit,
  ) {
    emit(state.copyWith(isCancelled: true));
  }
}
