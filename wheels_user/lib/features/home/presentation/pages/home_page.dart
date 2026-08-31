import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection_container.dart';
import '../../../booking/presentation/bloc/booking_bloc.dart';
import '../../../booking/presentation/pages/location_search_page.dart';
import '../../../favourites/presentation/bloc/favourites_bloc.dart';
import '../../../favourites/presentation/pages/favourites_page.dart';
import '../../../history/presentation/bloc/ride_history_bloc.dart';
import '../../../history/presentation/pages/ride_history_page.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../settings/presentation/pages/settings_page.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../widgets/home_bottom_nav_bar.dart';
import '../widgets/home_search_bar.dart';
import '../widgets/offers_carousel.dart';
import '../widgets/popular_locations_grid.dart';
import '../widgets/quick_services_grid.dart';
import '../widgets/recent_ride_card.dart';

/// Main Home Dashboard Page matching exact reference UI design.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GoogleMapController? _mapController;
  LatLng _currentPosition = const LatLng(37.7749, -122.4194); // Default fallback (San Francisco)
  bool _loadingLocation = true;

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(const LoadHomeDashboardEvent());
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() { _loadingLocation = false; });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() { _loadingLocation = false; });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() { _loadingLocation = false; });
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final newLatLng = LatLng(position.latitude, position.longitude);

      if (mounted) {
        setState(() {
          _currentPosition = newLatLng;
          _loadingLocation = false;
        });
      }

      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: newLatLng,
            zoom: 16.0,
          ),
        ),
      );
    } catch (e) {
      debugPrint('Error getting current location: $e');
      if (mounted) {
        setState(() { _loadingLocation = false; });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sheetBg = isDark ? AppColors.onboardingBgDark : Colors.white;

    return Scaffold(
      backgroundColor: isDark ? AppColors.onboardingBgDark : Colors.white,
      body: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state.claimedOfferMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.claimedOfferMessage!),
                backgroundColor: AppColors.primaryBlue,
              ),
            );
          } else if (state.actionMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.actionMessage!),
                backgroundColor: AppColors.primaryBlue,
                duration: const Duration(seconds: 2),
              ),
            );
          } else if (state.selectedService != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Selected: ${state.selectedService}'),
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

          final entity = state.dashboardEntity;
          final greetingTitle = entity?.greetingTitle ?? AppStrings.goodMorning;
          final greetingSubtitle =
              entity?.greetingSubtitle ?? AppStrings.readyForNextRide;
          final recentTitle =
              entity?.recentRideTitle ?? AppStrings.recentRideOfficeToHome;
          final recentDetails =
              entity?.recentRideDetails ?? AppStrings.recentRideDetails;

          Widget mainContent;
          if (state.selectedNavIndex == 1) {
            mainContent = BlocProvider<RideHistoryBloc>(
              create: (_) => sl<RideHistoryBloc>(),
              child: RideHistoryPage(
                onMenuTap: () {
                  context.read<HomeBloc>().add(const OpenMenuEvent());
                },
                onNotificationTap: () {
                  context.read<HomeBloc>().add(const OpenNotificationsEvent());
                },
              ),
            );
          } else if (state.selectedNavIndex == 2) {
            mainContent = BlocProvider<FavouritesBloc>(
              create: (_) => sl<FavouritesBloc>(),
              child: FavouritesPage(
                onMenuTap: () {
                  context.read<HomeBloc>().add(const OpenMenuEvent());
                },
                onNotificationTap: () {
                  context.read<HomeBloc>().add(const OpenNotificationsEvent());
                },
              ),
            );
          } else if (state.selectedNavIndex == 3) {
            mainContent = BlocProvider<SettingsBloc>(
              create: (_) => sl<SettingsBloc>(),
              child: SettingsPage(
                onMenuTap: () {
                  context.read<HomeBloc>().add(const OpenMenuEvent());
                },
                onNotificationTap: () {
                  context.read<HomeBloc>().add(const OpenNotificationsEvent());
                },
              ),
            );
          } else {
            mainContent = Stack(
              children: [
                // 1. Map Layer Background
                Positioned.fill(
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _currentPosition,
                      zoom: 16.0,
                    ),
                    zoomControlsEnabled: false,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    compassEnabled: false,
                    mapToolbarEnabled: false,
                    onMapCreated: (controller) {
                      _mapController = controller;
                    },
                    markers: {
                      Marker(
                        markerId: const MarkerId('current_location'),
                        position: _currentPosition,
                        infoWindow: const InfoWindow(title: 'Current Location'),
                        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
                      ),
                    },
                  ),
                ),

                // 3. Floating Top Search Bar
                Positioned(
                  top: MediaQuery.of(context).padding.top + 8,
                  left: 0,
                  right: 0,
                  child: HomeSearchBar(
                    onMenuTap: () {
                      context.read<HomeBloc>().add(const OpenMenuEvent());
                    },
                    onChanged: (query) {
                      context
                          .read<HomeBloc>()
                          .add(SearchQueryChangedEvent(query));
                    },
                    onSubmitted: (query) {
                      context
                          .read<HomeBloc>()
                          .add(SearchSubmittedEvent(query));
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => BlocProvider<BookingBloc>(
                            create: (_) => sl<BookingBloc>(),
                            child: LocationSearchPage(
                              onMenuTap: () {
                                context.read<HomeBloc>().add(const OpenMenuEvent());
                              },
                              onNotificationTap: () {
                                context.read<HomeBloc>().add(const OpenNotificationsEvent());
                              },
                            ),
                          ),
                        ),
                      );
                    },
                    onMicTap: () {
                      context.read<HomeBloc>().add(const OpenMicEvent());
                    },
                    onNotificationTap: () {
                      context
                          .read<HomeBloc>()
                          .add(const OpenNotificationsEvent());
                    },
                    onAvatarTap: () {
                      context.read<HomeBloc>().add(const OpenProfileEvent());
                    },
                  ),
                ),

                // 4. Main Scrollable Floating Sheet
                Positioned.fill(
                  child: DraggableScrollableSheet(
                    initialChildSize: 0.65,
                    minChildSize: 0.3,
                    maxChildSize: 0.9,
                    snap: true,
                    snapSizes: const [0.3, 0.65, 0.9],
                    builder: (BuildContext context, ScrollController scrollController) {
                      return Container(
                        decoration: BoxDecoration(
                          color: sheetBg,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(28),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 16,
                              offset: const Offset(0, -4),
                            ),
                          ],
                        ),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 12,
                        bottom: 80,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Drag Indicator Handle
                          Center(
                            child: Container(
                              width: 38,
                              height: 4,
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(0xFF334155)
                                    : const Color(0xFFCBD5E1),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Greeting Section
                          Text(
                            greetingTitle,
                            style: GoogleFonts.poppins(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? AppColors.white
                                  : AppColors.onboardingTextPrimaryLight,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            greetingSubtitle,
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.onboardingTextSecondaryLight,
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Recent / Quick Repeat Ride Card
                          RecentRideCard(
                            title: recentTitle,
                            details: recentDetails,
                            onRepeatTap: () {
                              context
                                  .read<HomeBloc>()
                                  .add(const RepeatRideEvent());
                            },
                          ),

                          const SizedBox(height: 5),

                          // Section Title: Quick Ride Services
                          Text(
                            AppStrings.quickRideServices,
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? AppColors.white
                                  : AppColors.onboardingTextPrimaryLight,
                            ),
                          ),
                          

                          // Quick Services 8-Grid
                          QuickServicesGrid(
                            services: entity?.quickServices ?? [],
                            onServiceTap: (serviceName) {
                              context
                                  .read<HomeBloc>()
                                  .add(SelectQuickServiceEvent(serviceName));
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider<BookingBloc>(
                                    create: (_) => sl<BookingBloc>(),
                                    child: LocationSearchPage(
                                      onMenuTap: () {
                                        context.read<HomeBloc>().add(const OpenMenuEvent());
                                      },
                                      onNotificationTap: () {
                                        context.read<HomeBloc>().add(const OpenNotificationsEvent());
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),

                        

                          // Popular Locations Grid
                          if (entity?.popularLocations.isNotEmpty == true)
                            PopularLocationsGrid(
                              locations: entity!.popularLocations,
                              onLocationTap: (locationId) {
                                // Add navigation or logic
                              },
                            ),

                          if (entity?.popularLocations.isNotEmpty == true)
                            const SizedBox(height: 28),

                          // Section Title: Offers for You
                          Text(
                            AppStrings.offersForYou,
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? AppColors.white
                                  : AppColors.onboardingTextPrimaryLight,
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Offers Banner Carousel
                          OffersCarousel(
                            coupons: entity?.coupons ?? [],
                            onClaimOfferTap: () {
                              context
                                  .read<HomeBloc>()
                                  .add(const ClaimOfferEvent('FLY30'));
                            },
                          ),

                          const SizedBox(height: 20),
                        ],
                      ),
                      ),
                    );
                  },
                ),
              ),
            ],
            );
          }

          return Stack(
            children: [
              Positioned.fill(
                child: mainContent,
              ),

              // Bottom Navigation Bar
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: HomeBottomNavBar(
                  selectedIndex: state.selectedNavIndex,
                  onTabSelected: (index) {
                    context
                        .read<HomeBloc>()
                        .add(ChangeNavTabEvent(index));
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
