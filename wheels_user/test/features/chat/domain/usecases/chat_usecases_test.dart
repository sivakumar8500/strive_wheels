import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/chat/domain/entities/chat_message_entity.dart';
import 'package:wheels_user/features/chat/domain/repositories/chat_repository.dart';
import 'package:wheels_user/features/chat/domain/usecases/get_chat_history_usecase.dart';
import 'package:wheels_user/features/chat/domain/usecases/listen_chat_messages_usecase.dart';
import 'package:wheels_user/features/chat/domain/usecases/send_chat_message_usecase.dart';

class MockChatRepository extends Mock implements ChatRepository {}

void main() {
  late MockChatRepository mockRepository;
  late GetChatHistoryUseCase getChatHistoryUseCase;
  late SendChatMessageUseCase sendChatMessageUseCase;
  late ListenChatMessagesUseCase listenChatMessagesUseCase;

  setUp(() {
    mockRepository = MockChatRepository();
    getChatHistoryUseCase = GetChatHistoryUseCase(mockRepository);
    sendChatMessageUseCase = SendChatMessageUseCase(mockRepository);
    listenChatMessagesUseCase = ListenChatMessagesUseCase(mockRepository);
  });

  final tEntity = ChatMessageEntity(
    id: 1,
    bookingId: 104,
    senderId: 15,
    senderRole: 'CUSTOMER',
    message: 'Hello',
    sentAt: DateTime.parse('2026-09-13T00:10:00Z'),
  );

  test('GetChatHistoryUseCase executes repository.getChatHistory', () async {
    when(() => mockRepository.getChatHistory(104))
        .thenAnswer((_) async => [tEntity]);

    final result = await getChatHistoryUseCase(104);

    expect(result, [tEntity]);
    verify(() => mockRepository.getChatHistory(104)).called(1);
  });

  test('SendChatMessageUseCase executes repository.sendMessage', () async {
    when(() => mockRepository.sendMessage(bookingId: 104, message: 'Hello'))
        .thenAnswer((_) async => tEntity);

    final result = await sendChatMessageUseCase(bookingId: 104, message: 'Hello');

    expect(result, tEntity);
    verify(() => mockRepository.sendMessage(bookingId: 104, message: 'Hello')).called(1);
  });

  test('ListenChatMessagesUseCase executes repository.listenChatEvents', () {
    when(() => mockRepository.listenChatEvents(104))
        .thenAnswer((_) => Stream.value({'event': 'booking.chat_message'}));

    final stream = listenChatMessagesUseCase(104);

    expect(stream, emits({'event': 'booking.chat_message'}));
    verify(() => mockRepository.listenChatEvents(104)).called(1);
  });
}
