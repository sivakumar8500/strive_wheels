import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/home_dashboard_entity.dart';

part 'home_dashboard_model.freezed.dart';
part 'home_dashboard_model.g.dart';

/// Freezed Model for Home Dashboard matching strict project guidelines.
@freezed
abstract class HomeDashboardModel with _$HomeDashboardModel {
  const factory HomeDashboardModel({
    required String userName,
    required String greetingTitle,
    required String greetingSubtitle,
    required String recentRideTitle,
    required String recentRideDetails,
    @Default(0) int selectedNavIndex,
  }) = _HomeDashboardModel;

  factory HomeDashboardModel.fromJson(Map<String, dynamic> json) =>
      _$HomeDashboardModelFromJson(json);
}

extension HomeDashboardModelX on HomeDashboardModel {
  HomeDashboardEntity toEntity() => HomeDashboardEntity(
        userName: userName,
        greetingTitle: greetingTitle,
        greetingSubtitle: greetingSubtitle,
        recentRideTitle: recentRideTitle,
        recentRideDetails: recentRideDetails,
        selectedNavIndex: selectedNavIndex,
      );
}
