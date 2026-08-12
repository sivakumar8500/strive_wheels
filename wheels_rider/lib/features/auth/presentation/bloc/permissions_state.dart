import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

@immutable
abstract class PermissionsState {
  const PermissionsState();
}

class PermissionsInitial extends PermissionsState {}

class PermissionsLoading extends PermissionsState {}

class PermissionsStatusUpdated extends PermissionsState {
  final Map<Permission, PermissionStatus> statuses;
  final bool allGranted;

  const PermissionsStatusUpdated({
    required this.statuses,
    required this.allGranted,
  });
}

class PermissionsError extends PermissionsState {
  final String message;

  const PermissionsError(this.message);
}
