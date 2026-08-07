import '../../domain/entities/recent_journey_entity.dart';
import '../../domain/entities/vehicle_option_entity.dart';

class BookingState {
  final bool isLoading;
  final String pickupLocation;
  final String destination;
  final int selectedRideTypeIndex; // 0: Instant, 1: One Way, 2: Round Trip
  final List<RecentJourneyEntity> recentJourneys;
  final List<VehicleOptionEntity> availableVehicles;
  final bool isShowingVehicleResults;
  final String? actionMessage;
  final String? errorMessage;

  const BookingState({
    this.isLoading = false,
    this.pickupLocation = '5th Avenue, NYC',
    this.destination = 'Where to?',
    this.selectedRideTypeIndex = 0,
    this.recentJourneys = const [],
    this.availableVehicles = const [],
    this.isShowingVehicleResults = false,
    this.actionMessage,
    this.errorMessage,
  });

  BookingState copyWith({
    bool? isLoading,
    String? pickupLocation,
    String? destination,
    int? selectedRideTypeIndex,
    List<RecentJourneyEntity>? recentJourneys,
    List<VehicleOptionEntity>? availableVehicles,
    bool? isShowingVehicleResults,
    String? actionMessage,
    String? errorMessage,
  }) {
    return BookingState(
      isLoading: isLoading ?? this.isLoading,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      destination: destination ?? this.destination,
      selectedRideTypeIndex:
          selectedRideTypeIndex ?? this.selectedRideTypeIndex,
      recentJourneys: recentJourneys ?? this.recentJourneys,
      availableVehicles: availableVehicles ?? this.availableVehicles,
      isShowingVehicleResults:
          isShowingVehicleResults ?? this.isShowingVehicleResults,
      actionMessage: actionMessage,
      errorMessage: errorMessage,
    );
  }
}
