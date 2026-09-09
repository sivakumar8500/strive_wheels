import 'package:freezed_annotation/freezed_annotation.dart';

part 'earnings_entity.freezed.dart';

@freezed
abstract class EarningsActivityEntity with _$EarningsActivityEntity {
  const factory EarningsActivityEntity({
    required String id,
    required String type,
    required String title,
    required String subtitle,
    required double amount,
    required DateTime timestamp,
  }) = _EarningsActivityEntity;
}

@freezed
abstract class EarningsEntity with _$EarningsEntity {
  const factory EarningsEntity({
    required double totalEarnings,
    required int trips,
    required double hours,
    required double rating,
    required List<EarningsActivityEntity> recentActivities,
  }) = _EarningsEntity;
}
