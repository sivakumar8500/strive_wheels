import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:wheels_rider/core/network/api_client.dart';
import 'package:wheels_rider/core/network/api_endpoints.dart';
import 'package:wheels_rider/features/home/data/datasources/home_remote_data_source.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late HomeRemoteDataSourceImpl dataSource;
  late MockApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockApiClient();
    dataSource = HomeRemoteDataSourceImpl(apiClient: mockApiClient);
  });

  group('updateLocation', () {
    const double tLat = 12.34;
    const double tLng = 56.78;
    final Map<String, dynamic> requestBody = {'lat': tLat, 'lng': tLng};

    test('should perform a POST request with the location data', () async {
      // arrange
      when(() => mockApiClient.post(
        ApiEndpoints.riderLocation,
        data: requestBody,
      )).thenAnswer((_) async => Response(
        requestOptions: RequestOptions(path: ''),
        data: {'success': true},
        statusCode: 200,
      ));

      // act
      await dataSource.updateLocation(lat: tLat, lng: tLng);

      // assert
      verify(() => mockApiClient.post(
        ApiEndpoints.riderLocation,
        data: requestBody,
      )).called(1);
      verifyNoMoreInteractions(mockApiClient);
    });

    test('should throw an exception when the API call fails', () async {
      // arrange
      when(() => mockApiClient.post(
        ApiEndpoints.riderLocation,
        data: requestBody,
      )).thenThrow(Exception('Server error'));

      // act
      final call = dataSource.updateLocation;

      // assert
      expect(() => call(lat: tLat, lng: tLng), throwsException);
    });
  });
}
