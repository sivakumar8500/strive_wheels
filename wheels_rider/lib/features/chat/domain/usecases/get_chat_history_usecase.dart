import '../entities/chat_message_entity.dart';
import '../repositories/chat_repository.dart';

class GetChatHistoryUseCase {
  final ChatRepository repository;

  GetChatHistoryUseCase(this.repository);

  Future<List<ChatMessageEntity>> call(int bookingId) {
    return repository.getChatHistory(bookingId);
  }
}
