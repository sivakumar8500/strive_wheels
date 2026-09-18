import '../../domain/entities/chat_message_entity.dart';

class ChatMessageModel {
  final int id;
  final int bookingId;
  final int senderId;
  final String senderRole;
  final String message;
  final String? sentAt;

  const ChatMessageModel({
    this.id = 0,
    this.bookingId = 0,
    this.senderId = 0,
    this.senderRole = 'RIDER',
    this.message = '',
    this.sentAt,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: (json['id'] as num?)?.toInt() ?? (json['message_id'] as num?)?.toInt() ?? 0,
      bookingId: (json['booking_id'] as num?)?.toInt() ?? (json['bookingId'] as num?)?.toInt() ?? 0,
      senderId: (json['sender_id'] as num?)?.toInt() ?? (json['senderId'] as num?)?.toInt() ?? 0,
      senderRole: (json['sender_role'] ?? json['senderRole'] ?? 'RIDER').toString(),
      message: (json['message'] ?? json['text'] ?? '').toString(),
      sentAt: (json['sent_at'] ?? json['created_at'] ?? json['sentAt'])?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'booking_id': bookingId,
        'sender_id': senderId,
        'sender_role': senderRole,
        'message': message,
        'sent_at': sentAt,
      };

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
