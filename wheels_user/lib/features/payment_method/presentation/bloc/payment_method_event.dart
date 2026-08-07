abstract class PaymentMethodEvent {
  const PaymentMethodEvent();
}

class LoadPaymentMethodEvent extends PaymentMethodEvent {
  final String vehicleId;

  const LoadPaymentMethodEvent([this.vehicleId = 'v1']);
}

class SelectPaymentOptionEvent extends PaymentMethodEvent {
  final String method;

  const SelectPaymentOptionEvent(this.method);
}

class SubmitPaymentEvent extends PaymentMethodEvent {
  const SubmitPaymentEvent();
}
