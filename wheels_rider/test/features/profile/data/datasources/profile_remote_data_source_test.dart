import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_rider/core/network/api_client.dart';
import 'package:wheels_rider/features/profile/data/datasources/profile_remote_data_source.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late ProfileRemoteDataSourceImpl dataSource;
  late MockApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockApiClient();
    dataSource = ProfileRemoteDataSourceImpl(mockApiClient);
  });

  final tProfileJson = {
    "data": {
      "id": 1,
      "rating_avg": 4.98,
      "total_earnings": 0.0,
      "wallet_balance": 0.0,
      "user": {
        "full_name": "Alex",
        "profile_image_url": "url",
        "phone": "1234567890",
        "dob": "1990-01-01",
        "gender": "Male",
        "email": "test@test.com"
      }
    }
  };

  test('should return ProfileModel when getProfile is successful', () async {
    when(() => mockApiClient.get(any())).thenAnswer(
      (_) async => Response(
        data: tProfileJson,
        statusCode: 200,
        requestOptions: RequestOptions(path: ''),
      ),
    );

    final result = await dataSource.getProfile();
    expect(result.id, equals(1));
    expect(result.user?['full_name'], equals('Alex'));
  });

  test('should return ProfileModel when updateProfile is successful', () async {
    when(() => mockApiClient.put(any(), data: any(named: 'data'))).thenAnswer(
      (_) async => Response(
        data: tProfileJson,
        statusCode: 200,
        requestOptions: RequestOptions(path: ''),
      ),
    );

    final result = await dataSource.updateProfile({'name': 'Alex'});
    expect(result.user?['full_name'], equals('Alex'));
  });
}
