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
import '../../../home/presentation/widgets/home_bottom_nav_bar.dart';
import '../../../booking/presentation/pages/booking_confirmed_page.dart';
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
  final String _orderTime = '10:42 AM';

  @override
  void initState() {
    super.initState();
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
      );

      // Listen for server events
      _wsSubscription = _wsController!.bookingEventStream.listen((eventData) {
        final event = eventData['event'];
        final data = eventData['data'] ?? {};

        if (!mounted) return;

        if (event == 'booking.created') {
          final booking = data['booking'] ?? {};
          setState(() {
            _bookingId = booking['id'];
            _currentStep = 2;
            _notificationText = 'Booking #${_bookingId ?? ''} created! Scanning for nearby drivers...';
          });
        } else if (event == 'booking.rider_accepted') {
          final booking = data['booking'] ?? {};
          final rider = booking['rider'] as Map<String, dynamic>?;
          final vehicle = booking['vehicle'] as Map<String, dynamic>?;
          final bId = booking['id']?.toString() ?? '9921-X4B';
          final dName = rider?['full_name']?.toString() ?? 'Marcus Thorne';
          final dRating = (rider?['rating'] is num) ? (rider!['rating'] as num).toDouble() : 4.9;
          final vMake = vehicle?['make']?.toString() ?? 'BMW';
          final vModel = vehicle?['model']?.toString() ?? 'i7 xDrive60';
          final lPlate = vehicle?['license_plate']?.toString() ?? '7396';
          final estFare = (booking['estimated_fare'] != null) ? '₹${booking['estimated_fare']}' : '₹124.00';

          setState(() {
            _bookingId = booking['id'];
            _startOtp = booking['start_otp']?.toString();
            _riderData = rider;
            _vehicleData = vehicle;
            _currentStep = 4;
            _notificationText = 'Driver accepted! $dName is on the way.';
          });

          // Navigate to BookingConfirmedPage
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => BookingConfirmedPage(
                bookingId: 'ER-$bId',
                driverName: dName,
                driverRating: dRating,
                vehicleModel: '$vMake $vModel',
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
                // Top Map Radar Card with circular expanding ripple waves
                _buildRadarCard(context, isDark, data),
                const SizedBox(height: 16),

                // Driver & OTP Banner when accepted
                if (_startOtp != null) ...[
                  _buildDriverAssignedBanner(context, isDark),
                  const SizedBox(height: 16),
                ],

                // Estimated Confirmation Card
                _buildEstimatedCard(context, isDark, data),
                const SizedBox(height: 16),

                // Ride Status Card
                _buildRideStatusCard(context, isDark, data),
                const SizedBox(height: 24),

                // Cancel Request Button
                SizedBox(
                  height: 52,
                  child: OutlinedButton(
                    onPressed: () {
                      if (sl.isRegistered<ActiveBookingService>()) {
                        sl<ActiveBookingService>().clearActiveBooking();
                      }
                      context
                          .read<DriverSearchBloc>()
                          .add(const CancelDriverSearchEvent());
                    },
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
            Navigator.of(context).popUntil((route) => route.isFirst);
          }
        },
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDriverAssignedBanner(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF132A1C) : const Color(0xFFECFDF5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFF10B981),
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
                    color: isDark ? AppColors.textPrimaryDark : const Color(0xFF065F46),
                  ),
                ),
                Text(
                  vehicleDetails,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: isDark ? AppColors.textSecondaryDark : const Color(0xFF047857),
                  ),
                ),
              ],
            ),
          ),
          if (_startOtp != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981),
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

  Widget _buildRideStatusCard(BuildContext context, bool isDark, dynamic data) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF1F5),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ride Status',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 16),
          _buildTimelineStep(
            context: context,
            isDark: isDark,
            icon: const Icon(Icons.check_circle_rounded, color: AppColors.primaryBlue, size: 24),
            title: 'Requested',
            subtitle: '${data?.orderTime ?? _orderTime} • Order confirmed',
            isDone: true,
            hasLine: true,
          ),
          _buildTimelineStep(
            context: context,
            isDark: isDark,
            icon: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: _currentStep >= 2 ? AppColors.primaryBlue : const Color(0xFF94A3B8),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.sync_rounded, color: Colors.white, size: 16),
            ),
            title: 'Searching',
            subtitle: data?.scanRadiusText ?? 'Scanning 1.2km radius...',
            isCurrent: _currentStep == 2,
            isDone: _currentStep > 2,
            hasLine: true,
          ),
          _buildTimelineStep(
            context: context,
            isDark: isDark,
            icon: Icon(
              _currentStep >= 3 ? Icons.check_circle_rounded : Icons.circle_outlined,
              color: _currentStep >= 3 ? AppColors.primaryBlue : (isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
              size: 24,
            ),
            title: 'Accepted',
            subtitle: _currentStep >= 3 ? 'Driver accepted ride' : 'Waiting for driver',
            isCurrent: _currentStep == 3,
            isDone: _currentStep > 3,
            hasLine: true,
          ),
          _buildTimelineStep(
            context: context,
            isDark: isDark,
            icon: Icon(
              _currentStep >= 4 ? Icons.location_on_rounded : Icons.location_on_outlined,
              color: _currentStep >= 4 ? AppColors.primaryBlue : (isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
              size: 24,
            ),
            title: 'Assigned',
            subtitle: _currentStep >= 4 ? 'Vehicle details: $vehicleDetails' : 'Vehicle details arrival',
            isCurrent: _currentStep == 4,
            isDone: _currentStep >= 4,
            hasLine: false,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineStep({
    required BuildContext context,
    required bool isDark,
    required Widget icon,
    required String title,
    required String subtitle,
    bool isDone = false,
    bool isCurrent = false,
    required bool hasLine,
  }) {
    Color titleColor;
    if (isCurrent) {
      titleColor = AppColors.primaryBlue;
    } else if (isDone) {
      titleColor = isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A);
    } else {
      titleColor = isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B);
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              icon,
              if (hasLine)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: isCurrent || isDone ? FontWeight.bold : FontWeight.w500,
                      color: titleColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
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
}
