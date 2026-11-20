import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/notifications/domain/entities/notification_entity.dart';
import 'package:wheels_user/features/notifications/domain/repositories/notification_repository.dart';
import 'package:wheels_user/features/notifications/domain/usecases/get_notifications_usecase.dart';

class MockNotificationRepository extends Mock implements NotificationRepository {}

void main() {
  late GetNotificationsUseCase useCase;
  late MockNotificationRepository mockRepository;

  setUp(() {
    mockRepository = MockNotificationRepository();
    useCase = GetNotificationsUseCase(mockRepository);
  });

  final testEntity = NotificationEntity(
    id: 1,
    userId: 1,
    title: 'Ride Confirmed',
    body: 'Driver is on the way',
    notificationType: 'BOOKING',
    isRead: false,
    createdAt: DateTime.now(),
  );

  test('GetNotificationsUseCase retrieves notifications from repository', () async {
    when(() => mockRepository.getNotifications(limit: 50, skip: 0))
        .thenAnswer((_) async => [testEntity]);

    final result = await useCase(limit: 50, skip: 0);

    expect(result.length, 1);
    expect(result.first.title, 'Ride Confirmed');
    verify(() => mockRepository.getNotifications(limit: 50, skip: 0)).called(1);
  });
}
