import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/permissions_entity.dart';

part 'permissions_model.freezed.dart';
part 'permissions_model.g.dart';

@freezed
abstract class PermissionsModel with _$PermissionsModel implements PermissionsEntity {
  const PermissionsModel._();

  const factory PermissionsModel({
    @Default(false) bool notificationsAllowed,
    @Default(false) bool contactsAllowed,
    @Default(false) bool locationAllowed,
  }) = _PermissionsModel;

  factory PermissionsModel.fromJson(Map<String, dynamic> json) =>
      _$PermissionsModelFromJson(json);
}
