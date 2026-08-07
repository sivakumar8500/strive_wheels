import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../home/presentation/bloc/home_bloc.dart';
import '../../../home/presentation/bloc/home_event.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../home/presentation/widgets/home_bottom_nav_bar.dart';
import '../../../payment_method/presentation/bloc/payment_method_bloc.dart';
import '../../../payment_method/presentation/pages/payment_method_page.dart';
import '../bloc/trip_overview_bloc.dart';
import '../bloc/trip_overview_event.dart';
import '../bloc/trip_overview_state.dart';

/// Trip Overview Page matching exact reference UI design (Image 2).
class TripOverviewPage extends StatefulWidget {
  final String vehicleId;

  const TripOverviewPage({
    super.key,
    this.vehicleId = 'v1',
  });

  @override
  State<TripOverviewPage> createState() => _TripOverviewPageState();
}

class _TripOverviewPageState extends State<TripOverviewPage> {
  final TextEditingController _promoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<TripOverviewBloc>().add(LoadTripOverviewEvent(widget.vehicleId));
  }

  @override
  void dispose() {
    _promoController.dispose();
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
        elevation: 0,
        leading: IconButton(
          key: const Key('trip_overview_back_button'),
          icon: Icon(
            Icons.arrow_back_rounded,
            color: isDark ? AppColors.white : AppColors.onboardingTextPrimaryLight,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Strive',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryBlue,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_none_rounded,
              color: isDark ? AppColors.white : AppColors.onboardingTextPrimaryLight,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No new notifications')),
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<TripOverviewBloc, TripOverviewState>(
        listener: (context, state) {
          if (state.actionMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.actionMessage!),
                backgroundColor: AppColors.primaryBlue,
              ),
            );
          }

          if (state.isBookingConfirmed) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BlocProvider<PaymentMethodBloc>(
                  create: (_) => sl<PaymentMethodBloc>(),
                  child: PaymentMethodPage(
                    vehicleId: widget.vehicleId,
                  ),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading || state.tripOverview == null) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryBlue),
            );
          }

          final overview = state.tripOverview!;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Trip Overview Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardBgDark : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF334155)
                          : const Color(0xFFF1F5F9),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Trip Overview',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.white
                              : AppColors.onboardingTextPrimaryLight,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_rounded,
                            color: AppColors.primaryBlue,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'PICKUP LOCATION',
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? AppColors.textSecondaryDark
                                        : const Color(0xFF64748B),
                                  ),
                                ),
                                Text(
                                  overview.pickupLocation,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
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
                      Padding(
                        padding: const EdgeInsets.only(left: 9),
                        child: Container(
                          height: 18,
                          width: 2,
                          color: Colors.grey.shade300,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.navigation_rounded,
                            color: Color(0xFF475569),
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'DESTINATION',
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? AppColors.textSecondaryDark
                                        : const Color(0xFF64748B),
                                  ),
                                ),
                                Text(
                                  overview.destination,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
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
                      const SizedBox(height: 14),
                      Divider(
                        color: isDark
                            ? const Color(0xFF334155)
                            : const Color(0xFFF1F5F9),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'TRIP TYPE',
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? AppColors.textSecondaryDark
                                        : const Color(0xFF64748B),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  overview.tripType,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: isDark
                                        ? AppColors.white
                                        : AppColors.onboardingTextPrimaryLight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'DISTANCE',
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? AppColors.textSecondaryDark
                                        : const Color(0xFF64748B),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  overview.distanceText,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
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
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 2. Executive Luxury Sedan Card
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardBgDark : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF334155)
                          : const Color(0xFFF1F5F9),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 90,
                        height: 70,
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF1E293B)
                              : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            overview.vehicleImagePath,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                              Icons.directions_car_rounded,
                              color: AppColors.primaryBlue,
                              size: 40,
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
                              overview.vehicleName,
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? AppColors.white
                                    : AppColors.onboardingTextPrimaryLight,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 6,
                              runSpacing: 4,
                              children: [
                                _SmallPill(text: overview.vehicleSeats),
                                _SmallPill(text: overview.vehicleLuggage),
                                _SmallPill(text: overview.vehicleAmenity),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 3. Payment & Offers Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardBgDark : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF334155)
                          : const Color(0xFFF1F5F9),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Payment & Offers',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.white
                              : AppColors.onboardingTextPrimaryLight,
                        ),
                      ),
                      const SizedBox(height: 14),
                      // Wallet Selection Box
                      GestureDetector(
                        onTap: () {
                          context.read<TripOverviewBloc>().add(
                                ToggleWalletPaymentEvent(
                                    !state.isWalletSelected),
                              );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: state.isWalletSelected
                                  ? AppColors.primaryBlue
                                  : (isDark
                                      ? const Color(0xFF334155)
                                      : const Color(0xFFE2E8F0)),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.account_balance_wallet_rounded,
                                color: AppColors.primaryBlue,
                                size: 22,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Elite Wallet',
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: isDark
                                            ? AppColors.white
                                            : AppColors.onboardingTextPrimaryLight,
                                      ),
                                    ),
                                    Text(
                                      'Available Balance: \$${overview.walletBalance.toStringAsFixed(2)}',
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        color: isDark
                                            ? AppColors.textSecondaryDark
                                            : AppColors.onboardingTextSecondaryLight,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Radio<bool>(
                                value: true,
                                groupValue: state.isWalletSelected,
                                activeColor: AppColors.primaryBlue,
                                onChanged: (val) {
                                  context.read<TripOverviewBloc>().add(
                                        ToggleWalletPaymentEvent(val ?? false),
                                      );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      // Promo Code Row
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 44,
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(0xFF1E293B)
                                    : const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.local_offer_outlined,
                                    color: Color(0xFF64748B),
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TextField(
                                      controller: _promoController,
                                      style: GoogleFonts.inter(fontSize: 13),
                                      decoration: InputDecoration(
                                        hintText: 'Promo Code',
                                        hintStyle: GoogleFonts.inter(
                                          fontSize: 13,
                                          color: const Color(0xFF94A3B8),
                                        ),
                                        border: InputBorder.none,
                                        isDense: true,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            height: 44,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryBlue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                context.read<TripOverviewBloc>().add(
                                      ApplyPromoCodeEvent(
                                        _promoController.text,
                                      ),
                                    );
                              },
                              child: Text(
                                'Apply',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 4. Fare Breakdown Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardBgDark : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF334155)
                          : const Color(0xFFF1F5F9),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Fare Breakdown',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.white
                              : AppColors.onboardingTextPrimaryLight,
                        ),
                      ),
                      const SizedBox(height: 14),
                      _FareRow(
                        label: 'Base Fare',
                        value: '\$${overview.baseFare.toStringAsFixed(2)}',
                      ),
                      _FareRow(
                        label: 'Distance Charge (14km)',
                        value:
                            '\$${overview.distanceCharge.toStringAsFixed(2)}',
                      ),
                      _FareRow(
                        label: 'Service Surcharge ⓘ',
                        value:
                            '\$${overview.serviceSurcharge.toStringAsFixed(2)}',
                      ),
                      _FareRow(
                        label: 'Taxes & Fees (5%)',
                        value: '\$${overview.taxesFees.toStringAsFixed(2)}',
                      ),
                      const SizedBox(height: 10),
                      Divider(
                        color: isDark
                            ? const Color(0xFF334155)
                            : const Color(0xFFE2E8F0),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'GRAND TOTAL',
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                  color: isDark
                                      ? AppColors.textSecondaryDark
                                      : const Color(0xFF64748B),
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    '\$${overview.grandTotal.toStringAsFixed(2)}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryBlue,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    overview.currency,
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: isDark
                                          ? AppColors.textSecondaryDark
                                          : const Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      // Confirm Booking Primary Button
                      AppButton(
                        title: 'Confirm Booking  ➔',
                        isEnabled: true,
                        isLoading: false,
                        onTap: () {
                          context
                              .read<TripOverviewBloc>()
                              .add(const ConfirmFinalBookingEvent());
                        },
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: Text(
                          'By confirming, you agree to our Terms of Service',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.onboardingTextSecondaryLight,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // 5. Trust Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.verified_user_outlined,
                      size: 16,
                      color: Color(0xFF64748B),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Secure Checkout',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(width: 20),
                    const Icon(
                      Icons.history_toggle_off_rounded,
                      size: 16,
                      color: Color(0xFF64748B),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '24/7 Support',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
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
          try {
            context.read<HomeBloc>().add(ChangeNavTabEvent(index));
          } catch (_) {}
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }
}

class _SmallPill extends StatelessWidget {
  final String text;

  const _SmallPill({required this.text});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
        ),
      ),
    );
  }
}

class _FareRow extends StatelessWidget {
  final String label;
  final String value;

  const _FareRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.onboardingTextSecondaryLight,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.white
                  : AppColors.onboardingTextPrimaryLight,
            ),
          ),
        ],
      ),
    );
  }
}
