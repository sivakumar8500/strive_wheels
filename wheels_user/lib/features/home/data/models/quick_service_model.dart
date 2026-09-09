import 'package:freezed_annotation/freezed_annotation.dart';

part 'quick_service_model.freezed.dart';
part 'quick_service_model.g.dart';

@freezed
abstract class QuickServiceModel with _$QuickServiceModel {
  const factory QuickServiceModel({
    required int id,
    required String title,
    required String subtitle,
    @JsonKey(name: 'icon_url') String? iconUrl,
  }) = _QuickServiceModel;

  factory QuickServiceModel.fromJson(Map<String, dynamic> json) =>
      _$QuickServiceModelFromJson(json);
}
