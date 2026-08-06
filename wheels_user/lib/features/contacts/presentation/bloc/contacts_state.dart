import 'package:freezed_annotation/freezed_annotation.dart';

part 'contacts_state.freezed.dart';

@freezed
abstract class ContactsState with _$ContactsState {
  const ContactsState._();

  const factory ContactsState({
    @Default(false) bool isSubmitting,
    @Default(false) bool isPermissionGranted,
    @Default(false) bool isSkipped,
    String? errorMessage,
  }) = _ContactsState;
}
