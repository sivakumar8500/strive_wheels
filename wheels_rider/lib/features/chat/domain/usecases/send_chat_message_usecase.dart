import '../entities/chat_message_entity.dart';
import '../repositories/chat_repository.dart';

class SendChatMessageUseCase {
  final ChatRepository repository;

  SendChatMessageUseCase(this.repository);

  Future<ChatMessageEntity?> call({
    required int bookingId,
    required String message,
  }) {
    return repository.sendMessage(bookingId: bookingId, message: message);
  }
}
