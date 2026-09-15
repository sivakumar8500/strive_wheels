import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/core/network/customer_ws_controller.dart';
import 'package:wheels_user/core/network/websocket_service.dart';
import 'package:wheels_user/features/chat/data/datasources/chat_remote_datasource.dart';

class MockDio extends Mock implements Dio {}
class MockCustomerWSController extends Mock implements CustomerWSController {}
class MockWebSocketService extends Mock implements WebSocketService {}

void main() {
  late ChatRemoteDataSourceImpl dataSource;
  late MockDio mockDio;
  late MockCustomerWSController mockCustomerWSController;
  late MockWebSocketService mockWebSocketService;

  setUp(() {
    mockDio = MockDio();
    mockCustomerWSController = MockCustomerWSController();
    mockWebSocketService = MockWebSocketService();
    dataSource = ChatRemoteDataSourceImpl(
      dio: mockDio,
      customerWSController: mockCustomerWSController,
      webSocketService: mockWebSocketService,
    );
  });

  group('getChatHistory', () {
    const tBookingId = 104;
    final tResponseData = {
      'success': true,
      'data': [
        {
          'id': 1,
          'booking_id': 104,
          'sender_id': 15,
          'sender_role': 'CUSTOMER',
          'message': 'Hi driver',
          'sent_at': '2026-09-13T00:10:00Z',
        }
      ]
    };

    test('should return List<ChatMessageModel> when dio response is 200', () async {
      when(() => mockDio.get(any())).thenAnswer(
        (_) async => Response(
          data: tResponseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/api/v1/bookings/$tBookingId/chat'),
        ),
      );

      final result = await dataSource.getChatHistory(tBookingId);

      expect(result.length, 1);
      expect(result.first.id, 1);
      expect(result.first.message, 'Hi driver');
      verify(() => mockDio.get('/api/v1/bookings/$tBookingId/chat')).called(1);
    });

    test('should return empty list when dio throws exception', () async {
      when(() => mockDio.get(any())).thenThrow(
        DioException(requestOptions: RequestOptions(path: '')),
      );

      final result = await dataSource.getChatHistory(tBookingId);

      expect(result, isEmpty);
    });
  });

  group('sendMessageHttp', () {
    const tBookingId = 104;
    const tMessage = 'On my way!';
    final tResponseData = {
      'success': true,
      'data': {
        'id': 2,
        'booking_id': 104,
        'sender_id': 8,
        'sender_role': 'RIDER',
        'message': tMessage,
        'sent_at': '2026-09-13T00:10:45Z',
      }
    };

    test('should return ChatMessageModel on successful POST', () async {
      when(() => mockDio.post(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => Response(
          data: tResponseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await dataSource.sendMessageHttp(tBookingId, tMessage);

      expect(result, isNotNull);
      expect(result?.id, 2);
      expect(result?.message, tMessage);
    });

    test('should return null when POST throws exception', () async {
      when(() => mockDio.post(any(), data: any(named: 'data'))).thenThrow(
        DioException(requestOptions: RequestOptions(path: '')),
      );

      final result = await dataSource.sendMessageHttp(tBookingId, tMessage);

      expect(result, isNull);
    });
  });

  group('sendMessageWs & listenChatEvents', () {
    test('sendMessageWs calls webSocketService.send', () {
      dataSource.sendMessageWs(104, 'Test msg');

      verify(() => mockWebSocketService.send('booking.chat_message', {
            'booking_id': 104,
            'message': 'Test msg',
          })).called(1);
    });

    test('listenChatEvents filters stream by booking_id', () async {
      final controller = StreamController<Map<String, dynamic>>.broadcast();
      when(() => mockCustomerWSController.bookingEventStream)
          .thenAnswer((_) => controller.stream);

      final stream = dataSource.listenChatEvents(104);

      final eventsFuture = stream.toList();

      controller.add({
        'event': 'booking.chat_message',
        'data': {'booking_id': 104, 'message': 'Match'}
      });
      controller.add({
        'event': 'booking.chat_message',
        'data': {'booking_id': 999, 'message': 'Other'}
      });
      controller.add({
        'event': 'booking.chat_closed',
        'data': {'booking_id': 104, 'reason': 'Completed'}
      });
      await controller.close();

      final events = await eventsFuture;
      expect(events.length, 2);
      expect(events[0]['data']['message'], 'Match');
      expect(events[1]['data']['reason'], 'Completed');
    });
  });
}
