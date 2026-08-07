import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../history/presentation/widgets/ride_history_top_bar.dart';
import '../bloc/booking_bloc.dart';
import '../bloc/booking_event.dart';
import '../bloc/booking_state.dart';
import '../widgets/location_selector_card.dart';
import '../widgets/recent_journeys_list.dart';
import 'vehicle_search_results_page.dart';

/// Location Search & Booking Page matching exact reference UI design (Image 1).
class LocationSearchPage extends StatefulWidget {
  final VoidCallback? onMenuTap;
  final VoidCallback? onNotificationTap;

  const LocationSearchPage({
    super.key,
    this.onMenuTap,
    this.onNotificationTap,
  });

  @override
  State<LocationSearchPage> createState() => _LocationSearchPageState();
}

class _LocationSearchPageState extends State<LocationSearchPage> {
  @override
  void initState() {
    super.initState();
    context.read<BookingBloc>().add(const LoadBookingDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.onboardingBgDark : const Color(0xFFF8FAFC),
      appBar: RideHistoryTopBar(
        onMenuTap: widget.onMenuTap,
        onNotificationTap: widget.onNotificationTap,
      ),
      body: BlocConsumer<BookingBloc, BookingState>(
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
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryBlue,
              ),
            );
          }

          if (state.isShowingVehicleResults) {
            return const VehicleSearchResultsPage();
          }

          return Stack(
            children: [
              // 1. Full-bleed Map Layer
              Positioned.fill(
                child: Image.asset(
                  AppAssets.mapBackground,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: isDark
                          ? const Color(0xFF0F172A)
                          : const Color(0xFFE2E8F0),
                      child: const Center(
                        child: Icon(
                          Icons.map_rounded,
                          size: 100,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                    );
                  },
                ),
              ),

              // 2. Main Scrollable Overlay Content
              Positioned.fill(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 16,
                    bottom: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Floating Location Selector Card
                      LocationSelectorCard(
                        pickupLocation: state.pickupLocation,
                        destination: state.destination,
                        selectedRideTypeIndex: state.selectedRideTypeIndex,
                        onRideTypeSelected: (index) {
                          context
                              .read<BookingBloc>()
                              .add(SelectRideTypeTabEvent(index));
                        },
                      ),

                      const SizedBox(height: 240), // Spacing over map view

                      // Recent Journeys Section
                      RecentJourneysList(
                        journeys: state.recentJourneys,
                        onJourneySelected: (journeyTitle) {
                          context.read<BookingBloc>().add(
                                SelectRecentJourneyEvent(journeyTitle),
                              );
                        },
                        onViewAllTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Opening all recent journeys...'),
                              backgroundColor: AppColors.primaryBlue,
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 20),

                      // Primary Action Button: "Search Vehicles"
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          key: const Key('search_vehicles_button'),
                          onPressed: () {
                            context
                                .read<BookingBloc>()
                                .add(const SearchVehiclesEvent());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBlue,
                            foregroundColor: Colors.white,
                            elevation: 4,
                            shadowColor:
                                AppColors.primaryBlue.withValues(alpha: 0.4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            AppStrings.searchVehicles,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
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
