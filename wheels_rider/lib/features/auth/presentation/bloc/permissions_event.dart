import 'package:flutter/foundation.dart';

@immutable
abstract class PermissionsEvent {
  const PermissionsEvent();
}

class RequestAllPermissions extends PermissionsEvent {}

class CheckPermissionsStatus extends PermissionsEvent {}
