import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/driver_search_entity.dart';

part 'driver_search_model.freezed.dart';
part 'driver_search_model.g.dart';

@freezed
abstract class DriverSearchModel with _$DriverSearchModel {
  const factory DriverSearchModel({
    required String statusTitle,
    required String statusSubtitle,
    required String estimatedConfirmationText,
    required String orderTime,
    required String scanRadiusText,
    required int activeStepIndex,
  }) = _DriverSearchModel;

  factory DriverSearchModel.fromJson(Map<String, dynamic> json) =>
      _$DriverSearchModelFromJson(json);
}

extension DriverSearchModelX on DriverSearchModel {
  DriverSearchEntity toEntity() {
    return DriverSearchEntity(
      statusTitle: statusTitle,
      statusSubtitle: statusSubtitle,
      estimatedConfirmationText: estimatedConfirmationText,
      orderTime: orderTime,
      scanRadiusText: scanRadiusText,
      activeStepIndex: activeStepIndex,
    );
  }
}
