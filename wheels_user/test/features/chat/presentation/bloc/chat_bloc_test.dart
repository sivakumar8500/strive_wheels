import 'dart:async';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/chat/domain/entities/chat_message_entity.dart';
import 'package:wheels_user/features/chat/domain/usecases/get_chat_history_usecase.dart';
import 'package:wheels_user/features/chat/domain/usecases/listen_chat_messages_usecase.dart';
import 'package:wheels_user/features/chat/domain/usecases/send_chat_message_usecase.dart';
import 'package:wheels_user/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:wheels_user/features/chat/presentation/bloc/chat_event.dart';
import 'package:wheels_user/features/chat/presentation/bloc/chat_state.dart';

class MockGetChatHistoryUseCase extends Mock implements GetChatHistoryUseCase {}
class MockSendChatMessageUseCase extends Mock implements SendChatMessageUseCase {}
class MockListenChatMessagesUseCase extends Mock implements ListenChatMessagesUseCase {}

void main() {
  late MockGetChatHistoryUseCase mockGetChatHistoryUseCase;
  late MockSendChatMessageUseCase mockSendChatMessageUseCase;
  late MockListenChatMessagesUseCase mockListenChatMessagesUseCase;

  final tTime = DateTime.parse('2026-09-13T00:10:00Z');
  final tMsg1 = ChatMessageEntity(
    id: 1,
    bookingId: 104,
    senderId: 15,
    senderRole: 'CUSTOMER',
    message: 'Hello driver',
    sentAt: tTime,
  );
  final tMsg2 = ChatMessageEntity(
    id: 2,
    bookingId: 104,
    senderId: 8,
    senderRole: 'RIDER',
    message: 'On my way!',
    sentAt: tTime.add(const Duration(seconds: 45)),
  );

  setUp(() {
    mockGetChatHistoryUseCase = MockGetChatHistoryUseCase();
    mockSendChatMessageUseCase = MockSendChatMessageUseCase();
    mockListenChatMessagesUseCase = MockListenChatMessagesUseCase();

    when(() => mockListenChatMessagesUseCase(any()))
        .thenAnswer((_) => const Stream.empty());
  });

  ChatBloc buildBloc() {
    return ChatBloc(
      getChatHistoryUseCase: mockGetChatHistoryUseCase,
      sendChatMessageUseCase: mockSendChatMessageUseCase,
      listenChatMessagesUseCase: mockListenChatMessagesUseCase,
      bookingId: 104,
    );
  }

  test('initial state has correct bookingId and default properties', () {
    final bloc = buildBloc();
    expect(bloc.state.bookingId, 104);
    expect(bloc.state.messages, isEmpty);
    expect(bloc.state.isLoadingHistory, false);
    expect(bloc.state.isClosed, false);
    bloc.close();
  });

  blocTest<ChatBloc, ChatState>(
    'emits isLoadingHistory true then messages on ChatEvent.init',
    build: () {
      when(() => mockGetChatHistoryUseCase(104))
          .thenAnswer((_) async => [tMsg1]);
      return buildBloc();
    },
    act: (bloc) => bloc.add(const ChatEvent.init(104)),
    expect: () => [
      const ChatState(bookingId: 104, isLoadingHistory: true),
      ChatState(bookingId: 104, isLoadingHistory: false, messages: [tMsg1]),
    ],
  );

  blocTest<ChatBloc, ChatState>(
    'emits updated messages state when ChatEvent.sendMessage is triggered',
    build: () {
      when(() => mockSendChatMessageUseCase(bookingId: 104, message: 'On my way!'))
          .thenAnswer((_) async => tMsg2);
      return buildBloc();
    },
    act: (bloc) => bloc.add(const ChatEvent.sendMessage('On my way!')),
    expect: () => [
      ChatState(bookingId: 104, messages: [tMsg2]),
    ],
  );

  blocTest<ChatBloc, ChatState>(
    'emits isClosed true and shouldNavigateHome true when ChatEvent.chatClosed has shouldNavigateHome: true',
    build: buildBloc,
    act: (bloc) => bloc.add(const ChatEvent.chatClosed(
      'Chat is closed for booking with status RIDER_CANCELLED.',
      shouldNavigateHome: true,
    )),
    expect: () => [
      const ChatState(
        bookingId: 104,
        isClosed: true,
        shouldNavigateHome: true,
        closeReason: 'Chat is closed for booking with status RIDER_CANCELLED.',
      ),
    ],
  );

  blocTest<ChatBloc, ChatState>(
    'emits isClosed true and shouldNavigateHome true when getChatHistory throws RIDER_CANCELLED exception',
    build: () {
      when(() => mockGetChatHistoryUseCase(104))
          .thenThrow(Exception('Chat is closed for booking with status RIDER_CANCELLED.'));
      return buildBloc();
    },
    act: (bloc) => bloc.add(const ChatEvent.init(104)),
    expect: () => [
      const ChatState(bookingId: 104, isLoadingHistory: true),
      const ChatState(
        bookingId: 104,
        isClosed: true,
        shouldNavigateHome: true,
        closeReason: 'Chat is closed for booking with status RIDER_CANCELLED.',
      ),
    ],
  );
}
