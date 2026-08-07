import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_vehicle_details_usecase.dart';
import 'vehicle_details_event.dart';
import 'vehicle_details_state.dart';

class VehicleDetailsBloc
    extends Bloc<VehicleDetailsEvent, VehicleDetailsState> {
  final GetVehicleDetailsUseCase getVehicleDetailsUseCase;

  VehicleDetailsBloc({required this.getVehicleDetailsUseCase})
      : super(const VehicleDetailsState(isLoading: true)) {
    on<LoadVehicleDetailsEvent>(_onLoadVehicleDetails);
    on<ConfirmVehicleBookingEvent>(_onConfirmVehicleBooking);
  }

  Future<void> _onLoadVehicleDetails(
    LoadVehicleDetailsEvent event,
    Emitter<VehicleDetailsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final details = await getVehicleDetailsUseCase(event.vehicleId);
      emit(state.copyWith(
        isLoading: false,
        vehicleDetails: details,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load vehicle details',
      ));
    }
  }

  void _onConfirmVehicleBooking(
    ConfirmVehicleBookingEvent event,
    Emitter<VehicleDetailsState> emit,
  ) {
    final vehicleName =
        state.vehicleDetails?.vehicleName ?? 'Range Rover Autobiography';
    emit(state.copyWith(
      isBookingConfirmed: true,
      actionMessage: 'Booking for $vehicleName confirmed successfully!',
    ));
  }
}
