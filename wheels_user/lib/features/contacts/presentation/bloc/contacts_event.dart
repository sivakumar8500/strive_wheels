import 'package:freezed_annotation/freezed_annotation.dart';

part 'contacts_event.freezed.dart';

@freezed
class ContactsEvent with _$ContactsEvent {
  const factory ContactsEvent.allowContacts() = AllowContactsEvent;
  const factory ContactsEvent.skipContacts() = SkipContactsEvent;
}
