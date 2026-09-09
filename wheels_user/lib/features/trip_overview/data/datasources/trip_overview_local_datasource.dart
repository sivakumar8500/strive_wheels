import '../../../../core/constants/app_assets.dart';
import '../models/trip_overview_model.dart';

abstract class TripOverviewLocalDataSource {
  Future<TripOverviewModel> getTripOverviewDetails(String vehicleId);
}

class TripOverviewLocalDataSourceImpl implements TripOverviewLocalDataSource {
  const TripOverviewLocalDataSourceImpl();

  @override
  Future<TripOverviewModel> getTripOverviewDetails(String vehicleId) async {
    switch (vehicleId) {
      case 'v2':
        return const TripOverviewModel(
          pickupLocation: 'St. Regis Residences, Downtown Dubai',
          destination: 'Dubai International Airport (DXB) Terminal 3',
          tripType: 'One Way',
          distanceText: '14.2 km (Approx 18 mins)',
          vehicleName: 'Force Traveler',
          vehicleSeats: '12 Seats',
          vehicleLuggage: '6 Luggage',
          vehicleAmenity: 'Rear AC Control',
          vehicleImagePath: AppAssets.vehicleForceTraveler,
          walletBalance: 142.50,
          baseFare: 140.00,
          distanceCharge: 12.50,
          serviceSurcharge: 5.00,
          taxesFees: 5.12,
          grandTotal: 162.62,
          currency: 'USD',
        );
      case 'v3':
        return const TripOverviewModel(
          pickupLocation: 'St. Regis Residences, Downtown Dubai',
          destination: 'Dubai International Airport (DXB) Terminal 3',
          tripType: 'One Way',
          distanceText: '14.2 km (Approx 18 mins)',
          vehicleName: 'Mini Bus',
          vehicleSeats: '24 Seats',
          vehicleLuggage: '15 Luggage',
          vehicleAmenity: 'Full Cabin AC',
          vehicleImagePath: AppAssets.vehicleMiniBus,
          walletBalance: 142.50,
          baseFare: 220.00,
          distanceCharge: 12.50,
          serviceSurcharge: 5.00,
          taxesFees: 5.12,
          grandTotal: 242.62,
          currency: 'USD',
        );
      case 'v4':
        return const TripOverviewModel(
          pickupLocation: 'St. Regis Residences, Downtown Dubai',
          destination: 'Dubai International Airport (DXB) Terminal 3',
          tripType: 'One Way',
          distanceText: '14.2 km (Approx 18 mins)',
          vehicleName: 'Range Rover Autobiography',
          vehicleSeats: '6 Seats',
          vehicleLuggage: '4 Luggage',
          vehicleAmenity: 'Quad Zone AC',
          vehicleImagePath: AppAssets.vehicleRangeRover,
          walletBalance: 142.50,
          baseFare: 280.00,
          distanceCharge: 12.50,
          serviceSurcharge: 5.00,
          taxesFees: 5.12,
          grandTotal: 302.62,
          currency: 'USD',
        );
      case 'v1':
      default:
        return const TripOverviewModel(
          pickupLocation: 'St. Regis Residences, Downtown Dubai',
          destination: 'Dubai International Airport (DXB) Terminal 3',
          tripType: 'One Way',
          distanceText: '14.2 km (Approx 18 mins)',
          vehicleName: 'Executive Luxury Sedan',
          vehicleSeats: '4 Seats',
          vehicleLuggage: '3 Luggage',
          vehicleAmenity: 'Complimentary Wi-Fi',
          vehicleImagePath: AppAssets.vehicleMercedes,
          walletBalance: 142.50,
          baseFare: 85.00,
          distanceCharge: 12.50,
          serviceSurcharge: 5.00,
          taxesFees: 5.12,
          grandTotal: 107.62,
          currency: 'USD',
        );
    }
  }
}
