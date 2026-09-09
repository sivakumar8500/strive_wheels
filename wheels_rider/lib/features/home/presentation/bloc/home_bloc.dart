import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/update_location_usecase.dart';
import '../../domain/usecases/update_availability_usecase.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final UpdateLocationUseCase updateLocationUseCase;
  final UpdateAvailabilityUseCase updateAvailabilityUseCase;

  HomeBloc({
    required this.updateLocationUseCase,
    required this.updateAvailabilityUseCase,
  }) : super(const HomeState.initial()) {
    on<HomeEvent>((event, emit) async {
      await event.map(
        updateLocation: (e) async {
          emit(const HomeState.loading());
          try {
            await updateLocationUseCase(e.lat, e.lng);
            emit(const HomeState.success());
          } catch (error) {
            emit(HomeState.failure(error.toString()));
          }
        },
        updateAvailability: (e) async {
          emit(const HomeState.loading());
          try {
            await updateAvailabilityUseCase(
              availabilityMode: e.availabilityMode,
              isOnline: e.isOnline,
              selectedDates: e.selectedDates,
            );
            emit(const HomeState.success());
          } catch (error) {
            emit(HomeState.failure(error.toString()));
          }
        },
      );
    });
  }
}
