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
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Icon Badge Container
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getPlaceIconBg(place.iconType),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getPlaceIcon(place.iconType),
              color: _getPlaceIconColor(place.iconType),
              size: 20,
            ),
          ),
          const SizedBox(width: 10),

          // Title, Address, and "Ride here" Pill Button
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  place.title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
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
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.onboardingTextSecondaryLight,
                  ),
                ),
                const SizedBox(height: 6),

                // "Ride here" Soft Blue Pill Button
                InkWell(
                  key: Key('ride_here_button_${place.id}'),
                  onTap: onRideHereTap,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFEEF2FF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      AppStrings.rideHere,
                      style: GoogleFonts.inter(
                        fontSize: 11,
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
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF3F1D24) : AppColors.favouriteHeartBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.favorite_rounded,
                  color: AppColors.favouriteHeartIcon,
                  size: 16,
                ),
              ),
              const SizedBox(height: 8),
              Icon(
                Icons.chevron_right_rounded,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.onboardingTextSecondaryLight,
                size: 18,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
