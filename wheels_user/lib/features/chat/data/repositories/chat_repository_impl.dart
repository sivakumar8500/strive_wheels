import 'dart:async';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_datasource.dart';
import '../models/chat_message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ChatMessageEntity>> getChatHistory(int bookingId) async {
    final models = await remoteDataSource.getChatHistory(bookingId);
    final entities = models.map((m) => m.toEntity()).toList();
    entities.sort((a, b) => a.sentAt.compareTo(b.sentAt));
    return entities;
  }

  @override
  Future<ChatMessageEntity?> sendMessage({
    required int bookingId,
    required String message,
  }) async {
    // 1. Primary: Send via WebSocket
    remoteDataSource.sendMessageWs(bookingId, message);

    // 2. HTTP fallback / immediate confirmation option
    final httpModel = await remoteDataSource.sendMessageHttp(bookingId, message);
    if (httpModel != null) {
      return httpModel.toEntity();
    }
    return null;
  }

  @override
  Stream<Map<String, dynamic>> listenChatEvents(int bookingId) {
    return remoteDataSource.listenChatEvents(bookingId);
  }
}
