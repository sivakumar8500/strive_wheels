import '../../domain/entities/chat_message_entity.dart';

class ChatState {
  final int bookingId;
  final List<ChatMessageEntity> messages;
  final bool isLoadingHistory;
  final bool isClosed;
  final bool shouldNavigateHome;
  final String? closeReason;
  final String? errorMessage;

  const ChatState({
    required this.bookingId,
    this.messages = const [],
    this.isLoadingHistory = false,
    this.isClosed = false,
    this.shouldNavigateHome = false,
    this.closeReason,
    this.errorMessage,
  });

  ChatState copyWith({
    int? bookingId,
    List<ChatMessageEntity>? messages,
    bool? isLoadingHistory,
    bool? isClosed,
    bool? shouldNavigateHome,
    String? closeReason,
    String? errorMessage,
  }) {
    return ChatState(
      bookingId: bookingId ?? this.bookingId,
      messages: messages ?? this.messages,
      isLoadingHistory: isLoadingHistory ?? this.isLoadingHistory,
      isClosed: isClosed ?? this.isClosed,
      shouldNavigateHome: shouldNavigateHome ?? this.shouldNavigateHome,
      closeReason: closeReason ?? this.closeReason,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
