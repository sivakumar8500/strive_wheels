import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';

class LogoutButton extends StatelessWidget {
  final VoidCallback onLogoutTap;

  const LogoutButton({
    super.key,
    required this.onLogoutTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF3F1D24) : AppColors.logoutBgLight;

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        key: const Key('logout_button'),
        onPressed: onLogoutTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: AppColors.logoutText,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.logout_rounded,
              color: AppColors.logoutText,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              AppStrings.logout,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.logoutText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
