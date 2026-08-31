class PermissionsEntity {
  final bool notificationsAllowed;
  final bool contactsAllowed;
  final bool locationAllowed;

  const PermissionsEntity({
    required this.notificationsAllowed,
    required this.contactsAllowed,
    required this.locationAllowed,
  });
}
