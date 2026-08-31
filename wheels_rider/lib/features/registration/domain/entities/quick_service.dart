import 'package:freezed_annotation/freezed_annotation.dart';

part 'quick_service.freezed.dart';

@freezed
abstract class QuickService with _$QuickService {
  const factory QuickService({
    required int id,
    required String title,
    required String subtitle,
    required String iconUrl,
    required String serviceCode,
    required int displayOrder,
    required bool isActive,
    required String createdAt,
  }) = _QuickService;
}
