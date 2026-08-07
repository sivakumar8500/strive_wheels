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

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Bell Icon Badge Container
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE8F0FE),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.notifications_none_rounded,
            color: AppColors.primaryBlue,
            size: 22,
          ),
        ),
        const SizedBox(width: 14),

        // Headings
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.yourActivity,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryBlue,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                AppStrings.rideHistory,
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                  color: isDark
                      ? AppColors.white
                      : AppColors.onboardingTextPrimaryLight,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                AppStrings.everyTripRightWhereYouNeedIt,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.onboardingTextSecondaryLight,
                ),
              ),
            ],
          ),
        ),

        // Filter Options Button
        InkWell(
          key: const Key('history_filter_options_button'),
          onTap: onFilterTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardBgDark : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.tune_rounded,
              color: isDark ? AppColors.white : AppColors.onboardingTextPrimaryLight,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}
