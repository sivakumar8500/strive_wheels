import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/chat/domain/entities/chat_message_entity.dart';
import 'package:wheels_user/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:wheels_user/features/chat/presentation/bloc/chat_event.dart';
import 'package:wheels_user/features/chat/presentation/bloc/chat_state.dart';
import 'package:wheels_user/features/chat/presentation/pages/ride_chat_page.dart';
import 'package:wheels_user/features/chat/presentation/widgets/chat_bubble.dart';

class MockChatBloc extends MockBloc<ChatEvent, ChatState> implements ChatBloc {}

void main() {
  late MockChatBloc mockChatBloc;

  final tTime = DateTime.parse('2026-09-13T00:10:00Z');
  final tMsg1 = ChatMessageEntity(
    id: 1,
    bookingId: 104,
    senderId: 15,
    senderRole: 'CUSTOMER',
    message: 'Hello driver',
    sentAt: tTime,
  );

  setUp(() {
    mockChatBloc = MockChatBloc();

    final initialState = ChatState(
      bookingId: 104,
      messages: [tMsg1],
      isLoadingHistory: false,
      isClosed: false,
    );

    when(() => mockChatBloc.state).thenReturn(initialState);
    when(() => mockChatBloc.stream).thenAnswer((_) => Stream.value(initialState));
    when(() => mockChatBloc.close()).thenAnswer((_) async {});
  });

  Widget buildTestableWidget({ChatBloc? bloc}) {
    return MaterialApp(
      home: RideChatPage(
        bookingId: 104,
        currentUserId: 15,
        counterpartyName: 'Rider Rahul',
        chatBloc: bloc ?? mockChatBloc,
      ),
    );
  }

  testWidgets('renders RideChatPage with app bar, chat bubble, and input textfield', (tester) async {
    await tester.pumpWidget(buildTestableWidget());
    await tester.pumpAndSettle();

    expect(find.text('Rider Rahul'), findsOneWidget);
    expect(find.text('In-Ride Chat'), findsOneWidget);
    expect(find.text('Hello driver'), findsOneWidget);
    expect(find.byType(ChatBubble), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.byIcon(Icons.send_rounded), findsOneWidget);
  });

  testWidgets('triggers ChatEvent.sendMessage when send button is tapped', (tester) async {
    await tester.pumpWidget(buildTestableWidget());
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'I am here');
    await tester.tap(find.byIcon(Icons.send_rounded));
    await tester.pumpAndSettle();

    verify(() => mockChatBloc.add(const ChatEvent.sendMessage('I am here'))).called(1);
  });

  testWidgets('displays chat closed banner when state.isClosed is true', (tester) async {
    const closedState = ChatState(
      bookingId: 104,
      messages: [],
      isLoadingHistory: false,
      isClosed: true,
      closeReason: 'Trip completed',
    );

    when(() => mockChatBloc.state).thenReturn(closedState);
    when(() => mockChatBloc.stream).thenAnswer((_) => Stream.value(closedState));

    await tester.pumpWidget(buildTestableWidget(bloc: mockChatBloc));
    await tester.pumpAndSettle();

    expect(find.text('Trip completed'), findsOneWidget);
  });
}
