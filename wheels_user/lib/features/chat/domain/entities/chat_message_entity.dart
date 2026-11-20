import 'package:flutter/foundation.dart';

@immutable
class ChatMessageEntity {
  final int id;
  final int bookingId;
  final int senderId;
  final String senderRole; // 'CUSTOMER' or 'RIDER'
  final String message;
  final DateTime sentAt;

  const ChatMessageEntity({
    required this.id,
    required this.bookingId,
    required this.senderId,
    required this.senderRole,
    required this.message,
    required this.sentAt,
  });

  bool isSentByMe(int currentUserId) => senderId == currentUserId;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatMessageEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          bookingId == other.bookingId &&
          senderId == other.senderId &&
          senderRole == other.senderRole &&
          message == other.message &&
          sentAt == other.sentAt;

  @override
  int get hashCode =>
      id.hashCode ^
      bookingId.hashCode ^
      senderId.hashCode ^
      senderRole.hashCode ^
      message.hashCode ^
      sentAt.hashCode;
}
