import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/chat_message_entity.dart';

part 'chat_state.freezed.dart';

@freezed
abstract class ChatState with _$ChatState {
  const ChatState._();

  const factory ChatState({
    required int bookingId,
    @Default([]) List<ChatMessageEntity> messages,
    @Default(false) bool isLoadingHistory,
    @Default(false) bool isClosed,
    @Default(false) bool shouldNavigateHome,
    String? closeReason,
    String? errorMessage,
  }) = _ChatState;
}
