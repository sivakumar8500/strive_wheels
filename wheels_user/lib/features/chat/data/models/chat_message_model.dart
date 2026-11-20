import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/chat_message_entity.dart';

part 'chat_message_model.freezed.dart';
part 'chat_message_model.g.dart';

@freezed
abstract class ChatMessageModel with _$ChatMessageModel {
  const factory ChatMessageModel({
    @Default(0) int id,
    @JsonKey(name: 'booking_id') @Default(0) int bookingId,
    @JsonKey(name: 'sender_id') @Default(0) int senderId,
    @JsonKey(name: 'sender_role') @Default('CUSTOMER') String senderRole,
    @Default('') String message,
    @JsonKey(name: 'sent_at') String? sentAt,
  }) = _ChatMessageModel;

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) =>
      ChatMessageModel.fromFlexibleJson(json);

  static ChatMessageModel fromFlexibleJson(Map<String, dynamic> json) {
    Map<String, dynamic> raw = json;
    if (raw['data'] is Map<String, dynamic>) {
      raw = raw['data'] as Map<String, dynamic>;
    } else if (raw['chat'] is Map<String, dynamic>) {
      raw = raw['chat'] as Map<String, dynamic>;
    } else if (raw['message_data'] is Map<String, dynamic>) {
      raw = raw['message_data'] as Map<String, dynamic>;
    }

    final id = (raw['id'] is num)
        ? (raw['id'] as num).toInt()
        : (int.tryParse(raw['id']?.toString() ?? '') ?? 0);

    final bookingId = (raw['booking_id'] is num)
        ? (raw['booking_id'] as num).toInt()
        : (raw['bookingId'] is num)
            ? (raw['bookingId'] as num).toInt()
            : (int.tryParse(raw['booking_id']?.toString() ?? raw['bookingId']?.toString() ?? '') ?? 0);

    final senderId = (raw['sender_id'] is num)
        ? (raw['sender_id'] as num).toInt()
        : (raw['senderId'] is num)
            ? (raw['senderId'] as num).toInt()
            : (raw['user_id'] is num)
                ? (raw['user_id'] as num).toInt()
                : (int.tryParse(raw['sender_id']?.toString() ?? raw['senderId']?.toString() ?? raw['user_id']?.toString() ?? '') ?? 0);

    final senderRole = (raw['sender_role'] ?? raw['senderRole'] ?? raw['role'] ?? raw['sender_type'] ?? raw['type'] ?? 'CUSTOMER').toString();

    final message = (raw['message'] ?? raw['text'] ?? raw['content'] ?? raw['msg'] ?? raw['body'] ?? '').toString();

    final sentAtStr = (raw['sent_at'] ?? raw['sentAt'] ?? raw['created_at'] ?? raw['createdAt'] ?? raw['timestamp'] ?? raw['time'])?.toString();

    return ChatMessageModel(
      id: id,
      bookingId: bookingId,
      senderId: senderId,
      senderRole: senderRole,
      message: message,
      sentAt: sentAtStr,
    );
  }
}

extension ChatMessageModelX on ChatMessageModel {
  ChatMessageEntity toEntity() => ChatMessageEntity(
        id: id,
        bookingId: bookingId,
        senderId: senderId,
        senderRole: senderRole.toUpperCase(),
        message: message,
        sentAt: sentAt != null && sentAt!.isNotEmpty
            ? (DateTime.tryParse(sentAt!) ?? DateTime.now())
            : DateTime.now(),
      );
}
