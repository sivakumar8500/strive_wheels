import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/dotted_divider.dart';

/// Location List Item widget matching reference UI design with leading icon,
/// title, address, trailing heart icon, and bottom dotted separator.
class LocationListItem extends StatelessWidget {
  final String title;
  final String address;
  final bool isFavorite;
  final bool isHistory;
  final VoidCallback? onTap;
  final VoidCallback? onHeartTap;
  final bool showDivider;

  const LocationListItem({
    super.key,
    required this.title,
    required this.address,
    this.isFavorite = false,
    this.isHistory = true,
    this.onTap,
    this.onHeartTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark ? AppColors.white : const Color(0xFF0F172A);
    final secondaryTextColor = isDark
        ? AppColors.textSecondaryDark
        : const Color(0xFF64748B);
    final iconColor = isDark
        ? AppColors.textSecondaryDark
        : const Color(0xFF64748B);

    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 1. Leading Icon (Clock for History, Location pin for Favorite)
                Icon(
                  isHistory
                      ? Icons.access_time_rounded
                      : Icons.location_on_outlined,
                  color: iconColor,
                  size: 22,
                ),
                const SizedBox(width: 16),

                // 2. Center Content (Title & Subtitle)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: primaryTextColor,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        address,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // 3. Trailing Heart Button (Toggle Favorite)
                IconButton(
                  icon: Icon(
                    isFavorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: isFavorite
                        ? const Color(0xFFD9531E) // Terracotta/orange heart
                        : iconColor,
                    size: 22,
                  ),
                  onPressed: onHeartTap,
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.all(6),
                  tooltip: isFavorite ? 'Remove favorite' : 'Add favorite',
                ),
              ],
            ),
          ),

          // 4. Dotted separator line across item bottom
          if (showDivider)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: DottedDivider(
                dashWidth: 4.0,
                dashSpace: 3.0,
                thickness: 1.0,
              ),
            ),
        ],
      ),
    );
  }
}
