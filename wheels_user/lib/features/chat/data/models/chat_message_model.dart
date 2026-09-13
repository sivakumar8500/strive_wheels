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
      _$ChatMessageModelFromJson(json);
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
