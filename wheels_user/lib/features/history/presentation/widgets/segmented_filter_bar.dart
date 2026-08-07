import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';

class SegmentedFilterBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const SegmentedFilterBar({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  static const List<String> _tabs = [
    AppStrings.filterAllTrips,
    AppStrings.filterRides,
    AppStrings.filterDeliveries,
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final containerBg = isDark ? AppColors.filterBgDark : AppColors.filterBgLight;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: containerBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: List.generate(_tabs.length, (index) {
          final isSelected = index == selectedIndex;
          final label = _tabs[index];

          return Expanded(
            child: GestureDetector(
              key: Key('filter_tab_$index'),
              onTap: () => onTabSelected(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isDark ? const Color(0xFF334155) : Colors.white)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                child: Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? (isDark ? AppColors.white : AppColors.primaryBlue)
                        : (isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.onboardingTextSecondaryLight),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
