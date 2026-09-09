import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';

class RideHistoryTopBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onMenuTap;
  final VoidCallback? onNotificationTap;

  const RideHistoryTopBar({
    super.key,
    this.onMenuTap,
    this.onNotificationTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? AppColors.white : AppColors.onboardingTextPrimaryLight;

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        key: const Key('history_menu_button'),
        icon: Icon(Icons.menu_rounded, color: iconColor),
        onPressed: onMenuTap,
      ),
      title: Text(
        AppStrings.striveHeader,
        style: GoogleFonts.poppins(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryBlue,
        ),
      ),
      centerTitle: false,
      actions: [
        IconButton(
          key: const Key('history_notifications_button'),
          icon: Icon(Icons.notifications_none_rounded, color: iconColor),
          onPressed: onNotificationTap,
        ),
        const SizedBox(width: 4),
      ],
    );
  }
}
