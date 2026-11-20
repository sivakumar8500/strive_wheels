import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/network/customer_ws_controller.dart';
import '../../../../core/services/active_booking_service.dart';
import '../../../home/presentation/widgets/home_bottom_nav_bar.dart';
import 'live_trip_tracking_page.dart';

/// Screen displayed after rider accepts the ride request matching the exact design specification.
class BookingConfirmedPage extends StatefulWidget {
  final String bookingId;
  final String driverName;
  final double driverRating;
  final String totalRides;
  final String vehicleModel;
  final String licensePlate;
  final String vehicleTypeChip;
  final String luggageChip;
  final String pickupAddress;
  final String dropAddress;
  final String rideTime;
  final String totalAmount;
  final String arrivalTimeText;
  final LatLng pickupLatLng;
  final LatLng dropLatLng;
  final String? startOtp;

  const BookingConfirmedPage({
    super.key,
    this.bookingId = 'ER-9921-X4B',
    this.driverName = 'Marcus Thorne',
    this.driverRating = 4.9,
    this.totalRides = '2.4k rides',
    this.vehicleModel = 'BMW i7 xDrive60',
    this.licensePlate = '7396',
    this.vehicleTypeChip = 'ELECTRIC',
    this.luggageChip = 'LUGGAGE x3',
    this.pickupAddress = 'The Ritz-Carlton, Central Park',
    this.dropAddress = 'JFK International Airport, Terminal 4',
    this.rideTime = 'Today, 10:30 AM',
    this.totalAmount = '₹124.00',
    this.arrivalTimeText = 'Arriving in 4 mins',
    this.pickupLatLng = const LatLng(17.4126, 78.3498),
    this.dropLatLng = const LatLng(17.4435, 78.3772),
    this.startOtp,
  });

  @override
  State<BookingConfirmedPage> createState() => _BookingConfirmedPageState();
}

class _BookingConfirmedPageState extends State<BookingConfirmedPage> {
  @override
  void initState() {
    super.initState();
    _saveActiveBookingState();
  }

  void _saveActiveBookingState() {
    if (sl.isRegistered<ActiveBookingService>()) {
      sl<ActiveBookingService>().setActiveBooking(
        ActiveBookingData(
          bookingId: widget.bookingId,
          driverName: widget.driverName,
          driverRating: widget.driverRating,
          vehicleInfo: '${widget.vehicleModel} • ${widget.licensePlate}',
          pickupAddress: widget.pickupAddress,
          dropAddress: widget.dropAddress,
          pickupLatLng: widget.pickupLatLng,
          dropLatLng: widget.dropLatLng,
          totalAmount: widget.totalAmount,
          startOtp: widget.startOtp,
          status: 'RIDER_ACCEPTED',
        ),
      );
    }
  }

  void _showCancelRideDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(
          'Cancel Ride?',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to cancel this ride request?',
          style: GoogleFonts.poppins(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: Text(
              'Keep Ride',
              style: GoogleFonts.poppins(color: const Color(0xFF64748B)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogCtx).pop();
              if (sl.isRegistered<CustomerWSController>()) {
                sl<CustomerWSController>().cancelRide(bookingId: widget.bookingId);
              }
              if (sl.isRegistered<ActiveBookingService>()) {
                sl<ActiveBookingService>().clearActiveBooking();
              }
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Ride cancelled successfully'),
                  backgroundColor: Color(0xFFEF4444),
                ),
              );
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(
              'Yes, Cancel',
              style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark ? AppColors.onboardingBgDark : const Color(0xFFF8FAFC);
    final cardBg = isDark ? AppColors.cardBgDark : Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.onboardingBgDark : Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(
            Icons.menu_rounded,
            color: isDark ? AppColors.textPrimaryDark : AppColors.primaryBlue,
          ),
          onPressed: () {},
        ),
        title: Text(
          AppStrings.appName,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryBlue,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_none_outlined,
              color: isDark ? AppColors.textPrimaryDark : const Color(0xFF1E293B),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            // Top Checkmark Circle Icon
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.primaryBlue,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryBlue.withValues(alpha: 0.3),
                    blurRadius: 20,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 40,
              ),
            ),
            const SizedBox(height: 16),

            // Booking Confirmed Header Title & Subtitle
            Text(
              'Booking Confirmed!',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Your premium ride is scheduled and on its way.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 12),

            // Booking ID Pill Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'BOOKING ID  ',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF94A3B8),
                    ),
                  ),
                  Text(
                    widget.bookingId,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Map Preview Card with Floating Arrival Badge
            _buildMapCard(context, isDark),
            const SizedBox(height: 16),

            // Driver & Vehicle Details Card
            _buildDriverVehicleCard(context, isDark, cardBg),
            const SizedBox(height: 16),

            // Ride Summary Card
            _buildRideSummaryCard(context, isDark, cardBg),
            const SizedBox(height: 16),

            // Need Assistance Card
            _buildAssistanceCard(context, isDark),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: HomeBottomNavBar(
        selectedIndex: 0,
        onTabSelected: (index) {
          if (index == 0) {
            Navigator.of(context).popUntil((route) => route.isFirst);
          }
        },
      ),
    );
  }

  Widget _buildMapCard(BuildContext context, bool isDark) {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: widget.pickupLatLng,
                zoom: 14.5,
              ),
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
              markers: {
                Marker(
                  markerId: const MarkerId('pickup'),
                  position: widget.pickupLatLng,
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
                ),
                Marker(
                  markerId: const MarkerId('drop'),
                  position: widget.dropLatLng,
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                ),
              },
            ),

            // Floating Arriving Badge
            Positioned(
              top: 14,
              left: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryBlue,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.arrivalTimeText,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDriverVehicleCard(BuildContext context, bool isDark, Color cardBg) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Driver Avatar & Name
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                ),
                child: ClipOval(
                  child: Icon(
                    Icons.person_rounded,
                    size: 38,
                    color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            widget.driverName,
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (widget.startOtp != null && widget.startOtp!.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.primaryBlue.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.primaryBlue.withValues(alpha: 0.3)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'OTP: ',
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryBlue,
                                  ),
                                ),
                                Text(
                                  widget.startOtp!,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.0,
                                    color: AppColors.primaryBlue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, color: Color(0xFF3B82F6), size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.driverRating}',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${widget.totalRides})',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Vehicle Info
          Text(
            'VEHICLE',
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
              color: isDark ? AppColors.textSecondaryDark : const Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.vehicleModel,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.licensePlate,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Feature Chips
          Row(
            children: [
              _buildFeatureChip(widget.vehicleTypeChip, isDark),
              const SizedBox(width: 8),
              _buildFeatureChip(widget.luggageChip, isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureChip(String label, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _buildRideSummaryCard(BuildContext context, bool isDark, Color cardBg) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ride Summary',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 16),

          // Pickup Row
          _buildSummaryRow(
            icon: const Icon(Icons.location_on_outlined, color: AppColors.primaryBlue, size: 22),
            label: 'Pickup',
            value: widget.pickupAddress,
            isDark: isDark,
          ),
          const SizedBox(height: 14),

          // Destination Row
          _buildSummaryRow(
            icon: const Icon(Icons.navigation_outlined, color: Color(0xFFDC2626), size: 20),
            label: 'Destination',
            value: widget.dropAddress,
            isDark: isDark,
          ),
          const SizedBox(height: 14),

          // Time Row
          _buildSummaryRow(
            icon: Icon(
              Icons.access_time_rounded,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              size: 20,
            ),
            label: 'Time',
            value: widget.rideTime,
            isDark: isDark,
          ),
          const SizedBox(height: 16),

          Divider(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            height: 1,
          ),
          const SizedBox(height: 16),

          // Total Amount Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.textSecondaryDark : const Color(0xFF475569),
                ),
              ),
              Text(
                widget.totalAmount,
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Track Vehicle Primary Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => LiveTripTrackingPage(
                      driverName: widget.driverName,
                      vehicleInfo: '${widget.vehicleModel} • ${widget.licensePlate}',
                      pickupAddress: widget.pickupAddress,
                      dropAddress: widget.dropAddress,
                      pickupLatLng: widget.pickupLatLng,
                      dropLatLng: widget.dropLatLng,
                      startOtp: widget.startOtp,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.track_changes_rounded, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Track Vehicle',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Download Invoice Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE8F1FF),
                side: BorderSide.none,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.download_rounded, color: AppColors.primaryBlue, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Download Invoice',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Cancel Ride Red Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton(
              onPressed: () => _showCancelRideDialog(context),
              style: OutlinedButton.styleFrom(
                backgroundColor: isDark ? const Color(0xFF2C1E1E) : const Color(0xFFFEF2F2),
                side: const BorderSide(color: Color(0xFFFECDD3), width: 1.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.cancel_outlined, color: Color(0xFFEF4444), size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Cancel Ride',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFEF4444),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow({
    required Widget icon,
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 24, height: 24, child: Center(child: icon)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: isDark ? AppColors.textSecondaryDark : const Color(0xFF94A3B8),
                ),
              ),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAssistanceCard(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE5E7EB),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: Color(0xFF111827),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.support_agent_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Need assistance?',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
                  ),
                ),
                Text(
                  'Our elite support is online',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF111827),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Chat Now',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
