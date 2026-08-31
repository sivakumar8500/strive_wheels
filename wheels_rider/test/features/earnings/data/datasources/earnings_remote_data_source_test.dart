import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:wheels_rider/core/network/api_client.dart';
import 'package:wheels_rider/features/earnings/data/datasources/earnings_remote_data_source.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late EarningsRemoteDataSourceImpl dataSource;
  late MockApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockApiClient();
    dataSource = EarningsRemoteDataSourceImpl(mockApiClient);
  });

  final tDate = DateTime(2026, 8, 30);
  final tJson = {
    "data": {
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
    }
  };

  test('should return EarningsModel when response is 200', () async {
    when(() => mockApiClient.get(any()))
        .thenAnswer((_) async => Response(requestOptions: RequestOptions(path: ''), data: tJson, statusCode: 200));

    final result = await dataSource.getEarnings(50, 0);

    expect(result.totalEarnings, equals(1000.0));
    verify(() => mockApiClient.get(any())).called(1);
  });

  test('should throw Exception when DioException occurs', () async {
    when(() => mockApiClient.get(any()))
        .thenThrow(DioException(requestOptions: RequestOptions(path: ''), message: 'Error'));

    expect(() => dataSource.getEarnings(50, 0), throwsA(isA<Exception>()));
  });
}
