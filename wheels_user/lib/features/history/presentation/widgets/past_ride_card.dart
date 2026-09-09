import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/entities/past_ride_item_entity.dart';

class PastRideCard extends StatelessWidget {
  final PastRideItemEntity ride;
  final VoidCallback onBookAgainTap;

  const PastRideCard({
    super.key,
    required this.ride,
    required this.onBookAgainTap,
  });

  IconData _getServiceIcon(String serviceType) {
    switch (serviceType.toLowerCase()) {
      case 'auto':
        return Icons.electric_rickshaw_rounded;
      case 'mini':
      case 'cab':
        return Icons.directions_car_rounded;
      case 'bike':
      default:
        return Icons.two_wheeler_rounded;
    }
  }

  Color _getServiceBgColor(String serviceType) {
    switch (serviceType.toLowerCase()) {
      case 'auto':
        return AppColors.autoServiceBg;
      case 'mini':
      case 'cab':
        return AppColors.miniServiceBg;
      case 'bike':
      default:
        return AppColors.bikeServiceBg;
    }
  }

  Color _getServiceIconColor(String serviceType) {
    switch (serviceType.toLowerCase()) {
      case 'auto':
        return AppColors.autoServiceIcon;
      case 'mini':
      case 'cab':
        return AppColors.miniServiceIcon;
      case 'bike':
      default:
        return AppColors.bikeServiceIcon;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.cardBgDark : Colors.white;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
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
        children: [
          // Top Row: Icon + Title/Date/Status + Amount
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Vehicle Icon Badge
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _getServiceBgColor(ride.serviceType),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  _getServiceIcon(ride.serviceType),
                  color: _getServiceIconColor(ride.serviceType),
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),

              // Title, Subtitle, and Completed Status
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ride.title,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.white
                            : AppColors.onboardingTextPrimaryLight,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      ride.dateAndVehicle,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.onboardingTextSecondaryLight,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Completed Badge Row
                    Row(
                      children: [
                        const Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.completedGreen,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          ride.status,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.completedGreen,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Amount Top Right
              Text(
                ride.amount,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppColors.white
                      : AppColors.onboardingTextPrimaryLight,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Bottom Action Row: Wide "Book again" Pill Button + Right Chevron Button
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    key: Key('book_again_button_${ride.id}'),
                    onPressed: onBookAgainTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFEEF2FF),
                      foregroundColor: AppColors.primaryBlue,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isDark
                              ? const Color(0xFF334155)
                              : const Color(0xFFE0E7FF),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Text(
                      AppStrings.bookAgain,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Chevron Right Button
              InkWell(
                key: Key('ride_details_chevron_${ride.id}'),
                onTap: onBookAgainTap,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF334155)
                          : const Color(0xFFE2E8F0),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.onboardingTextSecondaryLight,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
