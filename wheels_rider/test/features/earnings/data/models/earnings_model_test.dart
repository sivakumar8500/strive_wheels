import 'package:flutter_test/flutter_test.dart';
import 'package:wheels_rider/features/earnings/data/models/earnings_model.dart';
import 'package:wheels_rider/features/earnings/domain/entities/earnings_entity.dart';

void main() {
  final tDate = DateTime(2026, 8, 30);
  final tActivityModel = EarningsActivityModel(
    id: '1',
    type: 'TRIP',
    title: 'Trip 1',
    subtitle: 'Subtitle',
    amount: 100.0,
    timestamp: tDate,
  );

  final tModel = EarningsModel(
    totalEarnings: 1000.0,
    trips: 10,
    hours: 20.0,
    rating: 4.8,
    recentActivities: [tActivityModel],
  );

  final tActivityEntity = EarningsActivityEntity(
    id: '1',
    type: 'TRIP',
    title: 'Trip 1',
    subtitle: 'Subtitle',
    amount: 100.0,
    timestamp: tDate,
  );

  final tEntity = EarningsEntity(
    totalEarnings: 1000.0,
    trips: 10,
    hours: 20.0,
    rating: 4.8,
    recentActivities: [tActivityEntity],
  );

  test('should map model to entity', () {
    final result = tModel.toEntity();
    expect(result, equals(tEntity));
  });

  test('should create model from JSON', () {
    final Map<String, dynamic> jsonMap = {
      "total_earnings": 1000.0,
      "trips": 10,
      "hours": 20.0,
      "rating": 4.8,
      "recent_activities": [
        {
          "id": "1",
          "type": "TRIP",
          "title": "Trip 1",
          "subtitle": "Subtitle",
          "amount": 100.0,
          "timestamp": tDate.toIso8601String(),
        }
      ]
    };

    final result = EarningsModel.fromJson(jsonMap);
    expect(result, equals(tModel));
  });

  test('should return JSON map', () {
    final result = tModel.toJson();
    final expectedJsonMap = {
      "total_earnings": 1000.0,
      "trips": 10,
      "hours": 20.0,
      "rating": 4.8,
      "recent_activities": [
        {
          "id": "1",
          "type": "TRIP",
          "title": "Trip 1",
          "subtitle": "Subtitle",
          "amount": 100.0,
          "timestamp": tDate.toIso8601String(),
        }
      ]
    };
    expect(result, equals(expectedJsonMap));
  });
}
