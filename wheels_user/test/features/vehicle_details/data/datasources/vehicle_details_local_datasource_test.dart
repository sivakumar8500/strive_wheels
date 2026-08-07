import 'package:flutter_test/flutter_test.dart';
import 'package:wheels_user/core/constants/app_assets.dart';
import 'package:wheels_user/features/vehicle_details/data/datasources/vehicle_details_local_datasource.dart';

void main() {
  late VehicleDetailsLocalDataSourceImpl dataSource;

  setUp(() {
    dataSource = const VehicleDetailsLocalDataSourceImpl();
  });

  group('getVehicleDetails', () {
    test('returns Mercedes details for v1', () async {
      final result = await dataSource.getVehicleDetails('v1');
      expect(result.id, 'v1');
      expect(result.vehicleName, 'Mercedes E-Class');
      expect(result.imagePath, AppAssets.vehicleMercedes);
    });

    test('returns Force Traveler details for v2', () async {
      final result = await dataSource.getVehicleDetails('v2');
      expect(result.id, 'v2');
      expect(result.vehicleName, 'Force Traveler');
      expect(result.imagePath, AppAssets.vehicleForceTraveler);
    });

    test('returns Mini Bus details for v3', () async {
      final result = await dataSource.getVehicleDetails('v3');
      expect(result.id, 'v3');
      expect(result.vehicleName, 'Mini Bus');
      expect(result.imagePath, AppAssets.vehicleMiniBus);
    });

    test('returns Range Rover details for v4', () async {
      final result = await dataSource.getVehicleDetails('v4');
      expect(result.id, 'v4');
      expect(result.vehicleName, 'Range Rover Autobiography');
      expect(result.imagePath, AppAssets.vehicleRangeRover);
    });
  });
}
