import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

import '../../../../core/network/api_constants.dart';
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
import '../../../notifications/presentation/pages/notifications_page.dart';
import '../bloc/driver_search_bloc.dart';
import '../bloc/driver_search_event.dart';
import '../bloc/driver_search_state.dart';
import '../widgets/circular_radar_wave_widget.dart';
import '../widgets/safety_feature_carousel_widget.dart';

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
  final int? seatNumber;

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
    this.seatNumber,
  });

  @override
  State<DriverSearchPage> createState() => _DriverSearchPageState();
}

class _DriverSearchPageState extends State<DriverSearchPage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  int _currentStep = 1;
  CustomerWSController? _wsController;
  StreamSubscription? _wsSubscription;
  Timer? _httpPollTimer;
  bool _hasNavigated = false;
  int? _bookingId;
  String _notificationText = 'Searching for nearby drivers...';
  String? _startOtp;
  Map<String, dynamic>? _riderData;
  Map<String, dynamic>? _vehicleData;
  late final AnimationController _progressController;
  Timer? _searchTimer;
  int _searchSeconds = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4800),
    )..repeat();

    _searchTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          if (_searchSeconds < 90) {
            _searchSeconds++;
          }
        });
      }
    });

    if (widget.riderId != null) {
      _notificationText = 'Assigning corporate vehicle (${widget.driverName ?? "Corporate Driver"})...';
    } else if (widget.serviceMode == 'CORPORATE') {
      _notificationText = 'Connecting with dedicated corporate partner drivers...';
    }

    context.read<DriverSearchBloc>().add(const LoadDriverSearchEvent());
    _setupWebSocket();
    _startHttpPolling();
  }

  void _startHttpPolling() {
    _httpPollTimer?.cancel();
    // Poll immediately after 1 second, then every 2.5 seconds as a bulletproof fallback
    _httpPollTimer = Timer.periodic(const Duration(milliseconds: 2500), (_) {
      _checkBookingStatusHttp();
    });
  }

  Future<void> _checkBookingStatusHttp() async {
    if (!mounted || _hasNavigated) return;
    try {
      final dio = sl.isRegistered<Dio>() ? sl<Dio>() : Dio();
      final prefs = sl.isRegistered<SharedPreferences>() ? sl<SharedPreferences>() : null;
      final rawToken = prefs?.getString('access_token') ??
          prefs?.getString('auth_token') ??
          prefs?.getString('user_token') ??
          '';
      final options = Options(headers: {
        'Accept': 'application/json',
        if (rawToken.isNotEmpty) 'Authorization': 'Bearer $rawToken',
      });

      Response? res;
      if (_bookingId != null) {
        try {
          res = await dio.get('${ApiConstants.baseUrl}/api/v1/bookings/$_bookingId', options: options);
        } catch (_) {}
      }

      if (res == null || res.statusCode != 200 || res.data == null) {
        try {
          res = await dio.get('${ApiConstants.baseUrl}/api/v1/bookings/active', options: options);
        } catch (_) {}
      }

      if (res == null || res.data == null) return;

      final resData = res.data is Map ? res.data['data'] ?? res.data : null;
      if (resData == null || resData is! Map) return;

      final bookingMap = Map<String, dynamic>.from(resData);
      final rawStatus = (bookingMap['status'] ?? bookingMap['booking']?['status'])?.toString().toUpperCase() ?? '';

      final bId = bookingMap['id'] ?? bookingMap['booking_id'];
      if (bId != null) {
        _bookingId ??= int.tryParse(bId.toString());
      }
      final otp = bookingMap['start_otp'] ?? bookingMap['booking']?['start_otp'];
      if (otp != null && otp.toString().isNotEmpty) {
        _startOtp ??= otp.toString();
      }

      debugPrint('[DriverSearchPage HTTP poll] Status: $rawStatus, bId: $bId, otp: $otp');

      if (_isAcceptedStatus(rawStatus)) {
        _handleRideAccepted(bookingMap, rawStatus);
      } else if (_isTripStartedStatus(rawStatus)) {
        _handleTripStarted(bookingMap, rawStatus);
      } else if (_isCancelledStatus(rawStatus)) {
        _handleTripCancelled();
      }
    } catch (e) {
      debugPrint('[DriverSearchPage HTTP check error]: $e');
    }
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

      // Subscribe to stream BEFORE sending requestRide so broadcast stream does not drop events
      _wsSubscription?.cancel();
      _wsSubscription = _wsController!.bookingEventStream.listen(_onWebSocketEvent);

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
        seatNumber: widget.seatNumber,
      );
    }
  }

  void _onWebSocketEvent(Map<String, dynamic> eventData) {
    if (!mounted || _hasNavigated) return;

    final event = (eventData['event'] ?? '').toString();
    final data = (eventData['data'] is Map ? eventData['data'] as Map<String, dynamic> : eventData);
    final rawStatus = (data['status'] ?? data['booking']?['status'] ?? eventData['status'])?.toString().toUpperCase() ?? '';

    debugPrint('[DriverSearchPage WS Received] Event: $event, Status: $rawStatus');

    if (_isTripStartedEvent(event) || _isTripStartedStatus(rawStatus)) {
      _handleTripStarted(data, rawStatus);
      return;
    }

    if (event == 'booking.created' || event == 'booking.create_success') {
      final booking = data['booking'] is Map ? data['booking'] as Map<String, dynamic> : data;
      setState(() {
        final bId = booking['id'] ?? data['booking_id'] ?? data['id'];
        if (bId != null) {
          _bookingId = int.tryParse(bId.toString()) ?? _bookingId;
        }
        final otp = booking['start_otp'] ?? data['start_otp'];
        if (otp != null && otp.toString().isNotEmpty) {
          _startOtp = otp.toString();
        }
        _currentStep = 2;
        _notificationText = widget.riderId != null
            ? 'Corporate route vehicle assigned! Preparing trip...'
            : 'Booking #${_bookingId ?? ''} created! Scanning for nearby drivers...';
      });
      return;
    }

    if (_isAcceptedEvent(event) || _isAcceptedStatus(rawStatus)) {
      _handleRideAccepted(data, rawStatus);
      return;
    }

    if (_isCancelledEvent(event) || _isCancelledStatus(rawStatus)) {
      _handleTripCancelled();
      return;
    }

    if (event == 'notification.new') {
      final notif = data['notification'] is Map ? data['notification'] as Map<String, dynamic> : {};
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
  }

  bool _isAcceptedEvent(String event) {
    final e = event.toLowerCase().trim();
    return e == 'booking.rider_accepted' ||
        e == 'booking.driver_accepted' ||
        e == 'booking.accepted' ||
        e == 'booking.accepted_success' ||
        e == 'booking.assigned' ||
        e == 'booking.driver_assigned' ||
        e == 'booking.rider_assigned' ||
        e == 'corporate.booking_assigned' ||
        e == 'booking.arrived' ||
        e == 'booking.rider_arrived' ||
        e == 'rider.arrived' ||
        e == 'driver.arrived';
  }

  bool _isAcceptedStatus(String status) {
    final s = status.toUpperCase().trim();
    return s == 'RIDER_ACCEPTED' ||
        s == 'DRIVER_ACCEPTED' ||
        s == 'ACCEPTED' ||
        s == 'RIDER_ASSIGNED' ||
        s == 'DRIVER_ASSIGNED' ||
        s == 'ASSIGNED' ||
        s == 'RIDER_ARRIVING' ||
        s == 'DRIVER_ARRIVING' ||
        s == 'ARRIVING' ||
        s == 'RIDER_ARRIVED' ||
        s == 'DRIVER_ARRIVED' ||
        s == 'ARRIVED';
  }

  bool _isTripStartedEvent(String event) {
    final e = event.toLowerCase().trim();
    return e == 'booking.verify' ||
        e == 'booking.verified' ||
        e == 'otpverify' ||
        e == 'booking.otp_verified' ||
        e == 'otp_verified' ||
        e == 'booking.trip_started' ||
        e == 'booking.started' ||
        e == 'rider.trip_started' ||
        e == 'trip_started' ||
        e == 'trip.started' ||
        e == 'booking.start_success' ||
        e == 'ride.started' ||
        e == 'booking.start';
  }

  bool _isTripStartedStatus(String status) {
    final s = status.toUpperCase().trim();
    return s == 'TRIP_STARTED' ||
        s == 'TRIP_IN_PROGRESS' ||
        s == 'IN_TRANSIT' ||
        s == 'STARTED';
  }

  bool _isCancelledEvent(String event) {
    final e = event.toLowerCase().trim();
    return e == 'booking.cancelled' ||
        e == 'booking.rider_cancelled' ||
        e == 'booking.customer_cancelled' ||
        e == 'ride.cancelled' ||
        e == 'booking.cancel_success' ||
        e == 'booking.no_driver_found';
  }

  bool _isCancelledStatus(String status) {
    final s = status.toUpperCase().trim();
    return s == 'CANCELLED' ||
        s == 'RIDER_CANCELLED' ||
        s == 'CUSTOMER_CANCELLED' ||
        s == 'CANCELLED_BY_CUSTOMER' ||
        s == 'CANCELLED_BY_DRIVER' ||
        s == 'EXPIRED' ||
        s == 'NO_DRIVER_AVAILABLE';
  }

  void _handleRideAccepted(Map<String, dynamic> rawData, String? overrideStatus) {
    if (!mounted || _hasNavigated) return;
    _hasNavigated = true;

    _httpPollTimer?.cancel();
    _searchTimer?.cancel();
    _wsSubscription?.cancel();

    final data = (rawData['data'] is Map ? rawData['data'] as Map<String, dynamic> : rawData);
    final booking = (data['booking'] is Map ? data['booking'] as Map<String, dynamic> : data);
    final rider = (booking['rider'] is Map ? booking['rider'] as Map<String, dynamic> : null) ??
        (data['rider'] is Map ? data['rider'] as Map<String, dynamic> : null) ??
        _riderData;
    final vehicle = (booking['vehicle'] is Map ? booking['vehicle'] as Map<String, dynamic> : null) ??
        (data['vehicle'] is Map ? data['vehicle'] as Map<String, dynamic> : null) ??
        _vehicleData;

    final rawBId = booking['id'] ?? data['id'] ?? data['booking_id'] ?? _bookingId;
    final bId = rawBId?.toString() ?? '9921-X4B';
    final effectiveBId = bId.startsWith('ER-') ? bId : 'ER-$bId';

    final dName = rider?['full_name']?.toString() ?? widget.driverName ?? 'Marcus Thorne';
    final dRating = (rider?['rating'] is num) ? (rider!['rating'] as num).toDouble() : 4.9;
    final vMake = vehicle?['make']?.toString() ?? '';
    final vModel = vehicle?['model']?.toString() ?? widget.vehicleInfo ?? 'Cab';
    final lPlate = vehicle?['license_plate']?.toString() ?? widget.licensePlate ?? 'TS09CORP';
    final vDisplayModel = ('$vMake $vModel').trim().isEmpty ? 'Corporate Vehicle' : ('$vMake $vModel').trim();

    final estFare = (booking['estimated_fare'] != null)
        ? '₹${booking['estimated_fare']}'
        : (data['estimated_fare'] != null
            ? '₹${data['estimated_fare']}'
            : (widget.serviceMode == 'CORPORATE' ? 'Corporate Account' : '₹124.00'));

    final effectiveOtp = booking['start_otp']?.toString() ??
        data['start_otp']?.toString() ??
        rawData['start_otp']?.toString() ??
        _startOtp;

    final effectiveStatus = overrideStatus ?? (data['status']?.toString().toUpperCase() ?? 'RIDER_ACCEPTED');

    if (sl.isRegistered<ActiveBookingService>()) {
      sl<ActiveBookingService>().setActiveBooking(
        ActiveBookingData(
          bookingId: effectiveBId,
          driverName: dName,
          driverRating: dRating,
          vehicleInfo: '$vDisplayModel • $lPlate',
          pickupAddress: widget.pickupAddress,
          dropAddress: widget.dropAddress,
          pickupLatLng: LatLng(widget.pickupLat, widget.pickupLng),
          dropLatLng: LatLng(widget.dropLat, widget.dropLng),
          totalAmount: estFare,
          startOtp: effectiveOtp,
          status: effectiveStatus,
        ),
      );
    }

    debugPrint('🚀 [DriverSearchPage] Navigating to BookingConfirmedPage (OTP screen)! OTP: $effectiveOtp, Driver: $dName');

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => BookingConfirmedPage(
          bookingId: effectiveBId,
          driverName: dName,
          driverRating: dRating,
          vehicleModel: vDisplayModel,
          licensePlate: lPlate,
          pickupAddress: widget.pickupAddress,
          dropAddress: widget.dropAddress,
          pickupLatLng: LatLng(widget.pickupLat, widget.pickupLng),
          dropLatLng: LatLng(widget.dropLat, widget.dropLng),
          totalAmount: estFare,
          startOtp: effectiveOtp,
        ),
      ),
    );
  }

  void _handleTripStarted(Map<String, dynamic> rawData, String? overrideStatus) {
    if (!mounted || _hasNavigated) return;
    _hasNavigated = true;

    _httpPollTimer?.cancel();
    _searchTimer?.cancel();
    _wsSubscription?.cancel();

    final data = (rawData['data'] is Map ? rawData['data'] as Map<String, dynamic> : rawData);
    final booking = (data['booking'] is Map ? data['booking'] as Map<String, dynamic> : data);
    final rider = (booking['rider'] is Map ? booking['rider'] as Map<String, dynamic> : null) ??
        (data['rider'] is Map ? data['rider'] as Map<String, dynamic> : null) ??
        _riderData;
    final vehicle = (booking['vehicle'] is Map ? booking['vehicle'] as Map<String, dynamic> : null) ??
        (data['vehicle'] is Map ? data['vehicle'] as Map<String, dynamic> : null) ??
        _vehicleData;

    final rawBId = booking['id'] ?? data['id'] ?? data['booking_id'] ?? _bookingId;
    final bId = rawBId?.toString() ?? '9921-X4B';
    final effectiveBId = bId.startsWith('ER-') ? bId : 'ER-$bId';

    final dName = rider?['full_name']?.toString() ?? _riderData?['full_name']?.toString() ?? widget.driverName ?? 'Marcus Thorne';
    final dRating = (rider?['rating'] is num) ? (rider!['rating'] as num).toDouble() : 4.9;
    final vMake = vehicle?['make']?.toString() ?? '';
    final vModel = vehicle?['model']?.toString() ?? 'BMW i7';
    final lPlate = vehicle?['license_plate']?.toString() ?? '7396';
    final vInfo = (vMake.isNotEmpty && vModel.isNotEmpty && !vModel.contains(vMake))
        ? '$vMake $vModel'
        : vModel;

    final effectiveOtp = booking['start_otp']?.toString() ??
        data['start_otp']?.toString() ??
        rawData['start_otp']?.toString() ??
        _startOtp;

    if (sl.isRegistered<ActiveBookingService>()) {
      sl<ActiveBookingService>().updateBookingStatus('TRIP_STARTED');
    }

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
          startOtp: effectiveOtp,
          initialStatus: 'TRIP_STARTED',
        ),
      ),
    );
  }

  void _handleTripCancelled() {
    if (!mounted || _hasNavigated) return;
    _hasNavigated = true;

    _httpPollTimer?.cancel();
    _searchTimer?.cancel();
    _wsSubscription?.cancel();

    if (sl.isRegistered<ActiveBookingService>()) {
      sl<ActiveBookingService>().clearActiveBooking();
    }
    Navigator.of(context).pushAndRemoveUntil(HomePage.route(), (route) => false);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (sl.isRegistered<CustomerWSController>()) {
        sl<CustomerWSController>().reconnectIfNeeded();
      }
      _checkBookingStatusHttp();
    }
  }

  String get riderName => _riderData?['full_name']?.toString() ?? 'Ramesh Kumar';
  String get vehicleDetails =>
      '${_vehicleData?['make'] ?? 'Honda'} ${_vehicleData?['model'] ?? 'Amaze'} • ${_vehicleData?['license_plate'] ?? 'TS09FA1234'}';

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _progressController.dispose();
    _searchTimer?.cancel();
    _httpPollTimer?.cancel();
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
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const NotificationsPage()),
              );
            },
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

                // 4-Card Safety & Features Carousel
                const SafetyFeatureCarouselWidget(),
                const SizedBox(height: 16),

                // Estimated Confirmation Card (0 to 90s)
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

  Widget _buildEstimatedCard(BuildContext context, bool isDark, dynamic data) {
    final rawText = data?.estimatedConfirmationText;
    final displayTime = (rawText == null || rawText == '5 - 30 mins') ? '0 – 90 sec' : rawText;

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
              Row(
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    margin: const EdgeInsets.only(right: 6),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF10B981),
                    ),
                  ),
                  Text(
                    'ESTIMATED CONFIRMATION',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                      color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    displayTime,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '(${_searchSeconds}s elapsed)',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
                    ),
                  ),
                ],
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
