import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/notifications/domain/repositories/notification_repository.dart';
import 'package:wheels_user/features/notifications/domain/usecases/mark_notification_read_usecase.dart';

class MockNotificationRepository extends Mock implements NotificationRepository {}

void main() {
  late MarkNotificationReadUseCase useCase;
  late MockNotificationRepository mockRepository;

  setUp(() {
    mockRepository = MockNotificationRepository();
    useCase = MarkNotificationReadUseCase(mockRepository);
  });

  test('MarkNotificationReadUseCase marks notification read in repository', () async {
    when(() => mockRepository.markAsRead(101)).thenAnswer((_) async => true);

    final result = await useCase(101);

    expect(result, true);
    verify(() => mockRepository.markAsRead(101)).called(1);
  });
}
