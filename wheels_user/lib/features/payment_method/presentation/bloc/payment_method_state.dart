import '../../domain/entities/payment_method_entity.dart';

class PaymentMethodState {
  final bool isLoading;
  final PaymentMethodEntity? paymentDetails;
  final String selectedMethod;
  final bool isPaymentSuccess;
  final String? errorMessage;

  const PaymentMethodState({
    this.isLoading = true,
    this.paymentDetails,
    this.selectedMethod = 'card',
    this.isPaymentSuccess = false,
    this.errorMessage,
  });

  PaymentMethodState copyWith({
    bool? isLoading,
    PaymentMethodEntity? paymentDetails,
    String? selectedMethod,
    bool? isPaymentSuccess,
    String? errorMessage,
  }) {
    return PaymentMethodState(
      isLoading: isLoading ?? this.isLoading,
      paymentDetails: paymentDetails ?? this.paymentDetails,
      selectedMethod: selectedMethod ?? this.selectedMethod,
      isPaymentSuccess: isPaymentSuccess ?? this.isPaymentSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
