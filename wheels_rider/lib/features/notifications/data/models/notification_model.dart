import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/notification_entity.dart';

part 'notification_model.freezed.dart';

@freezed
abstract class NotificationModel with _$NotificationModel {
  const NotificationModel._();

  const factory NotificationModel({
    required int id,
    required int userId,
    required String title,
    required String body,
    required String notificationType,
    required bool isRead,
    String? metadataJson,
    required DateTime createdAt,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic val, int defaultVal) {
      if (val == null) return defaultVal;
      if (val is int) return val;
      if (val is num) return val.toInt();
      return int.tryParse(val.toString()) ?? defaultVal;
    }

    final idVal = parseInt(json['id'], 0);
    final userIdVal = parseInt(json['user_id'] ?? json['userId'], 0);
    final titleVal = (json['title'] ?? 'Notification').toString();
    final bodyVal = (json['body'] ?? json['message'] ?? '').toString();
    final typeVal = (json['notification_type'] ?? json['type'] ?? 'SYSTEM').toString().toUpperCase();
    final isReadVal = json['is_read'] == true || json['isRead'] == true || json['read'] == true;
    
    final metaVal = json['metadata_json']?.toString() ?? (json['metadata'] != null ? json['metadata'].toString() : null);

    final rawCreated = json['created_at'] ?? json['createdAt'] ?? json['timestamp'];
    DateTime createdVal = DateTime.now();
    if (rawCreated != null) {
      createdVal = DateTime.tryParse(rawCreated.toString()) ?? DateTime.now();
    }

    return NotificationModel(
      id: idVal,
      userId: userIdVal,
      title: titleVal,
      body: bodyVal,
      notificationType: typeVal,
      isRead: isReadVal,
      metadataJson: metaVal,
      createdAt: createdVal,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'body': body,
      'notification_type': notificationType,
      'is_read': isRead,
      'metadata_json': metadataJson,
      'created_at': createdAt.toIso8601String(),
    };
  }

  NotificationEntity toEntity() {
    return NotificationEntity(
      id: id,
      userId: userId,
      title: title,
      body: body,
      notificationType: notificationType,
      isRead: isRead,
      metadataJson: metadataJson,
      createdAt: createdAt,
    );
  }
}
