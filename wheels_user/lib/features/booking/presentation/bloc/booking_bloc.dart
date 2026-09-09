import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_available_vehicles_usecase.dart';
import '../../domain/usecases/get_recent_journeys_usecase.dart';
import '../../domain/usecases/get_vehicle_types_usecase.dart';
import 'booking_event.dart';
import 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final GetRecentJourneysUseCase getRecentJourneysUseCase;
  final GetAvailableVehiclesUseCase getAvailableVehiclesUseCase;
  final GetVehicleTypesUseCase? getVehicleTypesUseCase;

  BookingBloc({
    required this.getRecentJourneysUseCase,
    required this.getAvailableVehiclesUseCase,
    this.getVehicleTypesUseCase,
  }) : super(const BookingState(isLoading: true)) {
    on<LoadBookingDataEvent>(_onLoadBookingData);
    on<LoadVehicleTypesEvent>(_onLoadVehicleTypes);
    on<SelectVehicleTypeEvent>(_onSelectVehicleType);
    on<ChangePickupLocationEvent>(_onChangePickupLocation);
    on<ChangeDestinationEvent>(_onChangeDestination);
    on<SelectRideTypeTabEvent>(_onSelectRideTypeTab);
    on<SelectRecentJourneyEvent>(_onSelectRecentJourney);
    on<SearchVehiclesEvent>(_onSearchVehicles);
    on<ResetVehicleResultsEvent>(_onResetVehicleResults);
    on<SelectVehicleEvent>(_onSelectVehicle);
    on<BookVehicleNowEvent>(_onBookVehicleNow);
  }

  Future<void> _onLoadBookingData(
    LoadBookingDataEvent event,
    Emitter<BookingState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final journeys = await getRecentJourneysUseCase();
      final vehicles = await getAvailableVehiclesUseCase();
      final vehicleTypes = getVehicleTypesUseCase != null
          ? await getVehicleTypesUseCase!()
          : state.vehicleTypes;

      emit(state.copyWith(
        isLoading: false,
        isShowingVehicleResults: false,
        recentJourneys: journeys,
        availableVehicles: vehicles,
        vehicleTypes: vehicleTypes,
        selectedVehicleType:
            vehicleTypes.isNotEmpty ? vehicleTypes.first : null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load booking data',
      ));
    }
  }

  Future<void> _onLoadVehicleTypes(
    LoadVehicleTypesEvent event,
    Emitter<BookingState> emit,
  ) async {
    if (getVehicleTypesUseCase == null) return;
    try {
      final vehicleTypes = await getVehicleTypesUseCase!();
      emit(state.copyWith(
        vehicleTypes: vehicleTypes,
        selectedVehicleType: state.selectedVehicleType ??
            (vehicleTypes.isNotEmpty ? vehicleTypes.first : null),
      ));
    } catch (_) {}
  }

  void _onSelectVehicleType(
    SelectVehicleTypeEvent event,
    Emitter<BookingState> emit,
  ) {
    final match = state.vehicleTypes.firstWhere(
      (v) => v.id == event.vehicleTypeId,
      orElse: () => state.vehicleTypes.first,
    );
    emit(state.copyWith(
      selectedVehicleType: match,
      actionMessage: 'Selected ${event.vehicleTypeName}',
    ));
  }

  void _onResetVehicleResults(
    ResetVehicleResultsEvent event,
    Emitter<BookingState> emit,
  ) {
    emit(state.copyWith(isShowingVehicleResults: false));
  }

  void _onChangePickupLocation(
    ChangePickupLocationEvent event,
    Emitter<BookingState> emit,
  ) {
    emit(state.copyWith(pickupLocation: event.location));
  }

  void _onChangeDestination(
    ChangeDestinationEvent event,
    Emitter<BookingState> emit,
  ) {
    emit(state.copyWith(destination: event.destination));
  }

  void _onSelectRideTypeTab(
    SelectRideTypeTabEvent event,
    Emitter<BookingState> emit,
  ) {
    emit(state.copyWith(selectedRideTypeIndex: event.tabIndex));
  }

  void _onSelectRecentJourney(
    SelectRecentJourneyEvent event,
    Emitter<BookingState> emit,
  ) {
    emit(state.copyWith(
      destination: event.journeyTitle,
      actionMessage: 'Selected destination: ${event.journeyTitle}',
    ));
  }

  void _onSearchVehicles(
    SearchVehiclesEvent event,
    Emitter<BookingState> emit,
  ) {
    emit(state.copyWith(
      isShowingVehicleResults: true,
      actionMessage: 'Searching available vehicles...',
    ));
  }

  void _onSelectVehicle(
    SelectVehicleEvent event,
    Emitter<BookingState> emit,
  ) {
    emit(state.copyWith(
      actionMessage: 'Selected ${event.vehicleName}',
    ));
  }

  void _onBookVehicleNow(
    BookVehicleNowEvent event,
    Emitter<BookingState> emit,
  ) {
    emit(state.copyWith(
      actionMessage: 'Booking ${event.vehicleName}... Ride confirmed!',
    ));
  }
}
