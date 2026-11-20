import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_contacts/flutter_contacts.dart' as fc;
import '../../domain/entities/permissions_entity.dart';
import '../../domain/usecases/get_permissions_usecase.dart';
import '../../domain/usecases/save_permissions_usecase.dart';
import 'permissions_event.dart';
import 'permissions_state.dart';

class PermissionsBloc extends Bloc<PermissionsEvent, PermissionsState> {
  final GetPermissionsUseCase getPermissionsUseCase;
  final SavePermissionsUseCase savePermissionsUseCase;

  PermissionsBloc({
    required this.getPermissionsUseCase,
    required this.savePermissionsUseCase,
  }) : super(const PermissionsState()) {
    on<LoadPermissionsEvent>(_onLoadPermissions);
    on<ToggleNotificationEvent>(_onToggleNotification);
    on<ToggleContactsEvent>(_onToggleContacts);
    on<ToggleLocationEvent>(_onToggleLocation);
    on<SubmitPermissionsEvent>(_onSubmitPermissions);
  }

  Future<void> _onLoadPermissions(
    LoadPermissionsEvent event,
    Emitter<PermissionsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final permissions = await getPermissionsUseCase();
      emit(state.copyWith(
        isLoading: false,
        notificationsAllowed: permissions.notificationsAllowed,
        contactsAllowed: permissions.contactsAllowed,
        locationAllowed: permissions.locationAllowed,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load permissions: $e',
      ));
    }
  }

  Future<void> _onToggleNotification(
    ToggleNotificationEvent event,
    Emitter<PermissionsState> emit,
  ) async {
    if (event.value) {
      final status = await Permission.notification.request();
      emit(state.copyWith(notificationsAllowed: status.isGranted));
    } else {
      emit(state.copyWith(notificationsAllowed: false));
    }
  }

  Future<void> _onToggleContacts(
    ToggleContactsEvent event,
    Emitter<PermissionsState> emit,
  ) async {
    if (event.value) {
      final status = await fc.FlutterContacts.permissions.request(fc.PermissionType.readWrite);
      final isGranted = status == fc.PermissionStatus.granted || status == fc.PermissionStatus.limited;
      emit(state.copyWith(contactsAllowed: isGranted));
    } else {
      emit(state.copyWith(contactsAllowed: false));
    }
  }

  Future<void> _onToggleLocation(
    ToggleLocationEvent event,
    Emitter<PermissionsState> emit,
  ) async {
    if (event.value) {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      final isGranted = permission == LocationPermission.whileInUse || 
                        permission == LocationPermission.always;
      emit(state.copyWith(locationAllowed: isGranted));
    } else {
      emit(state.copyWith(locationAllowed: false));
    }
  }

  Future<void> _onSubmitPermissions(
    SubmitPermissionsEvent event,
    Emitter<PermissionsState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true, errorMessage: null));
    try {
      final entity = PermissionsEntity(
        notificationsAllowed: state.notificationsAllowed,
        contactsAllowed: state.contactsAllowed,
        locationAllowed: state.locationAllowed,
      );
      final success = await savePermissionsUseCase(entity);
      if (success) {
        emit(state.copyWith(isSubmitting: false, isSuccess: true));
      } else {
        emit(state.copyWith(
          isSubmitting: false,
          errorMessage: 'Failed to save permissions.',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        errorMessage: 'An error occurred while saving: $e',
      ));
    }
  }
}
