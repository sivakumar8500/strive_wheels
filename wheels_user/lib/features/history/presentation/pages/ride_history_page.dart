import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../booking/presentation/pages/ride_route_map_page.dart';
import '../../domain/entities/past_ride_item_entity.dart';
import '../bloc/ride_history_bloc.dart';
import '../bloc/ride_history_event.dart';
import '../bloc/ride_history_state.dart';
import '../widgets/monthly_summary_card.dart';
import '../widgets/past_ride_card.dart';
import '../widgets/ride_history_header.dart';
import '../widgets/ride_history_top_bar.dart';
import '../widgets/segmented_filter_bar.dart';

/// Main Ride History Page matching exact reference UI design.
class RideHistoryPage extends StatefulWidget {
  final VoidCallback? onMenuTap;
  final VoidCallback? onNotificationTap;
  final void Function(PastRideItemEntity ride)? onBookAgainNavigate;

  const RideHistoryPage({
    super.key,
    this.onMenuTap,
    this.onNotificationTap,
    this.onBookAgainNavigate,
  });

  @override
  State<RideHistoryPage> createState() => _RideHistoryPageState();
}

class _RideHistoryPageState extends State<RideHistoryPage> {
  @override
  void initState() {
    super.initState();
    context.read<RideHistoryBloc>().add(const LoadRideHistoryEvent());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark ? AppColors.onboardingBgDark : const Color(0xFFF8FAFC);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: RideHistoryTopBar(
        onMenuTap: widget.onMenuTap,
        onNotificationTap: widget.onNotificationTap,
      ),
      body: BlocConsumer<RideHistoryBloc, RideHistoryState>(
        listener: (context, state) {
          // No intrusive snackbars
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryBlue,
              ),
            );
          }

          final entity = state.historyEntity;
          final rides = entity?.pastRides ?? [];

          // Filter rides based on selected filter tab
          final filteredRides = rides.where((ride) {
            if (state.selectedFilterIndex == 1) {
              // Rides only (Bike, Mini, Auto, Cab)
              return ride.serviceType.toLowerCase() != 'deliveries';
            } else if (state.selectedFilterIndex == 2) {
              // Deliveries only
              return ride.serviceType.toLowerCase() == 'deliveries' ||
                  ride.serviceType.toLowerCase() == 'parcel' ||
                  ride.serviceType.toLowerCase() == 'courier';
            }
            return true; // All trips
          }).toList();

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 8,
              bottom: 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Header Section
                RideHistoryHeader(
                  onFilterTap: () {
                    context
                        .read<RideHistoryBloc>()
                        .add(const OpenFilterOptionsEvent());
                  },
                ),

                const SizedBox(height: 12),

                // 2. Segmented Filter Tabs (All trips, Rides, Deliveries)
                SegmentedFilterBar(
                  selectedIndex: state.selectedFilterIndex,
                  onTabSelected: (index) {
                    context
                        .read<RideHistoryBloc>()
                        .add(FilterTripsTabEvent(index));
                  },
                ),

                const SizedBox(height: 12),

                // 3. Monthly Summary Card
                MonthlySummaryCard(
                  title: entity?.monthlySummaryTitle ?? AppStrings.juneRideSummary,
                  tripCountText: entity?.tripCountText ?? AppStrings.tripsSummaryCount,
                  distanceText: entity?.distanceText ?? AppStrings.kmThisMonth,
                  spentText: entity?.spentText ?? AppStrings.totalSpentAmount,
                ),

                const SizedBox(height: 16),

                // 4. Past Rides Section Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.pastRides,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.white
                            : AppColors.onboardingTextPrimaryLight,
                      ),
                    ),
                    Text(
                      AppStrings.jun2026,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.onboardingTextSecondaryLight,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // 5. List of Past Ride Cards
                if (filteredRides.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Center(
                      child: Text(
                        'No trips found',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.onboardingTextSecondaryLight,
                        ),
                      ),
                    ),
                  )
                else
                  ...filteredRides.map((ride) {
                    return PastRideCard(
                      ride: ride,
                      onBookAgainTap: () {
                        context.read<RideHistoryBloc>().add(
                              BookAgainEvent(
                                rideId: ride.id,
                                rideTitle: ride.title,
                              ),
                            );

                        if (widget.onBookAgainNavigate != null) {
                          widget.onBookAgainNavigate!(ride);
                          return;
                        }

                        final pickup = ride.effectivePickupAddress;
                        final drop = ride.effectiveDropAddress;
                        final pickupLatLng = LatLng(
                          ride.pickupLat ?? 17.4483,
                          ride.pickupLng ?? 78.3915,
                        );
                        final dropLatLng = LatLng(
                          ride.dropLat ?? 17.4938,
                          ride.dropLng ?? 78.3995,
                        );

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => RideRouteMapPage(
                              pickupTitle: pickup,
                              pickupAddress: pickup,
                              dropTitle: drop,
                              dropAddress: drop,
                              pickupLatLng: pickupLatLng,
                              dropLatLng: dropLatLng,
                              bookingMode: 'INSTANT',
                              isCorporate: ride.isCorporate,
                            ),
                          ),
                        );
                      },
                    );
                  }),
              ],
            ),
          );
        },
      ),
    );
  }
}
