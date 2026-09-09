import 'package:freezed_annotation/freezed_annotation.dart';

part 'permissions_state.freezed.dart';

@freezed
abstract class PermissionsState with _$PermissionsState {
  const PermissionsState._();

  const factory PermissionsState({
    @Default(false) bool notificationsAllowed,
    @Default(false) bool contactsAllowed,
    @Default(false) bool locationAllowed,
    @Default(false) bool isLoading,
    @Default(false) bool isSubmitting,
    @Default(false) bool isSuccess,
    String? errorMessage,
  }) = _PermissionsState;
}
