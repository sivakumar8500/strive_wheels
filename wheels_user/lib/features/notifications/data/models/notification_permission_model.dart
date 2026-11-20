import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/notification_permission_entity.dart';

part 'notification_permission_model.freezed.dart';
part 'notification_permission_model.g.dart';

@freezed
abstract class NotificationPermissionModel with _$NotificationPermissionModel {
  const NotificationPermissionModel._();

  const factory NotificationPermissionModel({
    required bool isEnabled,
  }) = _NotificationPermissionModel;

  factory NotificationPermissionModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationPermissionModelFromJson(json);

  factory NotificationPermissionModel.fromEntity(NotificationPermissionEntity entity) {
    return NotificationPermissionModel(isEnabled: entity.isEnabled);
  }
}
