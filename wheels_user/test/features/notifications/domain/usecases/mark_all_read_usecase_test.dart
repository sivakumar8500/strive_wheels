import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/notifications/domain/repositories/notification_repository.dart';
import 'package:wheels_user/features/notifications/domain/usecases/mark_all_read_usecase.dart';

class MockNotificationRepository extends Mock implements NotificationRepository {}

void main() {
  late MarkAllReadUseCase useCase;
  late MockNotificationRepository mockRepository;

  setUp(() {
    mockRepository = MockNotificationRepository();
    useCase = MarkAllReadUseCase(mockRepository);
  });

  test('MarkAllReadUseCase marks all notifications read in repository', () async {
    when(() => mockRepository.markAllAsRead()).thenAnswer((_) async => 3);

    final result = await useCase();

    expect(result, 3);
    verify(() => mockRepository.markAllAsRead()).called(1);
  });
}
