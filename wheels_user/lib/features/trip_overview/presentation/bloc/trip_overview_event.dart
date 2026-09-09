abstract class TripOverviewEvent {
  const TripOverviewEvent();
}

class LoadTripOverviewEvent extends TripOverviewEvent {
  final String vehicleId;

  const LoadTripOverviewEvent([this.vehicleId = 'v1']);
}

class ToggleWalletPaymentEvent extends TripOverviewEvent {
  final bool useWallet;

  const ToggleWalletPaymentEvent(this.useWallet);
}

class ApplyPromoCodeEvent extends TripOverviewEvent {
  final String code;

  const ApplyPromoCodeEvent(this.code);
}

class ConfirmFinalBookingEvent extends TripOverviewEvent {
  const ConfirmFinalBookingEvent();
}
