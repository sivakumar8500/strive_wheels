import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/utils/jwt_utils.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/network/customer_ws_controller.dart';
import '../../../../core/services/active_booking_service.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../home/presentation/widgets/home_bottom_nav_bar.dart';
import '../../../booking/presentation/pages/booking_confirmed_page.dart';
import '../../../booking/presentation/pages/live_trip_tracking_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../bloc/driver_search_bloc.dart';
import '../bloc/driver_search_event.dart';
import '../bloc/driver_search_state.dart';
import '../widgets/circular_radar_wave_widget.dart';

/// Searching for Nearby Drivers Page matching reference UI design with real-time WebSocket updates.
class DriverSearchPage extends StatefulWidget {
  final int vehicleTypeId;
  final double pickupLat;
  final double pickupLng;
  final String pickupAddress;
  final double dropLat;
  final double dropLng;
  final String dropAddress;
  final String serviceMode;
  final String bookingMode;
  final String tripType;
  final String paymentMethod;
  final int? companyId;
  final int? riderId;
  final int? vehicleId;
  final String? driverName;
  final String? vehicleInfo;
  final String? licensePlate;
  final String? routeAlignment;

  const DriverSearchPage({
    super.key,
    required this.vehicleTypeId,
    required this.pickupLat,
    required this.pickupLng,
    required this.pickupAddress,
    required this.dropLat,
    required this.dropLng,
    required this.dropAddress,
    this.serviceMode = 'NORMAL',
    this.bookingMode = 'INSTANT',
    this.tripType = 'ONE_WAY',
    this.paymentMethod = 'CASH',
    this.companyId,
    this.riderId,
    this.vehicleId,
    this.driverName,
    this.vehicleInfo,
    this.licensePlate,
    this.routeAlignment,
  });

  @override
  State<DriverSearchPage> createState() => _DriverSearchPageState();
}

class _DriverSearchPageState extends State<DriverSearchPage>
    with SingleTickerProviderStateMixin {
  int _currentStep = 1;
  CustomerWSController? _wsController;
  StreamSubscription? _wsSubscription;
  int? _bookingId;
  String _notificationText = 'Searching for nearby drivers...';
  String? _startOtp;
  Map<String, dynamic>? _riderData;
  Map<String, dynamic>? _vehicleData;
  late final AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();
    if (widget.riderId != null) {
      _notificationText = 'Assigning corporate vehicle (${widget.driverName ?? "Corporate Driver"})...';
    } else if (widget.serviceMode == 'CORPORATE') {
      _notificationText = 'Connecting with dedicated corporate partner drivers...';
    }
    context.read<DriverSearchBloc>().add(const LoadDriverSearchEvent());
    _setupWebSocket();
  }

  void _setupWebSocket() {
    if (sl.isRegistered<CustomerWSController>()) {
      _wsController = sl<CustomerWSController>();

      final prefs = sl.isRegistered<SharedPreferences>() ? sl<SharedPreferences>() : null;
      final rawToken = prefs?.getString('access_token') ??
          prefs?.getString('auth_token') ??
          prefs?.getString('user_token');
      final token = (rawToken != null && rawToken.trim().isNotEmpty) ? rawToken.trim() : 'demo_token';

      int? userId = prefs?.getInt('user_id') ?? prefs?.getInt('customer_id');
      if (userId == null && rawToken != null && rawToken.trim().isNotEmpty) {
        userId = JwtUtils.getUserIdFromJwt(rawToken);
      }
      userId ??= 1;

      _wsController!.initCustomerWebSocket(userId, token);

      // Send booking.create event over WS
      _wsController!.requestRide(
        vehicleTypeId: widget.vehicleTypeId,
        pickupLat: widget.pickupLat,
        pickupLng: widget.pickupLng,
        pickupAddress: widget.pickupAddress,
        dropLat: widget.dropLat,
        dropLng: widget.dropLng,
        dropAddress: widget.dropAddress,
        serviceMode: widget.serviceMode,
        bookingMode: widget.bookingMode,
        tripType: widget.tripType,
        paymentMethod: widget.paymentMethod,
        companyId: widget.companyId,
        riderId: widget.riderId,
        vehicleId: widget.vehicleId,
      );

      // Listen for server events
      _wsSubscription = _wsController!.bookingEventStream.listen((eventData) {
        final event = eventData['event'];
        final data = eventData['data'] ?? {};
        final rawStatus = (data['status'] ?? data['booking']?['status'] ?? eventData['status'])?.toString().toUpperCase() ?? '';

        if (!mounted) return;

        final isTripStarted =
            event == 'booking.verify' ||
            event == 'booking.verified' ||
            event == 'otpverify' ||
            event == 'booking.otp_verified' ||
            event == 'otp_verified' ||
            event == 'booking.trip_started' ||
            event == 'booking.started' ||
            event == 'rider.trip_started' ||
            event == 'trip_started' ||
            event == 'trip.started' ||
            event == 'booking.start_success' ||
            event == 'ride.started' ||
            event == 'booking.start' ||
            data['otp_verified'] == true ||
            rawStatus == 'TRIP_STARTED' ||
            rawStatus == 'TRIP_IN_PROGRESS' ||
            rawStatus == 'IN_TRANSIT' ||
            rawStatus == 'STARTED';

        if (isTripStarted) {
          final booking = data['booking'] as Map<String, dynamic>? ?? {};
          final rider = booking['rider'] as Map<String, dynamic>?;
          final vehicle = booking['vehicle'] as Map<String, dynamic>?;
          final dName = rider?['full_name']?.toString() ?? _riderData?['full_name']?.toString() ?? 'Marcus Thorne';
          final dRating = (rider?['rating'] is num) ? (rider!['rating'] as num).toDouble() : 4.9;
          final vMake = vehicle?['make']?.toString() ?? '';
          final vModel = vehicle?['model']?.toString() ?? 'BMW i7';
          final lPlate = vehicle?['license_plate']?.toString() ?? '7396';
          final vInfo = (vMake.isNotEmpty && vModel.isNotEmpty && !vModel.contains(vMake))
              ? '$vMake $vModel'
              : vModel;

          if (sl.isRegistered<ActiveBookingService>()) {
            sl<ActiveBookingService>().updateBookingStatus('TRIP_STARTED');
          }

          if (mounted) {
            final effectiveBId = _bookingId != null ? 'ER-$_bookingId' : null;
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => LiveTripTrackingPage(
                  bookingId: effectiveBId,
                  driverName: dName,
                  driverRating: dRating,
                  vehicleInfo: '$vInfo • $lPlate',
                  pickupAddress: widget.pickupAddress,
                  dropAddress: widget.dropAddress,
                  pickupLatLng: LatLng(widget.pickupLat, widget.pickupLng),
                  dropLatLng: LatLng(widget.dropLat, widget.dropLng),
                  startOtp: _startOtp,
                  initialStatus: 'TRIP_STARTED',
                ),
              ),
            );
          }
          return;
        }

        if (event == 'booking.created') {
          final booking = data['booking'] ?? {};
          setState(() {
            _bookingId = booking['id'];
            if (booking['start_otp'] != null) {
              _startOtp = booking['start_otp'].toString();
            }
            _currentStep = 2;
            _notificationText = widget.riderId != null
                ? 'Corporate route vehicle assigned! Preparing trip...'
                : 'Booking #${_bookingId ?? ''} created! Scanning for nearby drivers...';
          });
        } else if (event == 'booking.rider_accepted' ||
            event == 'booking.assigned' ||
            event == 'corporate.booking_assigned') {
          final booking = data['booking'] ?? {};
          final rider = (booking['rider'] as Map<String, dynamic>?) ?? (data['rider'] as Map<String, dynamic>?);
          final vehicle = (booking['vehicle'] as Map<String, dynamic>?) ?? (data['vehicle'] as Map<String, dynamic>?);
          final bId = booking['id']?.toString() ?? _bookingId?.toString() ?? '9921-X4B';
          final dName = rider?['full_name']?.toString() ?? widget.driverName ?? 'Marcus Thorne';
          final dRating = (rider?['rating'] is num) ? (rider!['rating'] as num).toDouble() : 4.9;
          final vMake = vehicle?['make']?.toString() ?? '';
          final vModel = vehicle?['model']?.toString() ?? widget.vehicleInfo ?? 'Cab';
          final lPlate = vehicle?['license_plate']?.toString() ?? widget.licensePlate ?? 'TS09CORP';
          final estFare = (booking['estimated_fare'] != null)
              ? '₹${booking['estimated_fare']}'
              : (widget.serviceMode == 'CORPORATE' ? 'Corporate Account' : '₹124.00');

          setState(() {
            _bookingId = booking['id'] ?? _bookingId;
            _startOtp = booking['start_otp']?.toString() ?? _startOtp;
            _riderData = rider;
            _vehicleData = vehicle;
            _currentStep = 4;
            _notificationText = 'Vehicle assigned! $dName is ready.';
          });

          // Navigate to BookingConfirmedPage
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => BookingConfirmedPage(
                bookingId: 'ER-$bId',
                driverName: dName,
                driverRating: dRating,
                vehicleModel: ('$vMake $vModel').trim().isEmpty ? 'Corporate Vehicle' : ('$vMake $vModel').trim(),
                licensePlate: lPlate,
                pickupAddress: widget.pickupAddress,
                dropAddress: widget.dropAddress,
                pickupLatLng: LatLng(widget.pickupLat, widget.pickupLng),
                dropLatLng: LatLng(widget.dropLat, widget.dropLng),
                totalAmount: estFare,
                startOtp: _startOtp,
              ),
            ),
          );
        } else if (event == 'booking.cancelled' ||
            event == 'booking.rider_cancelled' ||
            event == 'booking.customer_cancelled' ||
            event == 'ride.cancelled' ||
            event == 'booking.cancel_success') {
          final reason = data['reason']?.toString() ?? 'Ride request was cancelled.';
          if (sl.isRegistered<ActiveBookingService>()) {
            sl<ActiveBookingService>().clearActiveBooking();
          }
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(reason),
                backgroundColor: const Color(0xFFEF4444),
                duration: const Duration(seconds: 4),
              ),
            );
            Navigator.of(context).pushAndRemoveUntil(HomePage.route(), (route) => false);
          }
        } else if (event == 'booking.no_driver_found') {
          if (sl.isRegistered<ActiveBookingService>()) {
            sl<ActiveBookingService>().clearActiveBooking();
          }
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('No nearby drivers accepted your request. Please try again.'),
                backgroundColor: Color(0xFFEF4444),
                duration: Duration(seconds: 4),
              ),
            );
            Navigator.of(context).pushAndRemoveUntil(HomePage.route(), (route) => false);
          }
        } else if (event == 'notification.new') {
          final notif = data['notification'] ?? {};
          final body = notif['body']?.toString();
          if (body != null) {
            final match = RegExp(r'OTP:\s*(\d{4,6})', caseSensitive: false).firstMatch(body);
            if (match != null) {
              _startOtp = match.group(1);
            }
            setState(() {
              _notificationText = body;
            });
          }
        }
      });
    }
  }

  String get riderName => _riderData?['full_name']?.toString() ?? 'Ramesh Kumar';
  String get vehicleDetails =>
      '${_vehicleData?['make'] ?? 'Honda'} ${_vehicleData?['model'] ?? 'Amaze'} • ${_vehicleData?['license_plate'] ?? 'TS09FA1234'}';

  @override
  void dispose() {
    _progressController.dispose();
    _wsSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark ? AppColors.onboardingBgDark : const Color(0xFFF8FAFC);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.onboardingBgDark : Colors.white,
        elevation: 0.5,
        automaticallyImplyLeading: false,
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
      body: BlocConsumer<DriverSearchBloc, DriverSearchState>(
        listener: (context, state) {
          if (state.isCancelled) {
            if (sl.isRegistered<ActiveBookingService>()) {
              sl<ActiveBookingService>().clearActiveBooking();
            }
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          final data = state.driverSearch;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Map Radar Card with circular expanding ripple waves & split 3-bar progress
                _buildRadarCard(context, isDark, data),
                const SizedBox(height: 16),

                // Driver & OTP Banner when accepted
                if (_startOtp != null) ...[
                  _buildDriverAssignedBanner(context, isDark),
                  const SizedBox(height: 16),
                ],

                // Estimated Confirmation Card
                _buildEstimatedCard(context, isDark, data),
                const SizedBox(height: 24),

                // Cancel Request Button
                SizedBox(
                  height: 52,
                  child: OutlinedButton(
                    onPressed: () => _showCancelSearchDialog(context),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: isDark ? const Color(0xFF2C1E1E) : Colors.white,
                      side: const BorderSide(color: Color(0xFFFECDD3), width: 1.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      'Cancel Request',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFE11D48),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: HomeBottomNavBar(
        selectedIndex: 0,
        onTabSelected: (index) {
          if (index == 0) {
            Navigator.of(context).pushAndRemoveUntil(HomePage.route(), (route) => false);
          }
        },
      ),
    );
  }

  void _showCancelSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(
          'Cancel Search?',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to cancel your ride request search?',
          style: GoogleFonts.poppins(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: Text(
              'Keep Searching',
              style: GoogleFonts.poppins(color: const Color(0xFF64748B)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogCtx).pop();
              if (_bookingId != null && sl.isRegistered<CustomerWSController>()) {
                sl<CustomerWSController>().cancelRide(bookingId: _bookingId.toString());
              }
              if (sl.isRegistered<ActiveBookingService>()) {
                sl<ActiveBookingService>().clearActiveBooking();
              }
              context.read<DriverSearchBloc>().add(const CancelDriverSearchEvent());
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Ride search cancelled successfully'),
                  backgroundColor: Color(0xFFEF4444),
                ),
              );
              Navigator.of(context).pushAndRemoveUntil(HomePage.route(), (route) => false);
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

  Widget _buildRadarCard(BuildContext context, bool isDark, dynamic data) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBgDark : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 230,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
            ),
            child: const Center(
              child: CircularRadarWaveWidget(
                size: 220,
                vehicleIcon: Icons.directions_car_filled_rounded,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                if (widget.serviceMode == 'CORPORATE') ...[
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.primaryBlue.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.business_rounded, color: AppColors.primaryBlue, size: 14),
                        const SizedBox(width: 6),
                        Text(
                          'CORPORATE TRIP MATCHING',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryBlue,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                Text(
                  _currentStep >= 3
                      ? 'Driver Found!'
                      : (data?.statusTitle ?? 'Searching for nearby drivers...'),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _notificationText,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 16),
                _buildSplitProgressBar(isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSplitProgressBar(bool isDark) {
    return AnimatedBuilder(
      animation: _progressController,
      builder: (context, child) {
        final value = _progressController.value;
        final p1 = (value / 0.333).clamp(0.0, 1.0);
        final p2 = ((value - 0.333) / 0.333).clamp(0.0, 1.0);
        final p3 = ((value - 0.666) / 0.334).clamp(0.0, 1.0);

        final trackBg = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

        return Row(
          children: [
            Expanded(child: _buildBarSegment(p1, trackBg)),
            const SizedBox(width: 8),
            Expanded(child: _buildBarSegment(p2, trackBg)),
            const SizedBox(width: 8),
            Expanded(child: _buildBarSegment(p3, trackBg)),
          ],
        );
      },
    );
  }

  Widget _buildBarSegment(double fillFactor, Color trackBg) {
    return Container(
      height: 6,
      decoration: BoxDecoration(
        color: trackBg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: fillFactor,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primaryBlue,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryBlue.withValues(alpha: 0.5),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDriverAssignedBanner(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F1E36) : const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primaryBlue.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primaryBlue,
            child: const Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  riderName,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.primaryBlue,
                  ),
                ),
                Text(
                  vehicleDetails,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: isDark ? AppColors.textSecondaryDark : const Color(0xFF1E40AF),
                  ),
                ),
              ],
            ),
          ),
          if (_startOtp != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.accentOrange,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text(
                    'OTP',
                    style: GoogleFonts.poppins(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  Text(
                    _startOtp!,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEstimatedCard(BuildContext context, bool isDark, dynamic data) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBgDark : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ESTIMATED CONFIRMATION',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                  color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                data?.estimatedConfirmationText ?? '5 - 30 mins',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBlue,
                ),
              ),
            ],
          ),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE8F1FF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.timer_outlined,
              color: AppColors.primaryBlue,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}
