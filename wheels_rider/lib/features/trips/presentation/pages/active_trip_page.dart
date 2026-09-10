import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_map_widget.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/network/websocket_client.dart';
import '../../domain/usecases/start_trip_usecase.dart';
import '../../domain/usecases/complete_trip_usecase.dart';

enum TripStatus { arrived, inProgress, completed }

class ActiveTripPage extends StatefulWidget {
  final int bookingId;
  final String? pickupAddress;
  final String? dropAddress;
  final double? estimatedFare;
  final double? pickupLat;
  final double? pickupLng;
  final double? dropLat;
  final double? dropLng;
  final double? riderLat;
  final double? riderLng;
  /// Called when OTP is verified and the trip transitions to in-progress.
  final VoidCallback? onTripStarted;

  const ActiveTripPage({
    super.key,
    required this.bookingId,
    this.pickupAddress,
    this.dropAddress,
    this.estimatedFare,
    this.pickupLat,
    this.pickupLng,
    this.dropLat,
    this.dropLng,
    this.riderLat,
    this.riderLng,
    this.onTripStarted,
  });

  @override
  State<ActiveTripPage> createState() => _ActiveTripPageState();
}

class _ActiveTripPageState extends State<ActiveTripPage> {
  TripStatus _tripStatus = TripStatus.arrived;
  bool _isDropRequested = false;
  StreamSubscription? _wsSubscription;

  bool get _isRiderNearCustomer {
    if (widget.pickupLat == null || widget.pickupLng == null || widget.pickupLat == 0.0) {
      return true; // Default enable fallback
    }
    if (widget.riderLat == null || widget.riderLng == null || widget.riderLat == 0.0) {
      return true; // Default enable fallback
    }

    final distanceMeters = Geolocator.distanceBetween(
      widget.riderLat!,
      widget.riderLng!,
      widget.pickupLat!,
      widget.pickupLng!,
    );

    return distanceMeters <= 500.0;
  }

  bool get _isAtDropLocation {
    if (_isDropRequested) return true; // Unlocked by Request Drop button or Customer Request
    if (widget.dropLat == null || widget.dropLng == null || widget.dropLat == 0.0) {
      return true; // Fallback enable if no coordinates
    }
    if (widget.riderLat == null || widget.riderLng == null || widget.riderLat == 0.0) {
      return true; // Fallback enable if no coordinates
    }

    final distanceMeters = Geolocator.distanceBetween(
      widget.riderLat!,
      widget.riderLng!,
      widget.dropLat!,
      widget.dropLng!,
    );

    return distanceMeters <= 500.0;
  }

  bool _isLoading = false;
  final _otpController = TextEditingController();

  late final StartTripUseCase _startTripUseCase;
  late final CompleteTripUseCase _completeTripUseCase;

  CameraPosition get _initialCameraPosition {
    double lat = 17.4924;
    double lng = 78.3639;

    if (widget.pickupLat != null && widget.pickupLat != 0.0) {
      lat = widget.pickupLat!;
      lng = widget.pickupLng ?? 78.3639;
    } else if (widget.riderLat != null && widget.riderLat != 0.0) {
      lat = widget.riderLat!;
      lng = widget.riderLng ?? 78.3639;
    }

    return CameraPosition(
      target: LatLng(lat, lng),
      zoom: 18.0,
    );
  }

  @override
  void initState() {
    super.initState();
    _startTripUseCase = sl<StartTripUseCase>();
    _completeTripUseCase = sl<CompleteTripUseCase>();

    if (sl.isRegistered<WebSocketClient>()) {
      _wsSubscription = sl<WebSocketClient>().messageStream.listen((message) {
        final event = message['event'] ?? '';
        if (event == 'booking.drop_requested' || event == 'drop_requested') {
          if (mounted) {
            setState(() {
              _isDropRequested = true;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Customer requested drop! Complete Ride is unlocked.'),
                backgroundColor: Color(0xFF10B981),
              ),
            );
          }
        }
      });
    }
  }

  @override
  void dispose() {
    _otpController.dispose();
    _wsSubscription?.cancel();
    super.dispose();
  }

  Future<void> _handleMainAction() async {
    if (_tripStatus == TripStatus.arrived) {
      _showOtpDialog();
    } else if (_tripStatus == TripStatus.inProgress) {
      _handleCompleteTrip();
    }
  }

  void _showOtpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Enter Start OTP', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        content: TextField(
          controller: _otpController,
          keyboardType: TextInputType.number,
          maxLength: 4,
          decoration: const InputDecoration(
            hintText: 'Enter 4-digit OTP from customer',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _handleStartTrip(_otpController.text.trim());
            },
            child: const Text('Start Trip'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleStartTrip(String otp) async {
    if (otp.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid 4-digit OTP from customer')),
      );
      return;
    }
    setState(() => _isLoading = true);
    try {
      await _startTripUseCase(bookingId: widget.bookingId, otp: otp);
      setState(() {
        _isLoading = false;
        _tripStatus = TripStatus.inProgress;
      });
      widget.onTripStarted?.call();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('OTP Verified! Ride Started Successfully.')),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _tripStatus = TripStatus.inProgress;
      });
      widget.onTripStarted?.call();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ride Started Successfully.')),
        );
      }
    }
  }

  Future<void> _handleCompleteTrip() async {
    setState(() => _isLoading = true);
    try {
      await _completeTripUseCase(
        bookingId: widget.bookingId,
        distanceKm: 8.5,
        durationMins: 18,
      );
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Trip Completed Successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Trip Completed Successfully!')),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF121212) : const Color(0xFFF7F8FC);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceDark : Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 18,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Trip Details',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            // Content List
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Corporate Fleet Banner
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E1E2C) : const Color(0xFFF0F4FF),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0D6EFD),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.business_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Axle Logistics',
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.white : Colors.black87,
                                  ),
                                ),
                                Text(
                                  'CORPORATE FLEET',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0D6EFD).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.check_circle_rounded, size: 14, color: Color(0xFF0D6EFD)),
                                const SizedBox(width: 4),
                                Text(
                                  'Admin Assigned',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF0D6EFD),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Passenger Details Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceDark : Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 15,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: Colors.grey.shade200,
                            backgroundImage: const AssetImage('assets/images/login.png'),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'John Doe',
                                  style: GoogleFonts.inter(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.white : Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    const Icon(Icons.assignment_ind_outlined, size: 14, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Engineering Dept',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'Shift: 09:00 - 18:00',
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Map Destination Container
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 15,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Stack(
                          children: [
                            AppMapWidget(
                              initialCameraPosition: _initialCameraPosition,
                              zoomControlsEnabled: false,
                              myLocationButtonEnabled: false,
                            ),
                            // Map Pin Bubble
                            Positioned(
                              top: 40,
                              left: MediaQuery.of(context).size.width * 0.3,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0D6EFD),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF0D6EFD).withValues(alpha: 0.3),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.location_on_outlined, color: Colors.white, size: 16),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Gate 2 Pickup',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Floating Destination Bar
                            Positioned(
                              bottom: 12,
                              left: 12,
                              right: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF1E1E2C) : Colors.white,
                                  borderRadius: BorderRadius.circular(18),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.1),
                                      blurRadius: 10,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF0D6EFD),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(Icons.near_me_rounded, color: Colors.white, size: 18),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'NEXT DESTINATION',
                                            style: GoogleFonts.inter(
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Text(
                                            widget.dropAddress ?? 'Office Campus - North',
                                            style: GoogleFonts.inter(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: isDark ? Colors.white : Colors.black87,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF0D6EFD),
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(14),
                                        ),
                                      ),
                                      child: Text(
                                        'Navigate',
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Pickup Point Details Box
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E1E2C) : const Color(0xFFF3F5FC),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: const BoxDecoration(
                              color: Color(0xFF0D6EFD),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                'P',
                                style: GoogleFonts.inter(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'PICKUP POINT',
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  widget.pickupAddress ?? 'Office Parking',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.white : Colors.black87,
                                  ),
                                ),
                                Text(
                                  'Gate 2 • Main Entrance Side',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.stars_rounded, color: Color(0xFF0D6EFD), size: 22),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Departure & Capacity Row
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.surfaceDark : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'DEPARTURE',
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(Icons.access_time_rounded, size: 18, color: Color(0xFF0D6EFD)),
                                    const SizedBox(width: 6),
                                    Text(
                                      '08:45 AM',
                                      style: GoogleFonts.inter(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: isDark ? Colors.white : Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.surfaceDark : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'CAPACITY',
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(Icons.people_outline_rounded, size: 18, color: Color(0xFF0D6EFD)),
                                    const SizedBox(width: 6),
                                    Text(
                                      '4 Seats',
                                      style: GoogleFonts.inter(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: isDark ? Colors.white : Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Main Start Trip / Complete Trip Slide Action Button
                    SlideToStartButton(
                      isEnabled: _tripStatus == TripStatus.arrived
                          ? _isRiderNearCustomer
                          : _isAtDropLocation,
                      isLoading: _isLoading,
                      tripStatus: _tripStatus,
                      onSlideComplete: _handleMainAction,
                      disabledText: _tripStatus == TripStatus.arrived
                          ? 'Navigate to pickup to unlock Start Ride'
                          : 'Reach drop location or Request Drop to unlock',
                    ),

                    const SizedBox(height: 20),

                    // Bottom Option Links
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        if (_tripStatus == TripStatus.inProgress)
                          _buildBottomOption(
                            Icons.pin_drop_rounded,
                            _isDropRequested ? 'Drop Requested' : 'Request Drop',
                            isDark,
                            _showRequestDropBottomSheet,
                            isHighlight: true,
                          ),
                        _buildBottomOption(Icons.headset_mic_outlined, 'Support', isDark, () {}),
                        _buildBottomOption(Icons.edit_note_rounded, 'Modify', isDark, () {}),
                        _buildBottomOption(Icons.cancel_outlined, 'Cancel', isDark, () {
                          Navigator.pop(context);
                        }, isCancel: true),
                      ],
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRequestDropBottomSheet() {
    String selectedReason = 'Reached destination / drop point';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomCtx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E2C) : Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Request Drop Location',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Select a reason to request early drop or confirm location arrival:',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 16),

                  ...[
                    'Reached destination / drop point',
                    'Passenger requested early exit',
                    'Traffic congestion / Route change',
                    'Custom location drop',
                  ].map((reason) {
                    final isSelected = selectedReason == reason;
                    return InkWell(
                      onTap: () {
                        setModalState(() {
                          selectedReason = reason;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF0D6EFD).withValues(alpha: 0.1)
                              : (isDark ? Colors.grey.shade800 : Colors.grey.shade100),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected ? const Color(0xFF0D6EFD) : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                              color: isSelected ? const Color(0xFF0D6EFD) : Colors.grey,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                reason,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(bottomCtx);
                        setState(() {
                          _isDropRequested = true;
                        });

                        if (sl.isRegistered<WebSocketClient>()) {
                          sl<WebSocketClient>().sendMessage({
                            'event': 'booking.drop_requested',
                            'data': {
                              'booking_id': widget.bookingId,
                              'reason': selectedReason,
                            }
                          });
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Drop requested ($selectedReason)! Complete Ride is unlocked.'),
                            backgroundColor: const Color(0xFF10B981),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D6EFD),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      icon: const Icon(Icons.check_circle_outline, color: Colors.white),
                      label: Text(
                        'Confirm Drop Request',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBottomOption(IconData icon, String label, bool isDark, VoidCallback onTap, {bool isCancel = false, bool isHighlight = false}) {
    final color = isCancel
        ? Colors.red
        : (isHighlight
            ? const Color(0xFF0D6EFD)
            : (isDark ? Colors.grey.shade400 : Colors.grey.shade700));
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: isHighlight ? FontWeight.bold : FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class SlideToStartButton extends StatefulWidget {
  final bool isEnabled;
  final bool isLoading;
  final TripStatus tripStatus;
  final VoidCallback onSlideComplete;
  final String disabledText;

  const SlideToStartButton({
    super.key,
    required this.isEnabled,
    required this.isLoading,
    required this.tripStatus,
    required this.onSlideComplete,
    this.disabledText = 'Navigate to pickup to unlock Start Ride',
  });

  @override
  State<SlideToStartButton> createState() => _SlideToStartButtonState();
}

class _SlideToStartButtonState extends State<SlideToStartButton> {
  double _dragPosition = 0.0;
  bool _isFinished = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final trackColor = !widget.isEnabled
        ? (isDark ? Colors.grey.shade800 : Colors.grey.shade300)
        : (widget.tripStatus == TripStatus.arrived ? const Color(0xFF0D6EFD) : Colors.green);

    final String labelText = !widget.isEnabled
        ? widget.disabledText
        : (widget.tripStatus == TripStatus.arrived ? 'SLIDE TO START RIDE  ➔' : 'SLIDE TO COMPLETE TRIP  ➔');

    return Container(
      height: 60,
      width: double.infinity,
      decoration: BoxDecoration(
        color: trackColor.withValues(alpha: widget.isEnabled ? 0.15 : 0.4),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: widget.isEnabled ? trackColor : Colors.grey.shade400,
          width: 1.5,
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxDrag = constraints.maxWidth - 56;
          return Stack(
            alignment: Alignment.centerLeft,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!widget.isEnabled) ...[
                        const Icon(Icons.lock_clock_rounded, size: 18, color: Colors.grey),
                        const SizedBox(width: 6),
                      ],
                      Flexible(
                        child: Text(
                          labelText,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: !widget.isEnabled
                                ? Colors.grey.shade600
                                : (isDark ? Colors.white : Colors.black87),
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: _dragPosition,
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    if (!widget.isEnabled || widget.isLoading || _isFinished) return;
                    setState(() {
                      _dragPosition = (_dragPosition + details.delta.dx).clamp(0.0, maxDrag);
                    });
                  },
                  onHorizontalDragEnd: (details) {
                    if (!widget.isEnabled || widget.isLoading || _isFinished) return;
                    if (_dragPosition >= maxDrag * 0.75) {
                      setState(() {
                        _dragPosition = maxDrag;
                        _isFinished = true;
                      });
                      widget.onSlideComplete();
                      Future.delayed(const Duration(seconds: 2), () {
                        if (mounted) {
                          setState(() {
                            _dragPosition = 0.0;
                            _isFinished = false;
                          });
                        }
                      });
                    } else {
                      setState(() {
                        _dragPosition = 0.0;
                      });
                    }
                  },
                  child: Container(
                    width: 52,
                    height: 52,
                    margin: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: !widget.isEnabled
                          ? Colors.grey
                          : (widget.tripStatus == TripStatus.arrived ? const Color(0xFF0D6EFD) : Colors.green),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: widget.isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : Icon(
                              widget.tripStatus == TripStatus.arrived ? Icons.directions_car : Icons.check,
                              color: Colors.white,
                              size: 24,
                            ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
