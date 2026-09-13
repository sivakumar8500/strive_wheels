import '../entities/chat_message_entity.dart';

abstract class ChatRepository {
  Future<List<ChatMessageEntity>> getChatHistory(int bookingId);
  Future<ChatMessageEntity?> sendMessage({required int bookingId, required String message});
  Stream<Map<String, dynamic>> listenChatEvents(int bookingId);
}
