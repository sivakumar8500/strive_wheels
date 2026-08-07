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
        rating: '4.9 (48)',
        eta: '4 min',
        imagePath: 'assets/images/mercedes_car.png',
      ),
      VehicleOptionModel(
        id: 'v2',
        name: AppStrings.tempoTraveler,
        specs: AppStrings.vanSpecs,
        price: '₹850',
        rating: '4.8 (32)',
        eta: '8 min',
        imagePath: 'assets/images/tempo_van.png',
      ),
      VehicleOptionModel(
        id: 'v3',
        name: AppStrings.miniBus,
        specs: AppStrings.miniBusSpecs,
        price: '₹1,400',
        rating: '4.7 (19)',
        eta: '15 min',
        imagePath: 'assets/images/mini_bus.png',
      ),
    ];
  }
}
