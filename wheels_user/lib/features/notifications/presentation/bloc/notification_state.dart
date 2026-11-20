import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_state.freezed.dart';

@freezed
abstract class NotificationState with _$NotificationState {
  const NotificationState._();

  const factory NotificationState({
    @Default(false) bool isSubmitting,
    @Default(false) bool isPermissionGranted,
    @Default(false) bool isSkipped,
    String? errorMessage,
  }) = _NotificationState;
}
