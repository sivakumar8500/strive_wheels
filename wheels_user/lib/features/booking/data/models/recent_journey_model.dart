import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/recent_journey_entity.dart';

part 'recent_journey_model.freezed.dart';
part 'recent_journey_model.g.dart';

@freezed
abstract class RecentJourneyModel with _$RecentJourneyModel {
  const factory RecentJourneyModel({
    required String id,
    required String title,
    required String origin,
    required String timestamp,
    required String iconType,
  }) = _RecentJourneyModel;

  factory RecentJourneyModel.fromJson(Map<String, dynamic> json) =>
      _$RecentJourneyModelFromJson(json);
}

extension RecentJourneyModelX on RecentJourneyModel {
  RecentJourneyEntity toEntity() => RecentJourneyEntity(
        id: id,
        title: title,
        origin: origin,
        timestamp: timestamp,
        iconType: iconType,
      );
}
