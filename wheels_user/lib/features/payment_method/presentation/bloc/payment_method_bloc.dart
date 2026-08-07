import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_payment_method_usecase.dart';
import 'payment_method_event.dart';
import 'payment_method_state.dart';

class PaymentMethodBloc extends Bloc<PaymentMethodEvent, PaymentMethodState> {
  final GetPaymentMethodUseCase getPaymentMethodUseCase;

  PaymentMethodBloc({required this.getPaymentMethodUseCase})
      : super(const PaymentMethodState(isLoading: true)) {
    on<LoadPaymentMethodEvent>(_onLoadPaymentMethod);
    on<SelectPaymentOptionEvent>(_onSelectPaymentOption);
    on<SubmitPaymentEvent>(_onSubmitPayment);
  }

  Future<void> _onLoadPaymentMethod(
    LoadPaymentMethodEvent event,
    Emitter<PaymentMethodState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final details = await getPaymentMethodUseCase(event.vehicleId);
      emit(state.copyWith(
        isLoading: false,
        paymentDetails: details,
        selectedMethod: details.selectedMethod,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load payment methods',
      ));
    }
  }

  void _onSelectPaymentOption(
    SelectPaymentOptionEvent event,
    Emitter<PaymentMethodState> emit,
  ) {
    emit(state.copyWith(selectedMethod: event.method));
  }

  void _onSubmitPayment(
    SubmitPaymentEvent event,
    Emitter<PaymentMethodState> emit,
  ) {
    emit(state.copyWith(isPaymentSuccess: true));
  }
}
