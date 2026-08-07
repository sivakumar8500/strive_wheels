import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_schedule_ride_usecase.dart';
import 'schedule_ride_event.dart';
import 'schedule_ride_state.dart';

class ScheduleRideBloc extends Bloc<ScheduleRideEvent, ScheduleRideState> {
  final GetScheduleRideUseCase getScheduleRideUseCase;

  ScheduleRideBloc({required this.getScheduleRideUseCase})
      : super(const ScheduleRideState(isLoading: true)) {
    on<LoadScheduleRideEvent>(_onLoadScheduleRide);
    on<SelectScheduleDateEvent>(_onSelectScheduleDate);
    on<ToggleAmPmEvent>(_onToggleAmPm);
    on<ToggleInstantNotificationEvent>(_onToggleInstantNotification);
    on<ConfirmScheduleEvent>(_onConfirmSchedule);
  }

  Future<void> _onLoadScheduleRide(
    LoadScheduleRideEvent event,
    Emitter<ScheduleRideState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final details = await getScheduleRideUseCase();
      emit(state.copyWith(
        isLoading: false,
        rideDetails: details,
        selectedDate: details.selectedDate,
        isAm: details.isAm,
        instantNotification: details.instantNotification,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load schedule ride details',
      ));
    }
  }

  void _onSelectScheduleDate(
    SelectScheduleDateEvent event,
    Emitter<ScheduleRideState> emit,
  ) {
    emit(state.copyWith(selectedDate: event.date));
  }

  void _onToggleAmPm(
    ToggleAmPmEvent event,
    Emitter<ScheduleRideState> emit,
  ) {
    emit(state.copyWith(isAm: event.isAm));
  }

  void _onToggleInstantNotification(
    ToggleInstantNotificationEvent event,
    Emitter<ScheduleRideState> emit,
  ) {
    emit(state.copyWith(instantNotification: event.value));
  }

  void _onConfirmSchedule(
    ConfirmScheduleEvent event,
    Emitter<ScheduleRideState> emit,
  ) {
    emit(state.copyWith(isConfirmed: true));
  }
}
