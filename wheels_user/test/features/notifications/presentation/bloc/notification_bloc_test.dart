import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/notifications/domain/entities/notification_permission_entity.dart';
import 'package:wheels_user/features/notifications/domain/usecases/request_notification_permission_usecase.dart';
import 'package:wheels_user/features/notifications/presentation/bloc/notification_bloc.dart';
import 'package:wheels_user/features/notifications/presentation/bloc/notification_event.dart';
import 'package:wheels_user/features/notifications/presentation/bloc/notification_state.dart';

class MockRequestNotificationPermissionUseCase extends Mock
    implements RequestNotificationPermissionUseCase {}

void main() {
  late NotificationBloc notificationBloc;
  late MockRequestNotificationPermissionUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockRequestNotificationPermissionUseCase();
    notificationBloc = NotificationBloc(requestPermissionUseCase: mockUseCase);
    registerFallbackValue(
      const NotificationPermissionEntity(isEnabled: true),
    );
  });

  tearDown(() {
    notificationBloc.close();
  });

  test('initial state has false for all flags', () {
    expect(notificationBloc.state.isSubmitting, isFalse);
    expect(notificationBloc.state.isPermissionGranted, isFalse);
    expect(notificationBloc.state.isSkipped, isFalse);
  });

  blocTest<NotificationBloc, NotificationState>(
    'emits isSubmitting true and then isPermissionGranted true on EnableNotificationsEvent',
    build: () {
      when(() => mockUseCase(any())).thenAnswer((_) async => true);
      return notificationBloc;
    },
    act: (bloc) => bloc.add(const EnableNotificationsEvent()),
    expect: () => [
      const NotificationState(isSubmitting: true),
      const NotificationState(isSubmitting: false, isPermissionGranted: true),
    ],
  );

  blocTest<NotificationBloc, NotificationState>(
    'emits isSubmitting true and then isSkipped true on SkipNotificationsEvent',
    build: () {
      when(() => mockUseCase(any())).thenAnswer((_) async => true);
      return notificationBloc;
    },
    act: (bloc) => bloc.add(const SkipNotificationsEvent()),
    expect: () => [
      const NotificationState(isSubmitting: true),
      const NotificationState(isSubmitting: false, isSkipped: true),
    ],
  );

  blocTest<NotificationBloc, NotificationState>(
    'emits errorMessage when enable notifications fails',
    build: () {
      when(() => mockUseCase(any())).thenAnswer((_) async => false);
      return notificationBloc;
    },
    act: (bloc) => bloc.add(const EnableNotificationsEvent()),
    expect: () => [
      const NotificationState(isSubmitting: true),
      const NotificationState(
        isSubmitting: false,
        errorMessage: 'Failed to update notification settings.',
      ),
    ],
  );
}
