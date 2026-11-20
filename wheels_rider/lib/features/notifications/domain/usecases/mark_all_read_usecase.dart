import '../repositories/notification_repository.dart';

class MarkAllReadUseCase {
  final NotificationRepository repository;

  MarkAllReadUseCase(this.repository);

  Future<int> call() async {
    return await repository.markAllAsRead();
  }
}
