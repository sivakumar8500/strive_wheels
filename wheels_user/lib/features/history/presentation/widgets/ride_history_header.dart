import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';

class RideHistoryHeader extends StatelessWidget {
  final VoidCallback? onFilterTap;

  const RideHistoryHeader({
    super.key,
    this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.yourActivity,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryBlue,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          AppStrings.rideHistory,
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
            color: isDark ? AppColors.white : AppColors.onboardingTextPrimaryLight,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          AppStrings.everyTripRightWhereYouNeedIt,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.onboardingTextSecondaryLight,
          ),
        ),
      ],
    );
  }
}
