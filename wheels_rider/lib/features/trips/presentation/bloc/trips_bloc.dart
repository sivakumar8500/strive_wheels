import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_trips_usecase.dart';
import 'trips_event.dart';
import 'trips_state.dart';

class TripsBloc extends Bloc<TripsEvent, TripsState> {
  final GetTripsUseCase getTripsUseCase;

  TripsBloc({required this.getTripsUseCase}) : super(TripsInitial()) {
    on<GetTripsEvent>(_onGetTrips);
  }

  Future<void> _onGetTrips(GetTripsEvent event, Emitter<TripsState> emit) async {
    emit(TripsLoading());
    try {
      final trips = await getTripsUseCase(event.limit, event.offset);
      emit(TripsLoaded(trips));
    } catch (e) {
      emit(TripsError(e.toString()));
    }
  }
}
