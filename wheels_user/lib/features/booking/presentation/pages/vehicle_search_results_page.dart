import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../bloc/booking_bloc.dart';
import '../bloc/booking_event.dart';
import '../bloc/booking_state.dart';
import '../widgets/vehicle_card.dart';

/// Vehicle Search Results Page matching exact reference UI design (Image 2).
class VehicleSearchResultsPage extends StatelessWidget {
  const VehicleSearchResultsPage({super.key});

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
                          // Reload/reset booking state to show location picker
                          context
                              .read<BookingBloc>()
                              .add(const LoadBookingDataEvent());
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
                          },
                          onBookNowTap: () {
                            context.read<BookingBloc>().add(
                                  BookVehicleNowEvent(
                                    vehicleId: vehicle.id,
                                    vehicleName: vehicle.name,
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
    );
  }
}
