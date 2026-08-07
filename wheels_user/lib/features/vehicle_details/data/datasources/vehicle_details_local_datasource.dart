import '../../../../core/constants/app_assets.dart';
import '../models/vehicle_details_model.dart';

abstract class VehicleDetailsLocalDataSource {
  Future<VehicleDetailsModel> getVehicleDetails(String vehicleId);
}

class VehicleDetailsLocalDataSourceImpl
    implements VehicleDetailsLocalDataSource {
  const VehicleDetailsLocalDataSourceImpl();

  @override
  Future<VehicleDetailsModel> getVehicleDetails(String vehicleId) async {
    switch (vehicleId) {
      case 'v1':
        return const VehicleDetailsModel(
          id: 'v1',
          vehicleName: 'Mercedes E-Class',
          operatorName: 'SilverStar Luxury Rentals',
          isEcoFriendly: false,
          isTopRated: true,
          capacity: '4 Seats',
          luggage: '2 Medium',
          amenities: 'Free Wi-Fi',
          climate: 'Dual Zone',
          driverName: 'David Miller',
          driverRating: '4.9',
          driverTrips: '180trips',
          driverBio:
              'Professional executive chauffeur. English & German speaker with 10+ years experience.',
          estimatedDuration: '15 mins est.',
          pickupLocation: '5th Avenue, NY',
          dropoffLocation: 'Central Park, NY',
          price: '₹450',
          imagePath: AppAssets.vehicleMercedes,
        );
      case 'v2':
        return const VehicleDetailsModel(
          id: 'v2',
          vehicleName: 'Force Traveler',
          operatorName: 'SilverStar Luxury Rentals',
          isEcoFriendly: false,
          isTopRated: true,
          capacity: '12 Seats',
          luggage: '6 Large',
          amenities: 'Free Wi-Fi & USB',
          climate: 'Rear AC Control',
          driverName: 'Robert Chen',
          driverRating: '4.9',
          driverTrips: '310trips',
          driverBio:
              'Group transport specialist. High reliability & safe driving record across long trips.',
          estimatedDuration: '25 mins est.',
          pickupLocation: 'JFK Airport (Term 4)',
          dropoffLocation: 'Times Square, NY',
          price: '₹850',
          imagePath: AppAssets.vehicleForceTraveler,
        );
      case 'v3':
        return const VehicleDetailsModel(
          id: 'v3',
          vehicleName: 'Mini Bus',
          operatorName: 'SilverStar Luxury Rentals',
          isEcoFriendly: false,
          isTopRated: true,
          capacity: '24 Seats',
          luggage: '15 Large',
          amenities: 'Free Wi-Fi & Audio',
          climate: 'Full Cabin AC',
          driverName: 'James Wilson',
          driverRating: '4.9',
          driverTrips: '420trips',
          driverBio:
              'Senior coach captain. Fleet transport & long-distance tour expert.',
          estimatedDuration: '35 mins est.',
          pickupLocation: 'Grand Central Station',
          dropoffLocation: 'Brooklyn Bridge',
          price: '₹1,400',
          imagePath: AppAssets.vehicleMiniBus,
        );
      case 'v4':
      default:
        return const VehicleDetailsModel(
          id: 'v4',
          vehicleName: 'Range Rover Autobiography',
          operatorName: 'SilverStar Luxury Rentals',
          isEcoFriendly: true,
          isTopRated: true,
          capacity: '6 Seats',
          luggage: '4 Large',
          amenities: 'Free Wi-Fi',
          climate: 'Quad Zone',
          driverName: 'Michael Henderson',
          driverRating: '4.9',
          driverTrips: '240trips',
          driverBio:
              'Elite-tier driver. English, German, and French speaker. Concierge-trained for executive transport.',
          estimatedDuration: '42 mins est.',
          pickupLocation: 'Zurich Airport (ZRH)',
          dropoffLocation: 'Baur au Lac Hotel',
          price: '₹1,850',
          imagePath: AppAssets.vehicleRangeRover,
        );
    }
  }
}
