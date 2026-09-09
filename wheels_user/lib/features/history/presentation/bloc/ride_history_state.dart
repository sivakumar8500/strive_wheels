import '../../domain/entities/ride_history_entity.dart';

class RideHistoryState {
  final bool isLoading;
  final RideHistoryEntity? historyEntity;
  final int selectedFilterIndex; // 0: All trips, 1: Rides, 2: Deliveries
  final String? bookAgainMessage;
  final String? actionMessage;
  final String? errorMessage;

  const RideHistoryState({
    this.isLoading = false,
    this.historyEntity,
    this.selectedFilterIndex = 0,
    this.bookAgainMessage,
    this.actionMessage,
    this.errorMessage,
  });

  RideHistoryState copyWith({
    bool? isLoading,
    RideHistoryEntity? historyEntity,
    int? selectedFilterIndex,
    String? bookAgainMessage,
    String? actionMessage,
    String? errorMessage,
  }) {
    return RideHistoryState(
      isLoading: isLoading ?? this.isLoading,
      historyEntity: historyEntity ?? this.historyEntity,
      selectedFilterIndex: selectedFilterIndex ?? this.selectedFilterIndex,
      bookAgainMessage: bookAgainMessage,
      actionMessage: actionMessage,
      errorMessage: errorMessage,
    );
  }
}
