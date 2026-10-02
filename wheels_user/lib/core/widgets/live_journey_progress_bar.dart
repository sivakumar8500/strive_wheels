import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


/// Reusable journey progress bar widget matching reference UI design with
/// live ETA, vehicle badge, and a horizontal track showing car moving from
/// start to destination.
class LiveJourneyProgressBar extends StatelessWidget {
  final String statusText;
  final String etaText;
  final String? badgeText;
  final double progressPercent; // 0.0 to 1.0 (or 0 to 100)
  final String? startLocation;
  final String? dropLocation;
  final VoidCallback? onTap;

  const LiveJourneyProgressBar({
    super.key,
    required this.statusText,
    required this.etaText,
    this.badgeText,
    this.progressPercent = 0.0,
    this.startLocation,
    this.dropLocation,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Normalize progress to 0.0 .. 1.0
    final double normalizedProgress = progressPercent > 1.0
        ? (progressPercent / 100.0).clamp(0.0, 1.0)
        : progressPercent.clamp(0.0, 1.0);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF131518) : const Color(0xFF181B20),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? const Color(0xFF242930) : const Color(0xFF2C323B),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Status + ETA on left, Badge on right
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        statusText,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: -0.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        etaText,
                        style: GoogleFonts.poppins(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),
                if (badgeText != null && badgeText!.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E232B),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFF333B47),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      badgeText!,
                      style: GoogleFonts.poppins(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFE2E8F0),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 14),

            // Horizontal Moving Car Progress Bar
            LayoutBuilder(
              builder: (context, constraints) {
                final barWidth = constraints.maxWidth;
                const carWidth = 38.0;
                const barHeight = 18.0;

                // Position car head along the track
                final double carLeft = ((barWidth - carWidth) * normalizedProgress)
                    .clamp(0.0, barWidth - carWidth);

                return Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.centerLeft,
                  children: [
                    // Background track
                    Container(
                      height: barHeight,
                      width: barWidth,
                      decoration: BoxDecoration(
                        color: const Color(0xFF252A33),
                        borderRadius: BorderRadius.circular(barHeight / 2),
                      ),
                    ),

                    // Active progress fill (cyan-green glow)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeOutCubic,
                      height: barHeight,
                      width: (carLeft + carWidth * 0.7).clamp(barHeight, barWidth),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF00E599),
                            Color(0xFF00F5A0),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(barHeight / 2),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00E599).withValues(alpha: 0.45),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),

                    // Moving Car Icon at the progress point
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeOutCubic,
                      left: carLeft,
                      child: Container(
                        width: carWidth,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.35),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Top-down car visual representation
                            Container(
                              width: 6,
                              height: 14,
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E293B),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 3),
                            Container(
                              width: 14,
                              height: 16,
                              decoration: BoxDecoration(
                                color: const Color(0xFF0F172A),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                            const SizedBox(width: 3),
                            Container(
                              width: 6,
                              height: 14,
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E293B),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),

            // Optional Route (Start -> Drop) labels
            if ((startLocation != null && startLocation!.isNotEmpty) ||
                (dropLocation != null && dropLocation!.isNotEmpty)) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(
                    Icons.circle,
                    size: 8,
                    color: Color(0xFF00E599),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      startLocation ?? 'Pickup',
                      style: GoogleFonts.poppins(
                        fontSize: 10.5,
                        color: const Color(0xFFCBD5E1),
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      size: 11,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const Icon(
                    Icons.location_on_rounded,
                    size: 10,
                    color: Color(0xFFEF4444),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      dropLocation ?? 'Drop-off',
                      style: GoogleFonts.poppins(
                        fontSize: 10.5,
                        color: const Color(0xFFCBD5E1),
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
