// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatMessageModel _$ChatMessageModelFromJson(Map<String, dynamic> json) =>
    _ChatMessageModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      bookingId: (json['booking_id'] as num?)?.toInt() ?? 0,
      senderId: (json['sender_id'] as num?)?.toInt() ?? 0,
      senderRole: json['sender_role'] as String? ?? 'CUSTOMER',
      message: json['message'] as String? ?? '',
      sentAt: json['sent_at'] as String?,
    );

Map<String, dynamic> _$ChatMessageModelToJson(_ChatMessageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'booking_id': instance.bookingId,
      'sender_id': instance.senderId,
      'sender_role': instance.senderRole,
      'message': instance.message,
      'sent_at': instance.sentAt,
    };
