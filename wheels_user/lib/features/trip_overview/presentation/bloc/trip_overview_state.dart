import '../../domain/entities/trip_overview_entity.dart';

class TripOverviewState {
  final bool isLoading;
  final TripOverviewEntity? tripOverview;
  final bool isWalletSelected;
  final String promoCode;
  final bool isPromoApplied;
  final bool isBookingConfirmed;
  final String? actionMessage;
  final String? errorMessage;

  const TripOverviewState({
    this.isLoading = false,
    this.tripOverview,
    this.isWalletSelected = false,
    this.promoCode = '',
    this.isPromoApplied = false,
    this.isBookingConfirmed = false,
    this.actionMessage,
    this.errorMessage,
  });

  TripOverviewState copyWith({
    bool? isLoading,
    TripOverviewEntity? tripOverview,
    bool? isWalletSelected,
    String? promoCode,
    bool? isPromoApplied,
    bool? isBookingConfirmed,
    String? actionMessage,
    String? errorMessage,
  }) {
    return TripOverviewState(
      isLoading: isLoading ?? this.isLoading,
      tripOverview: tripOverview ?? this.tripOverview,
      isWalletSelected: isWalletSelected ?? this.isWalletSelected,
      promoCode: promoCode ?? this.promoCode,
      isPromoApplied: isPromoApplied ?? this.isPromoApplied,
      isBookingConfirmed: isBookingConfirmed ?? this.isBookingConfirmed,
      actionMessage: actionMessage,
      errorMessage: errorMessage,
    );
  }
}
