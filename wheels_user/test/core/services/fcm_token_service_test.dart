import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wheels_user/core/network/api_constants.dart';
import 'package:wheels_user/core/services/fcm_token_service.dart';

class MockDio extends Mock implements Dio {}
class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockDio mockDio;
  late MockSharedPreferences mockSharedPreferences;
  late FcmTokenService fcmTokenService;

  setUp(() {
    mockDio = MockDio();
    mockSharedPreferences = MockSharedPreferences();
    fcmTokenService = FcmTokenService(
      dio: mockDio,
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('FcmTokenService Unit Tests', () {
    test('updateFcmToken calls PUT /api/v1/auth/fcm-token and sets SharedPreferences', () async {
      when(() => mockDio.put(
            ApiConstants.updateFcmToken,
            data: {'fcm_token': 'string'},
            options: any(named: 'options'),
          )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ApiConstants.updateFcmToken),
          statusCode: 200,
          data: {'status': 'success', 'message': 'FCM token updated'},
        ),
      );

      when(() => mockSharedPreferences.setBool(any(), any()))
          .thenAnswer((_) async => true);

      final result = await fcmTokenService.updateFcmToken(token: 'string');

      expect(result, isTrue);
      verify(() => mockDio.put(
            ApiConstants.updateFcmToken,
            data: {'fcm_token': 'string'},
            options: any(named: 'options'),
          )).called(1);
    });

    test('registerFcmTokenOnInstall triggers updateFcmToken when first launch', () async {
      when(() => mockSharedPreferences.getBool(any())).thenReturn(false);
      when(() => mockSharedPreferences.setBool(any(), any()))
          .thenAnswer((_) async => true);

      when(() => mockDio.put(
            ApiConstants.updateFcmToken,
            data: {'fcm_token': 'string'},
            options: any(named: 'options'),
          )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ApiConstants.updateFcmToken),
          statusCode: 200,
          data: {'status': 'success'},
        ),
      );

      await fcmTokenService.registerFcmTokenOnInstall();

      verify(() => mockDio.put(
            ApiConstants.updateFcmToken,
            data: {'fcm_token': 'string'},
            options: any(named: 'options'),
          )).called(1);
    });
  });
}
