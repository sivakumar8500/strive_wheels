import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/core/network/api_client.dart';
import 'package:wheels_user/core/network/api_constants.dart';
import 'package:wheels_user/features/notifications/data/datasources/notification_remote_data_source.dart';
import 'package:wheels_user/features/notifications/data/models/notification_model.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late NotificationRemoteDataSourceImpl dataSource;
  late MockApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockApiClient();
    dataSource = NotificationRemoteDataSourceImpl(mockApiClient);
  });

  group('NotificationRemoteDataSource Tests', () {
    test('getNotifications returns list of NotificationModel on API success', () async {
      when(() => mockApiClient.get(ApiConstants.customerNotifications(limit: 50, skip: 0)))
          .thenAnswer((_) async => Response(
                requestOptions: RequestOptions(path: ApiConstants.customerNotifications()),
                statusCode: 200,
                data: {
                  'status': 'success',
                  'data': {
                    'items': [
                      {
                        'id': 101,
                        'user_id': 1,
                        'title': 'Test Promo',
                        'body': 'Get 10% off',
                        'notification_type': 'PROMOTIONAL',
                        'is_read': false,
                        'created_at': '2026-10-01T10:00:00.000Z',
                      }
                    ]
                  }
                },
              ));

      final result = await dataSource.getNotifications();
      expect(result.length, 1);
      expect(result.first.title, 'Test Promo');
    });

    test('getNotifications falls back to default passenger notifications on network error', () async {
      when(() => mockApiClient.get(ApiConstants.customerNotifications(limit: 50, skip: 0)))
          .thenThrow(DioException(requestOptions: RequestOptions(path: '')));

      final result = await dataSource.getNotifications();
      expect(result.isNotEmpty, true);
      expect(result.first, isA<NotificationModel>());
    });

    test('getUnreadCount returns integer count on API success', () async {
      when(() => mockApiClient.get(ApiConstants.customerUnreadNotificationsCount))
          .thenAnswer((_) async => Response(
                requestOptions: RequestOptions(path: ApiConstants.customerUnreadNotificationsCount),
                statusCode: 200,
                data: {
                  'data': {'unread_count': 3}
                },
              ));

      final count = await dataSource.getUnreadCount();
      expect(count, 3);
    });

    test('markAsRead returns true on successful API call', () async {
      when(() => mockApiClient.put(ApiConstants.markCustomerNotificationRead(101)))
          .thenAnswer((_) async => Response(
                requestOptions: RequestOptions(path: ''),
                statusCode: 200,
                data: {'status': 'success'},
              ));

      final res = await dataSource.markAsRead(101);
      expect(res, true);
    });

    test('markAllAsRead returns updated count on success', () async {
      when(() => mockApiClient.put(ApiConstants.markAllCustomerNotificationsRead))
          .thenAnswer((_) async => Response(
                requestOptions: RequestOptions(path: ''),
                statusCode: 200,
                data: {
                  'data': {'updated_count': 4}
                },
              ));

      final count = await dataSource.markAllAsRead();
      expect(count, 4);
    });
  });
}
