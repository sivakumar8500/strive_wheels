import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/contacts_permission_entity.dart';

part 'contacts_permission_model.freezed.dart';
part 'contacts_permission_model.g.dart';

@freezed
abstract class ContactsPermissionModel with _$ContactsPermissionModel {
  const ContactsPermissionModel._();

  const factory ContactsPermissionModel({
    required bool isEnabled,
  }) = _ContactsPermissionModel;

  factory ContactsPermissionModel.fromJson(Map<String, dynamic> json) =>
      _$ContactsPermissionModelFromJson(json);

  factory ContactsPermissionModel.fromEntity(ContactsPermissionEntity entity) {
    return ContactsPermissionModel(isEnabled: entity.isEnabled);
  }
}
