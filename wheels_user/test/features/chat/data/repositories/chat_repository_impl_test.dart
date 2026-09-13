import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:wheels_user/features/chat/data/models/chat_message_model.dart';
import 'package:wheels_user/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:wheels_user/features/chat/domain/entities/chat_message_entity.dart';

class MockChatRemoteDataSource extends Mock implements ChatRemoteDataSource {}

void main() {
  late ChatRepositoryImpl repository;
  late MockChatRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockChatRemoteDataSource();
    repository = ChatRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  group('getChatHistory', () {
    const tBookingId = 104;
    final tModels = [
      const ChatMessageModel(
        id: 1,
        bookingId: 104,
        senderId: 15,
        senderRole: 'CUSTOMER',
        message: 'Hello',
        sentAt: '2026-09-13T00:10:00Z',
      ),
    ];

    test('should return sorted List<ChatMessageEntity>', () async {
      when(() => mockRemoteDataSource.getChatHistory(tBookingId))
          .thenAnswer((_) async => tModels);

      final result = await repository.getChatHistory(tBookingId);

      expect(result.length, 1);
      expect(result.first, isA<ChatMessageEntity>());
      expect(result.first.id, 1);
      expect(result.first.message, 'Hello');
      verify(() => mockRemoteDataSource.getChatHistory(tBookingId)).called(1);
    });
  });

  group('sendMessage', () {
    const tBookingId = 104;
    const tMessage = 'On my way!';
    const tModel = ChatMessageModel(
      id: 2,
      bookingId: 104,
      senderId: 8,
      senderRole: 'RIDER',
      message: tMessage,
      sentAt: '2026-09-13T00:10:45Z',
    );

    test('should trigger WS send and return mapped entity from HTTP fallback model', () async {
      when(() => mockRemoteDataSource.sendMessageHttp(tBookingId, tMessage))
          .thenAnswer((_) async => tModel);

      final result = await repository.sendMessage(
        bookingId: tBookingId,
        message: tMessage,
      );

      verify(() => mockRemoteDataSource.sendMessageWs(tBookingId, tMessage)).called(1);
      verify(() => mockRemoteDataSource.sendMessageHttp(tBookingId, tMessage)).called(1);
      expect(result?.id, 2);
      expect(result?.message, tMessage);
    });
  });

  group('listenChatEvents', () {
    test('should delegate to remoteDataSource.listenChatEvents', () {
      when(() => mockRemoteDataSource.listenChatEvents(104))
          .thenAnswer((_) => Stream.value({'event': 'booking.chat_closed'}));

      final stream = repository.listenChatEvents(104);

      expect(stream, emits({'event': 'booking.chat_closed'}));
      verify(() => mockRemoteDataSource.listenChatEvents(104)).called(1);
    });
  });
}
