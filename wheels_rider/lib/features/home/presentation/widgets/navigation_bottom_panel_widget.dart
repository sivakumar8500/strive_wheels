import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';

class NavigationBottomPanelWidget extends StatefulWidget {
  final int remainingMins;
  final double remainingKm;
  final String arrivalEta;
  final String destinationAddress;
  final String pickupAddress;
  final String customerName;
  final double customerRating;
  final bool isTripStarted;
  final bool isLoading;
  final VoidCallback onMainActionTap;
  final VoidCallback? onRequestDrop;
  final VoidCallback? onCancelRide;
  final VoidCallback? onCallTap;
  final VoidCallback? onChatTap;

  final bool isDropPending;

  const NavigationBottomPanelWidget({
    super.key,
    required this.remainingMins,
    required this.remainingKm,
    required this.arrivalEta,
    required this.destinationAddress,
    required this.pickupAddress,
    this.customerName = 'John Doe',
    this.customerRating = 4.9,
    required this.isTripStarted,
    required this.isLoading,
    this.isDropPending = false,
    required this.onMainActionTap,
    this.onRequestDrop,
    this.onCancelRide,
    this.onCallTap,
    this.onChatTap,
  });

  @override
  State<NavigationBottomPanelWidget> createState() => _NavigationBottomPanelWidgetState();
}

class _NavigationBottomPanelWidgetState extends State<NavigationBottomPanelWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;

    final actionLabel = widget.isTripStarted
        ? 'COMPLETE TRIP'
        : 'ARRIVED AT PICKUP';
    final actionColor = widget.isTripStarted
        ? const Color(0xFF10B981)
        : AppColors.primaryBlue;

    return Container(
      padding: const EdgeInsets.only(left: 18, right: 18, top: 12, bottom: 16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.12),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle pill
          GestureDetector(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Main ETA & Destination Bar
          Row(
            children: [
              // ETA Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${widget.remainingMins} min',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: actionColor,
                      ),
                    ),
                    Text(
                      '${widget.remainingKm.toStringAsFixed(1)} km',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),

              // Target Destination Address
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.isTripStarted ? 'DESTINATION' : 'PICKUP LOCATION',
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                            color: isDark ? AppColors.textSecondaryDark : const Color(0xFF94A3B8),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'ETA ${widget.arrivalEta}',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.isTripStarted ? widget.destinationAddress : widget.pickupAddress,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Expand / Collapse Details Button
              IconButton(
                icon: Icon(
                  _isExpanded ? Icons.keyboard_arrow_down_rounded : Icons.keyboard_arrow_up_rounded,
                  color: isDark ? AppColors.textPrimaryDark : const Color(0xFF475569),
                ),
                onPressed: () => setState(() => _isExpanded = !_isExpanded),
              ),
            ],
          ),

          // Expandable Passenger & Trip Info Section
          if (_isExpanded) ...[
            const SizedBox(height: 12),
            Divider(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
            const SizedBox(height: 8),
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                  child: const Icon(Icons.person_rounded, color: AppColors.primaryBlue),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.customerName,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, size: 14, color: Color(0xFFF59E0B)),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.customerRating}',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.phone_rounded, color: AppColors.primaryBlue),
                  onPressed: widget.onCallTap,
                ),
                IconButton(
                  icon: const Icon(Icons.chat_bubble_outline_rounded, color: AppColors.primaryBlue),
                  onPressed: widget.onChatTap,
                ),
              ],
            ),
          ],

          const SizedBox(height: 14),

          // Secondary Action Buttons (Request Drop when started, Cancel Ride before start)
          if (widget.isTripStarted) ...[
            SizedBox(
              width: double.infinity,
              height: 44,
              child: OutlinedButton.icon(
                onPressed: (widget.isLoading || widget.isDropPending) ? null : widget.onRequestDrop,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: widget.isDropPending ? Colors.grey : Colors.orange, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: Icon(
                  widget.isDropPending ? Icons.timer_outlined : Icons.flag_rounded,
                  color: widget.isDropPending ? Colors.grey : Colors.orange,
                  size: 18,
                ),
                label: Text(
                  widget.isDropPending ? 'WAITING APPROVAL...' : 'REQUEST DROP',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: widget.isDropPending ? Colors.grey : Colors.orange,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ] else if (widget.onCancelRide != null) ...[
            SizedBox(
              width: double.infinity,
              height: 44,
              child: OutlinedButton.icon(
                onPressed: widget.isLoading ? null : widget.onCancelRide,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: const Icon(Icons.cancel_outlined, color: Color(0xFFEF4444), size: 18),
                label: Text(
                  'CANCEL RIDE',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFEF4444),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],

          // Main Action Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: (widget.isLoading || (widget.isTripStarted && widget.remainingKm > 0.2)) 
                  ? null 
                  : widget.onMainActionTap,
              style: ElevatedButton.styleFrom(
                disabledBackgroundColor: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                backgroundColor: actionColor,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: widget.isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                    )
                  : Text(
                      actionLabel,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: (widget.isTripStarted && widget.remainingKm > 0.2) 
                            ? (isDark ? const Color(0xFF94A3B8) : const Color(0xFF94A3B8))
                            : Colors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
