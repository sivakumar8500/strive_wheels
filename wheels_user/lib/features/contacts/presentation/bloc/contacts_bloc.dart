import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/contacts_permission_entity.dart';
import '../../domain/usecases/request_contacts_permission_usecase.dart';
import 'contacts_event.dart';
import 'contacts_state.dart';

class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
  final RequestContactsPermissionUseCase requestPermissionUseCase;

  ContactsBloc({required this.requestPermissionUseCase})
      : super(const ContactsState()) {
    on<AllowContactsEvent>(_onAllowContacts);
    on<SkipContactsEvent>(_onSkipContacts);
  }

  Future<void> _onAllowContacts(
    AllowContactsEvent event,
    Emitter<ContactsState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true, errorMessage: null));

    try {
      final success = await requestPermissionUseCase(
        const ContactsPermissionEntity(isEnabled: true),
      );

      if (success) {
        emit(state.copyWith(
          isSubmitting: false,
          isPermissionGranted: true,
        ));
      } else {
        emit(state.copyWith(
          isSubmitting: false,
          errorMessage: 'Failed to update contacts permission settings.',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        errorMessage: 'An unexpected error occurred.',
      ));
    }
  }

  Future<void> _onSkipContacts(
    SkipContactsEvent event,
    Emitter<ContactsState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true, errorMessage: null));

    try {
      await requestPermissionUseCase(
        const ContactsPermissionEntity(isEnabled: false),
      );

      emit(state.copyWith(
        isSubmitting: false,
        isSkipped: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        isSkipped: true,
      ));
    }
  }
}
