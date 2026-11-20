import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection_container.dart';
import '../../../home/presentation/bloc/home_bloc.dart';
import '../../../home/presentation/bloc/home_event.dart';
import '../../../home/presentation/widgets/home_bottom_nav_bar.dart';
import '../../../trip_overview/presentation/bloc/trip_overview_bloc.dart';
import '../../../trip_overview/presentation/pages/trip_overview_page.dart';
import '../../../vehicle_details/presentation/bloc/vehicle_details_bloc.dart';
import '../../../vehicle_details/presentation/pages/vehicle_details_page.dart';
import '../../domain/entities/vehicle_option_entity.dart';
import '../bloc/booking_bloc.dart';
import '../bloc/booking_event.dart';
import '../bloc/booking_state.dart';
import '../widgets/vehicle_card.dart';

/// Vehicle Search Results Page matching exact reference UI design (Image 2 & 3).
class VehicleSearchResultsPage extends StatelessWidget {
  const VehicleSearchResultsPage({super.key});

  void _showVehicleDetailsBottomSheet(
    BuildContext context,
    VehicleOptionEntity vehicle,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppColors.onboardingBgDark : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (bottomSheetContext) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[700] : Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    vehicle.name,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.white
                          : AppColors.onboardingTextPrimaryLight,
                    ),
                  ),
                  Text(
                    vehicle.price,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                vehicle.specs,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.onboardingTextSecondaryLight,
                ),
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 12),
              Text(
                'Vehicle Features',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppColors.white
                      : AppColors.onboardingTextPrimaryLight,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  _FeatureChip(icon: Icons.ac_unit_rounded, label: 'A/C Enabled'),
                  _FeatureChip(icon: Icons.star_rounded, label: '${vehicle.rating} Rating'),
                  _FeatureChip(icon: Icons.timer_rounded, label: '${vehicle.eta} ETA'),
                  _FeatureChip(icon: Icons.wifi_rounded, label: 'Free Wi-Fi'),
                  _FeatureChip(icon: Icons.security_rounded, label: 'Safety Verified'),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(bottomSheetContext).pop();
                    context.read<BookingBloc>().add(
                          BookVehicleNowEvent(
                            vehicleId: vehicle.id,
                            vehicleName: vehicle.name,
                          ),
                        );
                  },
                  child: Text(
                    'Confirm & Book (${vehicle.price})',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark ? AppColors.onboardingBgDark : const Color(0xFFF8FAFC);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: BlocConsumer<BookingBloc, BookingState>(
          listener: (context, state) {
            if (state.actionMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.actionMessage!),
                  backgroundColor: AppColors.primaryBlue,
                ),
              );
            }
          },
          builder: (context, state) {
            final vehicles = state.availableVehicles;

            return Column(
              children: [
                // 1. Top Header Route Bar (5th Avenue ➔ Central Park · Instant)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardBgDark : Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Back to Location Picker Button
                      IconButton(
                        key: const Key('back_to_location_picker'),
                        icon: Icon(
                          Icons.arrow_back_rounded,
                          color: isDark
                              ? AppColors.white
                              : AppColors.onboardingTextPrimaryLight,
                        ),
                        onPressed: () {
                          // Reset vehicle results state and pop if pushed
                          context
                              .read<BookingBloc>()
                              .add(const ResetVehicleResultsEvent());
                          context
                              .read<BookingBloc>()
                              .add(const LoadBookingDataEvent());
                          if (Navigator.of(context).canPop()) {
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                      const SizedBox(width: 4),

                      // Route Summary Text
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  state.pickupLocation.split(',').first,
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: isDark
                                        ? AppColors.white
                                        : AppColors.onboardingTextPrimaryLight,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 6),
                                  child: Icon(
                                    Icons.arrow_forward_rounded,
                                    size: 14,
                                    color: AppColors.primaryBlue,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    state.destination == AppStrings.defaultDestination
                                        ? 'Central Park'
                                        : state.destination,
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: isDark
                                          ? AppColors.white
                                          : AppColors.onboardingTextPrimaryLight,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Select your vehicle option',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: isDark
                                    ? AppColors.textSecondaryDark
                                    : AppColors.onboardingTextSecondaryLight,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Instant Pill Tag
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          AppStrings.rideTypeInstant,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 2. Scrollable List of Available Vehicles
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 16,
                      bottom: 24,
                    ),
                    child: Column(
                      children: vehicles.map((vehicle) {
                        return VehicleCard(
                          vehicle: vehicle,
                          onViewDetailsTap: () {
                            context.read<BookingBloc>().add(
                                  SelectVehicleEvent(
                                    vehicleId: vehicle.id,
                                    vehicleName: vehicle.name,
                                  ),
                                );
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => BlocProvider<VehicleDetailsBloc>(
                                  create: (_) => sl<VehicleDetailsBloc>(),
                                  child: VehicleDetailsPage(
                                    vehicleId: vehicle.id,
                                  ),
                                ),
                              ),
                            );
                          },
                          onBookNowTap: () {
                            context.read<BookingBloc>().add(
                                  BookVehicleNowEvent(
                                    vehicleId: vehicle.id,
                                    vehicleName: vehicle.name,
                                  ),
                                );
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => BlocProvider<TripOverviewBloc>(
                                  create: (_) => sl<TripOverviewBloc>(),
                                  child: TripOverviewPage(
                                    vehicleId: vehicle.id,
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
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

class _FeatureChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FeatureChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBgDark : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.primaryBlue),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
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
