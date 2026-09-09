import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/entities/favorite_place_entity.dart';

class FavoritePlaceCard extends StatelessWidget {
  final FavoritePlaceEntity place;
  final VoidCallback onRideHereTap;

  const FavoritePlaceCard({
    super.key,
    required this.place,
    required this.onRideHereTap,
  });

  IconData _getPlaceIcon(String iconType) {
    switch (iconType.toLowerCase()) {
      case 'office':
      case 'work':
        return Icons.work_outline_rounded;
      case 'airport':
      case 'flight':
        return Icons.flight_outlined;
      case 'metro':
      case 'train':
        return Icons.directions_subway_outlined;
      case 'home':
      default:
        return Icons.home_outlined;
    }
  }

  Color _getPlaceIconBg(String iconType) {
    switch (iconType.toLowerCase()) {
      case 'office':
      case 'work':
        return AppColors.autoServiceBg; // Light green
      case 'airport':
      case 'flight':
        return AppColors.airportServiceBg; // Light orange/yellow
      case 'metro':
      case 'train':
        return AppColors.corporateServiceBg; // Light purple
      case 'home':
      default:
        return AppColors.bikeServiceBg; // Light blue
    }
  }

  Color _getPlaceIconColor(String iconType) {
    switch (iconType.toLowerCase()) {
      case 'office':
      case 'work':
        return AppColors.autoServiceIcon;
      case 'airport':
      case 'flight':
        return AppColors.airportServiceIcon;
      case 'metro':
      case 'train':
        return AppColors.corporateServiceIcon;
      case 'home':
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
      margin: const EdgeInsets.only(bottom: 14),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Icon Badge Container
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _getPlaceIconBg(place.iconType),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              _getPlaceIcon(place.iconType),
              color: _getPlaceIconColor(place.iconType),
              size: 24,
            ),
          ),
          const SizedBox(width: 14),

          // Title, Address, and "Ride here" Pill Button
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  place.title,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.white
                        : AppColors.onboardingTextPrimaryLight,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  place.address,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.onboardingTextSecondaryLight,
                  ),
                ),
                const SizedBox(height: 8),

                // "Ride here" Soft Blue Pill Button
                InkWell(
                  key: Key('ride_here_button_${place.id}'),
                  onTap: onRideHereTap,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFEEF2FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      AppStrings.rideHere,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Right Heart Badge Container + Right Chevron
          Column(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF3F1D24) : AppColors.favouriteHeartBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.favorite_rounded,
                  color: AppColors.favouriteHeartIcon,
                  size: 18,
                ),
              ),
              const SizedBox(height: 12),
              Icon(
                Icons.chevron_right_rounded,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.onboardingTextSecondaryLight,
                size: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
