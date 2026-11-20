import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/notification_permission_entity.dart';
import '../../domain/usecases/request_notification_permission_usecase.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final RequestNotificationPermissionUseCase requestPermissionUseCase;

  NotificationBloc({required this.requestPermissionUseCase})
      : super(const NotificationState()) {
    on<EnableNotificationsEvent>(_onEnableNotifications);
    on<SkipNotificationsEvent>(_onSkipNotifications);
  }

  Future<void> _onEnableNotifications(
    EnableNotificationsEvent event,
    Emitter<NotificationState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true, errorMessage: null));

    try {
      final success = await requestPermissionUseCase(
        const NotificationPermissionEntity(isEnabled: true),
      );

      if (success) {
        emit(state.copyWith(
          isSubmitting: false,
          isPermissionGranted: true,
        ));
      } else {
        emit(state.copyWith(
          isSubmitting: false,
          errorMessage: 'Failed to update notification settings.',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        errorMessage: 'An unexpected error occurred.',
      ));
    }
  }

  Future<void> _onSkipNotifications(
    SkipNotificationsEvent event,
    Emitter<NotificationState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true, errorMessage: null));

    try {
      await requestPermissionUseCase(
        const NotificationPermissionEntity(isEnabled: false),
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
