import 'package:flutter_test/flutter_test.dart';
import 'package:wheels_user/features/booking/data/models/corporate_aligned_vehicle_model.dart';
import 'package:wheels_user/features/booking/domain/entities/corporate_aligned_vehicle_entity.dart';

void main() {
  group('CorporateAlignedVehicleModel', () {
    const tJson = {
      'id': 1,
      'company_id': 1,
      'rider_id': 10,
      'vehicle_id': 5,
      'driver_name': 'Ramesh Kumar',
      'driver_phone': '+919876543210',
      'driver_rating': 4.9,
      'vehicle_name': 'Toyota Innova',
      'license_plate': 'TS09AB1234',
      'vehicle_type_id': 1,
      'vehicle_type_name': 'Sedan',
      'route_from': 'Kokapet',
      'route_to': 'Kukatpally',
      'route_from_lat': 17.412,
      'route_from_lng': 78.339,
      'route_to_lat': 17.493,
      'route_to_lng': 78.399,
      'is_aligned': true,
      'alignment_label': 'Direct Route Match (Kokapet ➔ Kukatpally)',
      'seats': 4,
    };

    test('should parse from valid JSON correctly', () {
      final model = CorporateAlignedVehicleModel.fromJson(tJson);

      expect(model.id, 1);
      expect(model.companyId, 1);
      expect(model.riderId, 10);
      expect(model.vehicleId, 5);
      expect(model.driverName, 'Ramesh Kumar');
      expect(model.driverPhone, '+919876543210');
      expect(model.driverRating, 4.9);
      expect(model.vehicleName, 'Toyota Innova');
      expect(model.licensePlate, 'TS09AB1234');
      expect(model.routeFrom, 'Kokapet');
      expect(model.routeTo, 'Kukatpally');
      expect(model.isAligned, isTrue);
      expect(model.alignmentLabel, 'Direct Route Match (Kokapet ➔ Kukatpally)');
      expect(model.seats, 4);
    });

    test('should convert to JSON correctly', () {
      final model = CorporateAlignedVehicleModel.fromJson(tJson);
      final json = model.toJson();

      expect(json['id'], 1);
      expect(json['rider_id'], 10);
      expect(json['route_from'], 'Kokapet');
      expect(json['route_to'], 'Kukatpally');
      expect(json['is_aligned'], isTrue);
    });

    test('should convert to entity properly', () {
      final model = CorporateAlignedVehicleModel.fromJson(tJson);
      final entity = model.toEntity();

      expect(entity, isA<CorporateAlignedVehicleEntity>());
      expect(entity.driverName, 'Ramesh Kumar');
      expect(entity.licensePlate, 'TS09AB1234');
      expect(entity.isAligned, isTrue);
    });
  });
}
