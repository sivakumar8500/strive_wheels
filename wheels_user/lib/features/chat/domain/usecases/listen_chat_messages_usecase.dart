import '../repositories/chat_repository.dart';

class ListenChatMessagesUseCase {
  final ChatRepository repository;

  ListenChatMessagesUseCase(this.repository);

  Stream<Map<String, dynamic>> call(int bookingId) {
    return repository.listenChatEvents(bookingId);
  }
}
