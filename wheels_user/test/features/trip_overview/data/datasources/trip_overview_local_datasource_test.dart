import 'package:flutter_test/flutter_test.dart';
import 'package:wheels_user/core/constants/app_assets.dart';
import 'package:wheels_user/features/trip_overview/data/datasources/trip_overview_local_datasource.dart';

void main() {
  late TripOverviewLocalDataSourceImpl dataSource;

  setUp(() {
    dataSource = const TripOverviewLocalDataSourceImpl();
  });

  group('getTripOverviewDetails', () {
    test('returns Mercedes details for v1', () async {
      final result = await dataSource.getTripOverviewDetails('v1');
      expect(result.vehicleName, 'Executive Luxury Sedan');
      expect(result.vehicleImagePath, AppAssets.vehicleMercedes);
    });

    test('returns Force Traveler details for v2', () async {
      final result = await dataSource.getTripOverviewDetails('v2');
      expect(result.vehicleName, 'Force Traveler');
      expect(result.vehicleImagePath, AppAssets.vehicleForceTraveler);
    });

    test('returns Mini Bus details for v3', () async {
      final result = await dataSource.getTripOverviewDetails('v3');
      expect(result.vehicleName, 'Mini Bus');
      expect(result.vehicleImagePath, AppAssets.vehicleMiniBus);
    });

    test('returns Range Rover details for v4', () async {
      final result = await dataSource.getTripOverviewDetails('v4');
      expect(result.vehicleName, 'Range Rover Autobiography');
      expect(result.vehicleImagePath, AppAssets.vehicleRangeRover);
    });
  });
}
