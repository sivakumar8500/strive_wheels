import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/navigation_service.dart';

class ManeuverBannerWidget extends StatelessWidget {
  final NavigationStep? currentStep;
  final double distanceToStepMeters;
  final bool isMuted;
  final VoidCallback onToggleMute;
  final VoidCallback onOverviewTap;

  const ManeuverBannerWidget({
    super.key,
    required this.currentStep,
    required this.distanceToStepMeters,
    required this.isMuted,
    required this.onToggleMute,
    required this.onOverviewTap,
  });

  IconData _getManeuverIcon(ManeuverType? type) {
    switch (type) {
      case ManeuverType.turnLeft:
        return Icons.turn_left_rounded;
      case ManeuverType.turnRight:
        return Icons.turn_right_rounded;
      case ManeuverType.slightLeft:
        return Icons.turn_slight_left_rounded;
      case ManeuverType.slightRight:
        return Icons.turn_slight_right_rounded;
      case ManeuverType.sharpLeft:
        return Icons.turn_sharp_left_rounded;
      case ManeuverType.sharpRight:
        return Icons.turn_sharp_right_rounded;
      case ManeuverType.uTurn:
        return Icons.u_turn_left_rounded;
      case ManeuverType.arrive:
        return Icons.place_rounded;
      case ManeuverType.depart:
        return Icons.navigation_rounded;
      case ManeuverType.straight:
      default:
        return Icons.straight_rounded;
    }
  }

  String _formatDistance(double meters) {
    if (meters >= 1000) {
      return '${(meters / 1000).toStringAsFixed(1)} km';
    } else {
      return '${meters.round()} m';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bannerBg = isDark ? AppColors.darkBlue : AppColors.primaryBlue;
    final iconBg = isDark ? const Color(0xFF00194A) : const Color(0xFF00297A);

    final icon = _getManeuverIcon(currentStep?.maneuverType);
    final distanceStr = _formatDistance(distanceToStepMeters > 0 ? distanceToStepMeters : (currentStep?.distanceMeters ?? 0));
    final roadName = currentStep == null
        ? 'Head towards destination'
        : ((currentStep?.roadName == null || currentStep!.roadName.isEmpty || currentStep!.roadName.toLowerCase() == 'unnamed road')
            ? ''
            : currentStep!.roadName);
    final instruction = currentStep?.instruction ?? 'Follow highlighted route';

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: bannerBg,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Turn Direction Icon Circle
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 26,
              ),
            ),
            const SizedBox(width: 14),

            // Distance & Instruction Text
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        distanceStr,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      if (roadName.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            roadName,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.accentOrange,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    instruction,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFFE2E8F0),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
