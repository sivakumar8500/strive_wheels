import 'package:freezed_annotation/freezed_annotation.dart';

part 'permissions_event.freezed.dart';

@freezed
abstract class PermissionsEvent with _$PermissionsEvent {
  const PermissionsEvent._();

  const factory PermissionsEvent.loadPermissions() = LoadPermissionsEvent;
  const factory PermissionsEvent.toggleNotification(bool value) = ToggleNotificationEvent;
  const factory PermissionsEvent.toggleContacts(bool value) = ToggleContactsEvent;
  const factory PermissionsEvent.toggleLocation(bool value) = ToggleLocationEvent;
  const factory PermissionsEvent.submitPermissions() = SubmitPermissionsEvent;
}
