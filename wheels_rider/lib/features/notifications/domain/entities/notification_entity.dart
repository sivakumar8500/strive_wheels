import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_entity.freezed.dart';

@freezed
abstract class NotificationEntity with _$NotificationEntity {
  const factory NotificationEntity({
    required int id,
    required int userId,
    required String title,
    required String body,
    required String notificationType,
    required bool isRead,
    String? metadataJson,
    required DateTime createdAt,
  }) = _NotificationEntity;
}
