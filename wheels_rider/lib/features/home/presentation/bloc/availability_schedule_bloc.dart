import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_availability_schedule_usecase.dart';
import 'availability_schedule_event.dart';
import 'availability_schedule_state.dart';

class AvailabilityScheduleBloc extends Bloc<AvailabilityScheduleEvent, AvailabilityScheduleState> {
  final GetAvailabilityScheduleUseCase getAvailabilityScheduleUseCase;

  AvailabilityScheduleBloc({
    required this.getAvailabilityScheduleUseCase,
  }) : super(const AvailabilityScheduleState.initial()) {
    on<AvailabilityScheduleEvent>((event, emit) async {
      await event.map(
        fetch: (_) async {
          emit(const AvailabilityScheduleState.loading());
          try {
            final dates = await getAvailabilityScheduleUseCase();
            emit(AvailabilityScheduleState.loaded(dates));
          } catch (error) {
            emit(AvailabilityScheduleState.failure(error.toString()));
          }
        },
      );
    });
  }
}
