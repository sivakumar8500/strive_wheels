import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/websocket_client.dart';
import '../../../../core/services/ride_ringtone_service.dart';
import '../../domain/usecases/complete_trip_usecase.dart';

/// Payment collection screen shown to rider after drop/trip is approved.
/// Displays dynamic Razorpay & UPI QR code for customer payment, cash confirmation, and auto-navigates on payment success.
class TripPaymentPage extends StatefulWidget {
  final int bookingId;
  final double estimatedFare;
  final double? finalFare;
  final bool isEarlyDrop;
  final double? actualDistanceKm;
  final String pickupAddress;
  final String dropAddress;
  final double? riderLat;
  final double? riderLng;
  final bool isCorporate;
  final String? serviceMode;
  /// Called after the rider completes trip/payment.
  final VoidCallback? onCompleted;

  const TripPaymentPage({
    super.key,
    required this.bookingId,
    required this.estimatedFare,
    this.finalFare,
    this.isEarlyDrop = false,
    this.actualDistanceKm,
    required this.pickupAddress,
    required this.dropAddress,
    this.riderLat,
    this.riderLng,
    this.isCorporate = false,
    this.serviceMode,
    this.onCompleted,
  });

  @override
  State<TripPaymentPage> createState() => _TripPaymentPageState();
}

class _TripPaymentPageState extends State<TripPaymentPage>
    with SingleTickerProviderStateMixin {
  bool _isCompleting = false;
  bool _isPaymentSuccess = false;
  bool _isGeneratingQr = false;
  String _selectedPaymentMethod = 'UPI / QR'; // Default to QR code for instant scan
  String _qrPayload = '';
  String _orderId = '';
  String _transactionId = '';
  Timer? _paymentPollTimer;
  StreamSubscription? _wsSubscription;

  late double _effectiveFare;
  late double _originalFare;
  late bool _isEarlyDrop;
  late bool _isCorporateRide;

  late final CompleteTripUseCase _completeTripUseCase;
  late final AnimationController _checkAnimController;
  late final Animation<double> _checkAnimation;

  @override
  void initState() {
    super.initState();
    if (sl.isRegistered<RideRingtoneService>()) {
      sl<RideRingtoneService>().stopCallingRingtone();
    }
    _completeTripUseCase = sl<CompleteTripUseCase>();
    _checkAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _checkAnimation = CurvedAnimation(
      parent: _checkAnimController,
      curve: Curves.elasticOut,
    );

    _isCorporateRide = widget.isCorporate || widget.serviceMode?.toUpperCase() == 'CORPORATE';
    _effectiveFare = widget.finalFare ?? widget.estimatedFare;
    _originalFare = widget.estimatedFare;
    _isEarlyDrop = widget.isEarlyDrop || (widget.finalFare != null && widget.finalFare! < widget.estimatedFare);

    if (_isCorporateRide) {
      _selectedPaymentMethod = 'Corporate Direct Billing';
    } else {
      _generateDynamicQrCode();
      _setupWebSocketListener();
      _startPaymentPolling();
    }
  }

  @override
  void dispose() {
    if (sl.isRegistered<RideRingtoneService>()) {
      sl<RideRingtoneService>().stopCallingRingtone();
    }
    _paymentPollTimer?.cancel();
    _wsSubscription?.cancel();
    _checkAnimController.dispose();
    super.dispose();
  }

  Future<void> _generateDynamicQrCode() async {
    setState(() {
      _isGeneratingQr = true;
    });

    final defaultUpiIntent =
        "upi://pay?pa=strivewheels@icici&pn=StriveWheels&am=${_effectiveFare.toStringAsFixed(2)}&cu=INR&tn=RidePayment_Booking_${widget.bookingId}&tr=order_strive_${widget.bookingId}";

    try {
      final dio = sl<Dio>();
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('user_token') ?? prefs.getString('token') ?? '';

      final response = await dio.post(
        '${ApiEndpoints.baseUrl}/payments/${widget.bookingId}/order',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data['data'] ?? response.data;
        final intent = data['upi_intent']?.toString() ?? defaultUpiIntent;
        final orderId = data['order_id']?.toString() ?? 'order_strive_${widget.bookingId}';
        final dynamic rawFare = data['amount'] ?? data['final_fare'] ?? _effectiveFare;
        final serverFare = rawFare is num ? rawFare.toDouble() : (double.tryParse(rawFare.toString()) ?? _effectiveFare);
        final isEarly = data['is_early_drop'] == true || (serverFare < _originalFare);

        if (mounted) {
          setState(() {
            _effectiveFare = serverFare;
            _isEarlyDrop = _isEarlyDrop || isEarly;
            _qrPayload = intent;
            _orderId = orderId;
            _isGeneratingQr = false;
          });
          return;
        }
      }
    } catch (e) {
      debugPrint('Error creating dynamic Razorpay QR order: $e');
    }

    if (mounted) {
      setState(() {
        _qrPayload = defaultUpiIntent;
        _orderId = 'order_strive_${widget.bookingId}';
        _isGeneratingQr = false;
      });
    }
  }

  void _setupWebSocketListener() {
    try {
      final wsClient = sl<WebSocketClient>();
      _wsSubscription = wsClient.messageStream.listen((event) {
        final evt = event['event']?.toString() ?? '';
        if (evt == 'booking.payment_completed' ||
            evt == 'booking.payment_success' ||
            evt == 'payment.completed') {
          final data = event['data'] ?? event;
          final bId = data['booking_id'] ?? data['id'];
          if (bId == widget.bookingId || bId.toString() == widget.bookingId.toString()) {
            final txId = data['transaction_id']?.toString() ?? _orderId;
            _handlePaymentSuccess(transactionId: txId, method: data['payment_method']?.toString() ?? 'Online UPI');
          }
        }
      });
    } catch (e) {
      debugPrint('Error setting up payment WS listener: $e');
    }
  }

  void _startPaymentPolling() {
    _paymentPollTimer?.cancel();
    _paymentPollTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      _checkPaymentStatus();
    });
  }

  Future<void> _checkPaymentStatus() async {
    if (_isPaymentSuccess || !mounted) return;

    try {
      final dio = sl<Dio>();
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('user_token') ?? prefs.getString('token') ?? '';

      final response = await dio.get(
        '${ApiEndpoints.baseUrl}/payments/${widget.bookingId}/status',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data['data'] ?? response.data;
        if (data['is_paid'] == true ||
            data['payment_status'] == 'COMPLETED' ||
            data['booking_status'] == 'PAYMENT_COMPLETED' ||
            data['booking_status'] == 'COMPLETED') {
          _handlePaymentSuccess(
            transactionId: data['transaction_id']?.toString() ?? _orderId,
            method: data['payment_method']?.toString() ?? 'Online UPI',
          );
        }
      }
    } catch (e) {
      // Ignore background poll errors
    }
  }

  Future<void> _confirmCashPayment() async {
    setState(() => _isCompleting = true);

    try {
      final dio = sl<Dio>();
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('user_token') ?? prefs.getString('token') ?? '';

      await dio.post(
        '${ApiEndpoints.baseUrl}/payments/${widget.bookingId}/confirm-cash',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );
    } catch (e) {
      debugPrint('Cash payment confirmation error (proceeding with local complete): $e');
    }

    await _handlePaymentSuccess(
      transactionId: 'CASH_${widget.bookingId}_${DateTime.now().millisecondsSinceEpoch}',
      method: 'Cash',
    );
  }

  Future<void> _confirmCorporateCompletion() async {
    setState(() => _isCompleting = true);
    await _handlePaymentSuccess(
      transactionId: 'CORP_${widget.bookingId}_${DateTime.now().millisecondsSinceEpoch}',
      method: 'Corporate Direct Billing',
    );
  }

  Future<void> _handlePaymentSuccess({required String transactionId, String method = 'UPI / QR'}) async {
    if (_isPaymentSuccess || !mounted) return;

    _paymentPollTimer?.cancel();

    setState(() {
      _isPaymentSuccess = true;
      _transactionId = transactionId;
      _isCompleting = false;
    });

    _checkAnimController.forward();

    try {
      await _completeTripUseCase(
        bookingId: widget.bookingId,
        distanceKm: 8.5,
        durationMins: 18,
        riderLat: widget.riderLat,
        riderLng: widget.riderLng,
      );
    } catch (e) {
      debugPrint('Complete trip usecase error: $e');
    }

    // After 2.5 seconds, auto-move forward to home
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        widget.onCompleted?.call();
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;

    return PopScope(
      canPop: !_isCompleting,
      child: Scaffold(
        backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFF8FAFC),
        body: SafeArea(
          child: _isPaymentSuccess
              ? _buildPaymentSuccessView(isDark, screenWidth)
              : (_isCorporateRide
                  ? _buildCorporateCollectionForm(isDark, screenWidth)
                  : _buildPaymentCollectionForm(isDark, screenWidth)),
        ),
      ),
    );
  }

  Widget _buildCorporateCollectionForm(bool isDark, double screenWidth) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10),

          // Header Banner
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.business_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Corporate Ride Completed',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Direct Company Invoicing',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Corporate Billing Notice Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.verified_user_rounded,
                    color: Color(0xFF10B981),
                    size: 36,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'CORPORATE BILLED TRIP',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                    color: const Color(0xFF10B981),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Payment is handled via corporate invoicing. Do not collect any cash or digital payment from the passenger.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                Divider(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
                const SizedBox(height: 10),

                // Pickup & Drop Row
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.pickupAddress,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(color: Color(0xFFEF4444), shape: BoxShape.rectangle),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.dropAddress,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Complete Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _isCompleting ? null : _confirmCorporateCompletion,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: _isCompleting
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                    )
                  : Text(
                      'Complete Corporate Trip',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSuccessView(bool isDark, double screenWidth) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _checkAnimation,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF10B981), Color(0xFF059669)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF10B981).withValues(alpha: 0.35),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(Icons.check_rounded, color: Colors.white, size: 58),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              _isCorporateRide ? 'Corporate Ride Completed!' : 'Payment Received!',
              style: GoogleFonts.inter(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 8),
            if (!_isCorporateRide) ...[
              Text(
                '₹${_effectiveFare.toStringAsFixed(2)}',
                style: GoogleFonts.inter(
                  fontSize: 38,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF10B981),
                ),
              ),
              const SizedBox(height: 6),
            ] else ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Corporate Direct Billing',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF10B981),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
            Text(
              _isCorporateRide
                  ? 'Trip billed directly to corporate account. No passenger payment required.'
                  : (_isEarlyDrop
                      ? 'Early drop completed. Fare settled based on travelled distance.'
                      : 'Trip completed and payment settled successfully.'),
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 28),

            // Receipt Box
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildReceiptRow('Booking ID', '#${widget.bookingId}', isDark),
                  Divider(height: 20, color: isDark ? Colors.grey.shade800 : Colors.grey.shade100),
                  _buildReceiptRow('Payment Method', _selectedPaymentMethod, isDark),
                  Divider(height: 20, color: isDark ? Colors.grey.shade800 : Colors.grey.shade100),
                  _buildReceiptRow(
                    'Transaction Ref',
                    _transactionId.isNotEmpty ? _transactionId : 'TXN_${widget.bookingId}',
                    isDark,
                  ),
                  if (_isEarlyDrop) ...[
                    Divider(height: 20, color: isDark ? Colors.grey.shade800 : Colors.grey.shade100),
                    _buildReceiptRow('Trip Type', 'Early Drop (Distance Adjusted)', isDark),
                  ],
                  Divider(height: 20, color: isDark ? Colors.grey.shade800 : Colors.grey.shade100),
                  _buildReceiptRow('Status', 'COMPLETED', isDark, isSuccess: true),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Continue Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  widget.onCompleted?.call();
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'Back to Home / Next Ride',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentCollectionForm(bool isDark, double screenWidth) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10),

          // Header Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _isEarlyDrop
                    ? [const Color(0xFFF59E0B), const Color(0xFFD97706)]
                    : [const Color(0xFF0D6EFD), const Color(0xFF00C6FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: (_isEarlyDrop ? const Color(0xFFF59E0B) : const Color(0xFF0D6EFD)).withValues(alpha: 0.25),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isEarlyDrop ? Icons.alt_route_rounded : Icons.check_circle_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isEarlyDrop ? 'Early Drop Accepted' : 'Trip Completed!',
                        style: GoogleFonts.inter(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _isEarlyDrop
                            ? 'Fare updated based on actual distance travelled'
                            : 'Collect ride payment from customer',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Fare Summary Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                if (_isEarlyDrop) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF59E0B).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.info_outline, size: 13, color: Color(0xFFD97706)),
                        const SizedBox(width: 5),
                        Text(
                          'DISTANCE-BASED PRICING APPLIED',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFD97706),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ] else ...[
                  Text(
                    'AMOUNT TO COLLECT',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
                    ),
                  ),
                  const SizedBox(height: 6),
                ],
                Text(
                  '₹${_effectiveFare.toStringAsFixed(2)}',
                  style: GoogleFonts.inter(
                    fontSize: 42,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF10B981),
                  ),
                ),
                if (_isEarlyDrop && _originalFare > _effectiveFare) ...[
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Original Route Fare: ',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        '₹${_originalFare.toStringAsFixed(2)}',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          decoration: TextDecoration.lineThrough,
                          color: Colors.red.shade400,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 16),
                Divider(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
                const SizedBox(height: 10),

                // Pickup & Drop Row
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.pickupAddress,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(color: Color(0xFFEF4444), shape: BoxShape.rectangle),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.dropAddress,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Payment Method Selector
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SELECT PAYMENT METHOD',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildPaymentChip('UPI / QR', Icons.qr_code_2_rounded, const Color(0xFF0D6EFD), isDark),
                    const SizedBox(width: 10),
                    _buildPaymentChip('Cash', Icons.money_rounded, const Color(0xFF10B981), isDark),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Dynamic QR Code Section
          if (_selectedPaymentMethod == 'UPI / QR')
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0D6EFD).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.flash_on_rounded, size: 14, color: Color(0xFF0D6EFD)),
                            const SizedBox(width: 4),
                            Text(
                              'DYNAMIC RAZORPAY & UPI QR',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF0D6EFD),
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Real Dynamic QR Code View
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFF0D6EFD).withValues(alpha: 0.2),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: _isGeneratingQr
                        ? SizedBox(
                            width: screenWidth * 0.5,
                            height: screenWidth * 0.5,
                            child: const Center(child: CircularProgressIndicator()),
                          )
                        : QrImageView(
                            data: _qrPayload.isNotEmpty
                                ? _qrPayload
                                : 'upi://pay?pa=strivewheels@icici&pn=StriveWheels&am=${_effectiveFare.toStringAsFixed(2)}&cu=INR',
                            version: QrVersions.auto,
                            size: screenWidth * 0.52,
                            backgroundColor: Colors.white,
                            eyeStyle: const QrEyeStyle(
                              eyeShape: QrEyeShape.square,
                              color: Color(0xFF0D6EFD),
                            ),
                            dataModuleStyle: const QrDataModuleStyle(
                              dataModuleShape: QrDataModuleShape.square,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Ask customer to scan with GPay, PhonePe, Paytm, or BHIM',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.grey.shade300 : const Color(0xFF334155),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF10B981)),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Awaiting customer payment...',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: const Color(0xFF10B981),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

          // Cash Collection Section
          if (_selectedPaymentMethod == 'Cash')
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.payments_rounded, size: 48, color: Color(0xFF10B981)),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Collect Cash from Customer',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Please collect ₹${widget.estimatedFare.toStringAsFixed(2)} in cash, then tap "Confirm Cash Received" below.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 24),

          // Action Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _isCompleting
                  ? null
                  : () {
                      if (_selectedPaymentMethod == 'Cash') {
                        _confirmCashPayment();
                      } else {
                        // Manually check / complete
                        _checkPaymentStatus();
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedPaymentMethod == 'Cash'
                    ? const Color(0xFF10B981)
                    : const Color(0xFF0D6EFD),
                foregroundColor: Colors.white,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: _isCompleting
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                    )
                  : Text(
                      _selectedPaymentMethod == 'Cash'
                          ? 'Confirm Cash Received'
                          : 'Check Payment Status',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildPaymentChip(String label, IconData icon, Color color, bool isDark) {
    final isSelected = _selectedPaymentMethod == label;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedPaymentMethod = label;
          });
        },
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected
                ? color.withValues(alpha: isDark ? 0.25 : 0.1)
                : (isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF1F5F9)),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? color : (isDark ? Colors.grey.shade800 : Colors.grey.shade300),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: isSelected ? color : (isDark ? Colors.grey.shade400 : Colors.grey.shade600), size: 22),
              const SizedBox(height: 6),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected
                      ? color
                      : (isDark ? Colors.grey.shade300 : const Color(0xFF334155)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value, bool isDark, {bool isSuccess = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isSuccess
                ? const Color(0xFF10B981)
                : (isDark ? Colors.white : const Color(0xFF1E293B)),
          ),
        ),
      ],
    );
  }
}
