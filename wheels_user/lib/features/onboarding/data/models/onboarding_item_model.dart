import '../../domain/entities/onboarding_item.dart';

/// Data Model for OnboardingItem.
class OnboardingItemModel extends OnboardingItem {
  const OnboardingItemModel({
    required super.title,
    required super.subtitle,
    required super.imagePath,
  });

  factory OnboardingItemModel.fromJson(Map<String, dynamic> json) {
    return OnboardingItemModel(
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      imagePath: json['imagePath'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'imagePath': imagePath,
    };
  }
}
