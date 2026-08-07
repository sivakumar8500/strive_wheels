import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../home/presentation/widgets/home_bottom_nav_bar.dart';
import '../bloc/driver_search_bloc.dart';
import '../bloc/driver_search_event.dart';
import '../bloc/driver_search_state.dart';

/// Searching for Nearby Drivers Page matching reference UI design.
class DriverSearchPage extends StatefulWidget {
  const DriverSearchPage({super.key});

  @override
  State<DriverSearchPage> createState() => _DriverSearchPageState();
}

class _DriverSearchPageState extends State<DriverSearchPage> {
  @override
  void initState() {
    super.initState();
    context.read<DriverSearchBloc>().add(const LoadDriverSearchEvent());
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
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryBlue),
            );
          }

          final data = state.driverSearch;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Map Radar Card
                _buildRadarCard(context, isDark, data),
                const SizedBox(height: 16),

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
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Concentric Radar Rings
                Container(
                  width: 170,
                  height: 170,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primaryBlue.withOpacity(0.2),
                      width: 1.5,
                    ),
                  ),
                ),
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primaryBlue.withOpacity(0.4),
                      width: 1.5,
                    ),
                  ),
                ),
                // Center Car Badge
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryBlue.withOpacity(0.4),
                        blurRadius: 16,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.directions_car_filled_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text(
                  data?.statusTitle ?? 'Searching for nearby drivers...',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  data?.statusSubtitle ?? 'Connecting you to the nearest premium vehicle.',
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

  Widget _buildEstimatedCard(BuildContext context, bool isDark, dynamic data) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBgDark : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.04),
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
            subtitle: '${data?.orderTime ?? "10:42 AM"} • Order confirmed',
            isDone: true,
            hasLine: true,
          ),
          _buildTimelineStep(
            context: context,
            isDark: isDark,
            icon: Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: AppColors.primaryBlue,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.sync_rounded, color: Colors.white, size: 16),
            ),
            title: 'Searching',
            subtitle: data?.scanRadiusText ?? 'Scanning 1.2km radius...',
            isCurrent: true,
            hasLine: true,
          ),
          _buildTimelineStep(
            context: context,
            isDark: isDark,
            icon: Icon(
              Icons.circle_outlined,
              color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
              size: 24,
            ),
            title: 'Accepted',
            subtitle: 'Waiting for driver',
            isPending: true,
            hasLine: true,
          ),
          _buildTimelineStep(
            context: context,
            isDark: isDark,
            icon: Icon(
              Icons.location_on_outlined,
              color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
              size: 24,
            ),
            title: 'Assigned',
            subtitle: 'Vehicle details arrival',
            isPending: true,
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
    bool isPending = false,
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
