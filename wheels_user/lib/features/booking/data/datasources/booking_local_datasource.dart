import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';
import '../models/recent_journey_model.dart';
import '../models/vehicle_option_model.dart';

abstract class BookingLocalDataSource {
  Future<List<RecentJourneyModel>> getRecentJourneys();
  Future<List<VehicleOptionModel>> getAvailableVehicles();
}

class BookingLocalDataSourceImpl implements BookingLocalDataSource {
  const BookingLocalDataSourceImpl();

  @override
  Future<List<RecentJourneyModel>> getRecentJourneys() async {
    return const [
      RecentJourneyModel(
        id: '1',
        title: AppStrings.jfkAirport,
        origin: AppStrings.fromLowerManhattan,
        timestamp: AppStrings.twoDaysAgo,
        iconType: 'history',
      ),
      RecentJourneyModel(
        id: '2',
        title: AppStrings.empireState,
        origin: AppStrings.fromGrandCentral,
        timestamp: '',
        iconType: 'favorite',
      ),
    ];
  }

  @override
  Future<List<VehicleOptionModel>> getAvailableVehicles() async {
    return const [
      VehicleOptionModel(
        id: 'v1',
        name: AppStrings.mercedesEClass,
        specs: AppStrings.sedanSpecs,
        price: '₹450',
        rating: '4.9',
        eta: '4 min',
        imagePath: AppAssets.vehicleMercedes,
      ),
      VehicleOptionModel(
        id: 'v2',
        name: AppStrings.tempoTraveler,
        specs: AppStrings.vanSpecs,
        price: '₹850',
        rating: '4.9',
        eta: '8 min',
        imagePath: AppAssets.vehicleForceTraveler,
      ),
      VehicleOptionModel(
        id: 'v3',
        name: AppStrings.miniBus,
        specs: AppStrings.miniBusSpecs,
        price: '₹1,400',
        rating: '4.9',
        eta: '15 min',
        imagePath: AppAssets.vehicleMiniBus,
      ),
      VehicleOptionModel(
        id: 'v4',
        name: 'Range Rover Autobiography',
        specs: '6 Seats · Hybrid · Quad Zone',
        price: '₹1,850',
        rating: '4.9',
        eta: '2 min',
        imagePath: AppAssets.vehicleRangeRover,
      ),
    ];
  }
}
