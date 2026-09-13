import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/chat_message_entity.dart';

part 'chat_event.freezed.dart';

@freezed
class ChatEvent with _$ChatEvent {
  const factory ChatEvent.init(int bookingId) = ChatInitEvent;
  const factory ChatEvent.sendMessage(String message) = ChatMessageSentEvent;
  const factory ChatEvent.messageReceived(ChatMessageEntity message) = ChatMessageReceivedEvent;
  const factory ChatEvent.chatClosed(String reason, {@Default(false) bool shouldNavigateHome}) = ChatClosedEvent;
}
