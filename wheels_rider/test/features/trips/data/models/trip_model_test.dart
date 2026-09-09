import 'package:flutter_test/flutter_test.dart';
import 'package:wheels_rider/features/trips/domain/entities/trip_entity.dart';
import 'package:wheels_rider/features/trips/data/models/trip_model.dart';

void main() {
  final tBookingModel = BookingModel(
    id: '1',
    clientName: 'Sarah Jenkins',
    clientRating: 5.0,
    tag: 'Corporate',
    price: 42.8,
    pickupLocation: 'A',
    dropoffLocation: 'B',
    timestamp: DateTime.parse('2023-01-01T00:00:00Z'),
    status: 'Completed',
  );

  final tTripModel = TripModel(
    totalMileage: 14280.0,
    totalRides: 1240,
    avgRating: 4.98,
    bookings: [tBookingModel],
  );

  test('should convert to entity correctly', () {
    final result = tTripModel.toEntity();
    expect(result, isA<TripEntity>());
    expect(result.totalRides, 1240);
    expect(result.bookings.first.clientName, 'Sarah Jenkins');
  });

  test('should return a valid model from JSON', () {
    final Map<String, dynamic> jsonMap = {
      "total_mileage": 14280.0,
      "total_rides": 1240,
      "avg_rating": 4.98,
      "bookings": [
        {
          "id": "1",
          "client_name": "Sarah Jenkins",
          "client_rating": 5.0,
          "tag": "Corporate",
          "price": 42.8,
          "pickup_location": "A",
          "dropoff_location": "B",
          "timestamp": "2023-01-01T00:00:00.000Z",
          "status": "Completed"
        }
      ]
    };
    final result = TripModel.fromJson(jsonMap);
    expect(result, tTripModel);
  });
}
