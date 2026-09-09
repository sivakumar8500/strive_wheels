import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';

/// Centralized, reusable primary button widget matching design guidelines.
class AppButton extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final bool isLoading;
  final bool isEnabled;
  final double? width;
  final double height;
  final double borderRadius;

  const AppButton({
    super.key,
    required this.title,
    this.onTap,
    this.isLoading = false,
    this.isEnabled = true,
    this.width,
    this.height = 56.0,
    this.borderRadius = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeBg = AppColors.primaryBlue;
    final activeText = AppColors.white;

    final disabledBg = isDark
        ? AppColors.indicatorInactiveDark
        : AppColors.indicatorInactiveLight;
    final disabledText = isDark
        ? AppColors.textSecondaryDark
        : AppColors.onboardingTextSecondaryLight;

    final backgroundColor = isEnabled ? activeBg : disabledBg;
    final textColor = isEnabled ? activeText : disabledText;

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: (isEnabled && !isLoading) ? onTap : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          disabledBackgroundColor: disabledBg,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
        ),
        child: isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(textColor),
                ),
              )
            : Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
      ),
    );
  }
}
