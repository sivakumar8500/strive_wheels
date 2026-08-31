import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/earnings_entity.dart';

part 'earnings_model.freezed.dart';
part 'earnings_model.g.dart';

@freezed
abstract class EarningsActivityModel with _$EarningsActivityModel {
  const EarningsActivityModel._();

  const factory EarningsActivityModel({
    required String id,
    required String type,
    required String title,
    required String subtitle,
    required double amount,
    required DateTime timestamp,
  }) = _EarningsActivityModel;

  factory EarningsActivityModel.fromJson(Map<String, dynamic> json) => _$EarningsActivityModelFromJson(json);

  EarningsActivityEntity toEntity() {
    return EarningsActivityEntity(
      id: id,
      type: type,
      title: title,
      subtitle: subtitle,
      amount: amount,
      timestamp: timestamp,
    );
  }
}

@freezed
abstract class EarningsModel with _$EarningsModel {
  const EarningsModel._();

  const factory EarningsModel({
    @JsonKey(name: 'total_earnings') required double totalEarnings,
    required int trips,
    required double hours,
    required double rating,
    @JsonKey(name: 'recent_activities') required List<EarningsActivityModel> recentActivities,
  }) = _EarningsModel;

  factory EarningsModel.fromJson(Map<String, dynamic> json) => _$EarningsModelFromJson(json);

  EarningsEntity toEntity() {
    return EarningsEntity(
      totalEarnings: totalEarnings,
      trips: trips,
      hours: hours,
      rating: rating,
      recentActivities: recentActivities.map((e) => e.toEntity()).toList(),
    );
  }
}
