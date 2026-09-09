import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';

class LocationSelectorCard extends StatelessWidget {
  final String pickupLocation;
  final String destination;
  final int selectedRideTypeIndex;
  final ValueChanged<String>? onPickupChanged;
  final ValueChanged<String>? onDestinationChanged;
  final ValueChanged<int> onRideTypeSelected;

  const LocationSelectorCard({
    super.key,
    required this.pickupLocation,
    required this.destination,
    required this.selectedRideTypeIndex,
    this.onPickupChanged,
    this.onDestinationChanged,
    required this.onRideTypeSelected,
  });

  static const List<String> _rideTypes = [
    AppStrings.rideTypeInstant,
    AppStrings.rideTypeOneWay,
    AppStrings.rideTypeRoundTrip,
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.cardBgDark : Colors.white;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // 1. Pickup Location Input Box
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                // Blue Ring Icon
                Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.pickupBlueRing,
                      width: 4.5,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.pickupLocation,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.onboardingTextSecondaryLight,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        pickupLocation,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.white
                              : AppColors.onboardingTextPrimaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // 2. Destination Input Box
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                // Red Pin Icon
                const Icon(
                  Icons.location_on_rounded,
                  color: AppColors.destinationRedPin,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.destination,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.onboardingTextSecondaryLight,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        destination,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: destination == AppStrings.defaultDestination
                              ? (isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.onboardingTextSecondaryLight)
                              : (isDark
                                  ? AppColors.white
                                  : AppColors.onboardingTextPrimaryLight),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // 3. Ride Type Selection Pills (Instant, One Way, Round Trip)
          Row(
            children: List.generate(_rideTypes.length, (index) {
              final isSelected = index == selectedRideTypeIndex;
              final label = _rideTypes[index];

              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: index < _rideTypes.length - 1 ? 8 : 0,
                  ),
                  child: GestureDetector(
                    key: Key('ride_type_pill_$index'),
                    onTap: () => onRideTypeSelected(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.pickupBlueRing
                            : (isDark
                                ? const Color(0xFF1E293B)
                                : AppColors.rideTypeInactiveBg),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: AppColors.pickupBlueRing
                                      .withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ]
                            : [],
                      ),
                      child: Text(
                        label,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : (isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.onboardingTextSecondaryLight),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
