import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_trip_overview_usecase.dart';
import 'trip_overview_event.dart';
import 'trip_overview_state.dart';

class TripOverviewBloc extends Bloc<TripOverviewEvent, TripOverviewState> {
  final GetTripOverviewUseCase getTripOverviewUseCase;

  TripOverviewBloc({required this.getTripOverviewUseCase})
      : super(const TripOverviewState(isLoading: true)) {
    on<LoadTripOverviewEvent>(_onLoadTripOverview);
    on<ToggleWalletPaymentEvent>(_onToggleWalletPayment);
    on<ApplyPromoCodeEvent>(_onApplyPromoCode);
    on<ConfirmFinalBookingEvent>(_onConfirmFinalBooking);
  }

  Future<void> _onLoadTripOverview(
    LoadTripOverviewEvent event,
    Emitter<TripOverviewState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final details = await getTripOverviewUseCase(event.vehicleId);
      emit(state.copyWith(
        isLoading: false,
        tripOverview: details,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load trip overview',
      ));
    }
  }

  void _onToggleWalletPayment(
    ToggleWalletPaymentEvent event,
    Emitter<TripOverviewState> emit,
  ) {
    emit(state.copyWith(isWalletSelected: event.useWallet));
  }

  void _onApplyPromoCode(
    ApplyPromoCodeEvent event,
    Emitter<TripOverviewState> emit,
  ) {
    if (event.code.trim().isEmpty) return;
    emit(state.copyWith(
      promoCode: event.code,
      isPromoApplied: true,
      actionMessage: 'Promo code "${event.code}" applied successfully!',
    ));
  }

  void _onConfirmFinalBooking(
    ConfirmFinalBookingEvent event,
    Emitter<TripOverviewState> emit,
  ) {
    emit(state.copyWith(
      isBookingConfirmed: true,
      actionMessage: 'Trip booked successfully! Driver assigned.',
    ));
  }
}
