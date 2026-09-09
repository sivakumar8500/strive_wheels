import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';

class SettingsRowData {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onTap;
  final bool isSwitch;
  final bool switchValue;
  final ValueChanged<bool>? onSwitchChanged;

  const SettingsRowData({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.onTap,
    this.isSwitch = false,
    this.switchValue = false,
    this.onSwitchChanged,
  });
}

class SettingsGroupCard extends StatelessWidget {
  final String categoryTitle;
  final List<SettingsRowData> rows;

  const SettingsGroupCard({
    super.key,
    required this.categoryTitle,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.cardBgDark : Colors.white;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category Heading (e.g. ACCOUNT, PREFERENCES)
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            categoryTitle.toUpperCase(),
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.onboardingTextSecondaryLight,
            ),
          ),
        ),

        // Rounded Menu Card
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: List.generate(rows.length, (index) {
              final rowData = rows[index];
              final isLast = index == rows.length - 1;

              return Column(
                children: [
                  InkWell(
                    key: Key('settings_item_${rowData.title}'),
                    onTap: rowData.isSwitch ? null : rowData.onTap,
                    borderRadius: BorderRadius.vertical(
                      top: index == 0 ? const Radius.circular(20) : Radius.zero,
                      bottom: isLast ? const Radius.circular(20) : Radius.zero,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          // Left Icon Container Badge
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF1E293B)
                                  : const Color(0xFFEEF2FF),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              rowData.icon,
                              color: AppColors.primaryBlue,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 14),

                          // Title and Subtitle
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  rowData.title,
                                  style: GoogleFonts.inter(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: isDark
                                        ? AppColors.white
                                        : AppColors.onboardingTextPrimaryLight,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  rowData.subtitle,
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: isDark
                                        ? AppColors.textSecondaryDark
                                        : AppColors.onboardingTextSecondaryLight,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Trailing Switch or Chevron
                          if (rowData.isSwitch)
                            Switch(
                              key: Key('settings_switch_${rowData.title}'),
                              value: rowData.switchValue,
                              onChanged: rowData.onSwitchChanged,
                              activeColor: AppColors.primaryBlue,
                              activeTrackColor: AppColors.primaryBlue.withValues(alpha: 0.4),
                            )
                          else
                            Icon(
                              Icons.chevron_right_rounded,
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.onboardingTextSecondaryLight,
                              size: 20,
                            ),
                        ],
                      ),
                    ),
                  ),

                  // Divider between rows
                  if (!isLast)
                    Divider(
                      height: 1,
                      thickness: 1,
                      indent: 72,
                      endIndent: 16,
                      color: isDark
                          ? const Color(0xFF334155)
                          : const Color(0xFFF1F5F9),
                    ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}
