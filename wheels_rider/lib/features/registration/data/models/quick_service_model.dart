import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/quick_service.dart';

part 'quick_service_model.freezed.dart';

@freezed
abstract class QuickServiceModel with _$QuickServiceModel {
  const factory QuickServiceModel({
    required int id,
    required String title,
    required String subtitle,
    @JsonKey(name: 'icon_url') required String iconUrl,
    @JsonKey(name: 'service_code') required String serviceCode,
    @JsonKey(name: 'display_order') required int displayOrder,
    @JsonKey(name: 'is_active') required bool isActive,
    @JsonKey(name: 'created_at') required String createdAt,
  }) = _QuickServiceModel;

  factory QuickServiceModel.fromJson(Map<String, dynamic> json) {
    return QuickServiceModel(
      id: json['id'] as int? ?? 0,
      title: (json['name'] ?? json['title'] ?? '') as String,
      subtitle: (json['description'] ?? json['subtitle'] ?? '') as String,
      iconUrl: (json['icon_url'] ?? '') as String,
      serviceCode: (json['code'] ?? json['service_code'] ?? '') as String,
      displayOrder: (json['display_order'] ?? 0) as int,
      isActive: (json['is_active'] ?? true) as bool,
      createdAt: (json['created_at'] ?? '') as String,
    );
  }
}

extension QuickServiceModelX on QuickServiceModel {
  QuickService toEntity() {
    return QuickService(
      id: id,
      title: title,
      subtitle: subtitle,
      iconUrl: iconUrl,
      serviceCode: serviceCode,
      displayOrder: displayOrder,
      isActive: isActive,
      createdAt: createdAt,
    );
  }
}
