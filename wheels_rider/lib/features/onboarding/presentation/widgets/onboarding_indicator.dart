import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// Reusable Page Indicator Widget for Onboarding screens.
class OnboardingIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;

  const OnboardingIndicator({
    super.key,
    required this.count,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final inactiveColor = isDark
        ? AppColors.indicatorInactiveDark
        : AppColors.indicatorInactiveLight;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (index) {
        final isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.only(right: 8),
          height: 7,
          width: isActive ? 26 : 14,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primaryBlue : inactiveColor,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
