import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// Reusable Next Navigation Button for Onboarding screens.
class OnboardingNavButton extends StatelessWidget {
  final VoidCallback onTap;

  const OnboardingNavButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primaryBlue,
      shape: const CircleBorder(),
      elevation: 4,
      shadowColor: AppColors.primaryBlue.withValues(alpha: 0.4),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: const SizedBox(
          width: 56,
          height: 56,
          child: Icon(Icons.chevron_right, color: AppColors.white, size: 28),
        ),
      ),
    );
  }
}
