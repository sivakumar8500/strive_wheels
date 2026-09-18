import '../../domain/entities/chat_message_entity.dart';

abstract class ChatEvent {
  const ChatEvent();

  factory ChatEvent.init(int bookingId) = ChatInitEvent;
  factory ChatEvent.sendMessage(String message) = ChatMessageSentEvent;
  factory ChatEvent.messageReceived(ChatMessageEntity message) = ChatMessageReceivedEvent;
  factory ChatEvent.chatClosed(String reason, {bool shouldNavigateHome}) = ChatClosedEvent;
}

class ChatInitEvent extends ChatEvent {
  final int bookingId;
  const ChatInitEvent(this.bookingId);
}

class ChatMessageSentEvent extends ChatEvent {
  final String message;
  const ChatMessageSentEvent(this.message);
}

class ChatMessageReceivedEvent extends ChatEvent {
  final ChatMessageEntity message;
  const ChatMessageReceivedEvent(this.message);
}

class ChatClosedEvent extends ChatEvent {
  final String reason;
  final bool shouldNavigateHome;
  const ChatClosedEvent(this.reason, {this.shouldNavigateHome = false});
}
