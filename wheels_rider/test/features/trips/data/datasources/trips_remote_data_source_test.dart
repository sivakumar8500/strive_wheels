import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:wheels_rider/core/network/api_client.dart';
import 'package:wheels_rider/features/trips/data/datasources/trips_remote_data_source.dart';
import 'package:wheels_rider/features/trips/data/models/trip_model.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late TripsRemoteDataSourceImpl dataSource;
  late MockApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockApiClient();
    dataSource = TripsRemoteDataSourceImpl(mockApiClient);
  });

  final tTripModel = TripModel(
    totalMileage: 14280.0,
    totalRides: 1240,
    avgRating: 4.98,
    bookings: [],
  );

  test('should return TripModel on success', () async {
    when(() => mockApiClient.get(any())).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: ''),
          data: {
            "total_mileage": 14280.0,
            "total_rides": 1240,
            "avg_rating": 4.98,
            "bookings": []
          },
          statusCode: 200,
        ));
    final result = await dataSource.getTrips(50, 0);
    expect(result, equals(tTripModel));
  });

  test('should throw Exception on DioError', () async {
    when(() => mockApiClient.get(any())).thenThrow(DioException(requestOptions: RequestOptions(path: '')));
    expect(() => dataSource.getTrips(50, 0), throwsException);
  });
}
