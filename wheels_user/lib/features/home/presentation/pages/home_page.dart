import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/customer_ws_controller.dart';
import '../../../../core/services/active_booking_service.dart';
import '../../../booking/presentation/bloc/booking_bloc.dart';
import '../../../booking/presentation/pages/booking_confirmed_page.dart';
import '../../../booking/presentation/pages/journey_complete_page.dart';
import '../../../booking/presentation/pages/live_trip_tracking_page.dart';
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
import '../widgets/corporate_home_banner.dart';
import '../../../../core/widgets/app_map_widget.dart';

/// Main Home Dashboard Page matching exact reference UI design.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (_) => BlocProvider<HomeBloc>(
        create: (_) => sl<HomeBloc>(),
        child: const HomePage(),
      ),
    );
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  GoogleMapController? _mapController;
  LatLng _currentPosition = const LatLng(17.4924, 78.3639); // Default fallback

  late final AnimationController _pulseController;
  BitmapDescriptor? _customMarker;
  StreamSubscription<Position>? _positionStreamSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
    _loadCustomMarker();
    context.read<HomeBloc>().add(const LoadHomeDashboardEvent());
    _getCurrentLocation();
    _startLocationUpdates();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      debugPrint('[HomePage] App resumed. Triggering WS reconnect and active ride check...');
      if (sl.isRegistered<CustomerWSController>()) {
        sl<CustomerWSController>().reconnectIfNeeded();
      }
      _checkActiveBookingOnResume();
    }
  }

  Future<void> _checkActiveBookingOnResume() async {
    try {
      if (!sl.isRegistered<ActiveBookingService>()) return;
      final activeBookingService = sl<ActiveBookingService>();
      final activeData = activeBookingService.activeBooking;
      if (activeData == null) return;

      final response = await sl<Dio>().get(
        '${ApiConstants.baseUrl}/bookings/${activeData.bookingId}',
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final decoded = response.data is String ? jsonDecode(response.data) : response.data;
        final data = decoded['data'] as Map<String, dynamic>? ?? decoded;
        final status = (data['status'] ?? '').toString().toUpperCase();

        if (status == 'CANCELLED' || status == 'RIDER_CANCELLED' || status == 'CUSTOMER_CANCELLED') {
          activeBookingService.clearActiveBooking();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Your ride was cancelled by the driver.'),
                backgroundColor: Color(0xFFEF4444),
                duration: Duration(seconds: 4),
              ),
            );
          }
        } else if (status == 'COMPLETED') {
          activeBookingService.clearActiveBooking();
          if (mounted) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => JourneyCompletePage(
                  driverName: activeData.driverName,
                  vehicleInfo: activeData.vehicleInfo,
                  finalPaymentText: activeData.totalAmount,
                ),
              ),
            );
          }
        } else if (status.isNotEmpty) {
          activeBookingService.updateBookingStatus(status);
        }
      }
    } catch (e) {
      debugPrint('HomePage resume HTTP status check error: $e');
    }
  }

  Future<void> _loadCustomMarker() async {
    try {
      _customMarker = await BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(48, 48)),
        'assets/images/user_marker.png',
      );
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('Custom marker load error: $e');
    }
  }

  Future<void> _startLocationUpdates() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        return;
      }

      _positionStreamSubscription = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 5,
        ),
      ).listen((Position position) {
        final newLatLng = LatLng(position.latitude, position.longitude);
        if (mounted) {
          setState(() {
            _currentPosition = newLatLng;
          });
          try {
            _mapController?.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: newLatLng,
                  zoom: 18.0,
                ),
              ),
            );
          } catch (e) {
            debugPrint('Error animating map camera: $e');
          }
        }
      });
    } catch (e) {
      debugPrint('Error starting location stream: $e');
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pulseController.dispose();
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
        );

        final newLatLng = LatLng(position.latitude, position.longitude);

        if (mounted) {
          setState(() {
            _currentPosition = newLatLng;
          });
          try {
            _mapController?.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: newLatLng,
                  zoom: 18.0,
                ),
              ),
            );
          } catch (e) {
            debugPrint('Error animating camera: $e');
          }
        }
      }
    } catch (e) {
      debugPrint('Error getting current location: $e');
    }
  }

  String _getTimeBasedGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return 'Good Morning 👋';
    } else if (hour >= 12 && hour < 17) {
      return 'Good Afternoon 👋';
    } else if (hour >= 17 && hour < 21) {
      return 'Good Evening 👋';
    } else {
      return 'Good Night 👋';
    }
  }

  void _navigateToLocationSearch(BuildContext context, {bool initialIsCorporate = false}) {
    if (sl.isRegistered<ActiveBookingService>() && sl<ActiveBookingService>().hasActiveBooking) {
      _showActiveBookingWarningDialog(context);
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider<BookingBloc>(
              create: (_) => sl.isRegistered<BookingBloc>()
                  ? sl<BookingBloc>()
                  : BookingBloc(
                      getRecentJourneysUseCase: sl(),
                      getAvailableVehiclesUseCase: sl(),
                    ),
            ),
            if (sl.isRegistered<FavouritesBloc>())
              BlocProvider<FavouritesBloc>(
                create: (_) => sl<FavouritesBloc>(),
              ),
          ],
          child: LocationSearchPage(
            initialIsCorporate: initialIsCorporate,
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
  }

  void _showActiveBookingWarningDialog(BuildContext context) {
    final activeData = sl<ActiveBookingService>().activeBooking;
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Color(0xFFF59E0B), size: 28),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Active Ride in Progress',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ],
        ),
        content: Text(
          'You already have an active ride booked with ${activeData?.driverName ?? 'your driver'}. Please complete or cancel your current ride before booking a new one.',
          style: GoogleFonts.poppins(fontSize: 14),
        ),
        actions: [
          OutlinedButton(
            onPressed: () {
              Navigator.of(dialogCtx).pop();
              _showCancelRideDialog(context, activeData);
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFEF4444)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(
              'Cancel Ride',
              style: GoogleFonts.poppins(color: const Color(0xFFEF4444), fontWeight: FontWeight.w600),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogCtx).pop();
              _resumeActiveRide(context, activeData);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(
              'Go to Active Ride',
              style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _resumeActiveRide(BuildContext context, ActiveBookingData? data) {
    if (data == null) return;
    if (data.status == 'RIDER_ACCEPTED') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => BookingConfirmedPage(
            bookingId: data.bookingId,
            driverName: data.driverName,
            driverRating: data.driverRating,
            vehicleModel: data.vehicleInfo,
            pickupAddress: data.pickupAddress,
            dropAddress: data.dropAddress,
            pickupLatLng: data.pickupLatLng,
            dropLatLng: data.dropLatLng,
            totalAmount: data.totalAmount,
            startOtp: data.startOtp,
          ),
        ),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => LiveTripTrackingPage(
            driverName: data.driverName,
            driverRating: data.driverRating,
            vehicleInfo: data.vehicleInfo,
            pickupAddress: data.pickupAddress,
            dropAddress: data.dropAddress,
            pickupLatLng: data.pickupLatLng,
            dropLatLng: data.dropLatLng,
            initialRiderLatLng: data.initialRiderLatLng,
            startOtp: data.startOtp,
            initialStatus: data.status,
          ),
        ),
      );
    }
  }

  void _showCancelRideDialog(BuildContext context, ActiveBookingData? data) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(
          'Cancel Ride?',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to cancel your current ride request?',
          style: GoogleFonts.poppins(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: Text(
              'Keep Ride',
              style: GoogleFonts.poppins(color: const Color(0xFF64748B)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogCtx).pop();
              if (data != null && sl.isRegistered<CustomerWSController>()) {
                sl<CustomerWSController>().cancelRide(bookingId: data.bookingId);
              }
              if (sl.isRegistered<ActiveBookingService>()) {
                sl<ActiveBookingService>().clearActiveBooking();
              }
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Ride cancelled successfully. You can now book a new ride!'),
                  backgroundColor: Color(0xFFEF4444),
                ),
              );
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
            return Container(
              color: isDark ? AppColors.onboardingBgDark : Colors.white,
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryBlue,
                ),
              ),
            );
          }

          final entity = state.dashboardEntity;
          final greetingTitle = _getTimeBasedGreeting();
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
                  child: AppMapWidget(
                    initialCameraPosition: CameraPosition(
                      target: _currentPosition,
                      zoom: 18.0,
                    ),
                    onMapCreated: (controller) {
                      _mapController = controller;
                      try {
                        _mapController?.animateCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(
                              target: _currentPosition,
                              zoom: 18.0,
                            ),
                          ),
                        );
                      } catch (e) {
                        debugPrint('Error animating initial camera: $e');
                      }
                    },
                    mapType: MapType.normal,
                    zoomControlsEnabled: false,
                    myLocationEnabled: false,
                    myLocationButtonEnabled: false,
                    compassEnabled: false,
                    mapToolbarEnabled: false,
                    markers: {
                      Marker(
                        markerId: const MarkerId('current_location'),
                        position: _currentPosition,
                        infoWindow: const InfoWindow(title: 'Current Location'),
                        icon: _customMarker ??
                            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                        anchor: const Offset(0.5, 0.5),
                      ),
                    },
                  ),
                ),

                // 2. Floating Top Search Bar
                Positioned(
                  top: MediaQuery.of(context).padding.top + 8,
                  left: 0,
                  right: 0,
                  child: HomeSearchBar(
                    readOnly: true,
                    userName: entity?.userName ?? 'User',
                    onTap: () => _navigateToLocationSearch(context),
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
                      _navigateToLocationSearch(context);
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

                // 2.5 Floating Top Right Current Location GPS Button
                Positioned(
                  top: MediaQuery.of(context).padding.top + 76,
                  right: 16,
                  child: GestureDetector(
                    onTap: () {
                      if (_mapController != null) {
                        _mapController!.animateCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(
                              target: _currentPosition,
                              zoom: 18.0,
                            ),
                          ),
                        );
                      }
                    },
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.cardBgDark : Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.my_location,
                        color: AppColors.primaryBlue,
                        size: 22,
                      ),
                    ),
                  ),
                ),

                // 3. Main Scrollable Floating Sheet (collapsed at 35% so map is primary view)
                Positioned.fill(
                  child: DraggableScrollableSheet(
                    key: const Key('home_draggable_sheet'),
                    initialChildSize: 0.35,
                    minChildSize: 0.25,
                    maxChildSize: 0.9,
                    snap: true,
                    snapSizes: const [0.25, 0.35, 0.9],
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

                          // Active Ride Banner (if active ride exists)
                          if (sl.isRegistered<ActiveBookingService>())
                            ValueListenableBuilder<ActiveBookingData?>(
                              valueListenable: sl<ActiveBookingService>().activeBookingNotifier,
                              builder: (context, activeData, _) {
                                if (activeData == null) return const SizedBox.shrink();
                                return _buildActiveRideBanner(context, activeData, isDark);
                              },
                            ),

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

                          // Corporate Account Banner (if corporate user)
                          if (entity?.isCorporate == true && entity?.companyName != null)
                            CorporateHomeBanner(
                              companyName: entity!.companyName!,
                              employeeCode: entity.employeeCode,
                              spendingLimit: entity.spendingLimit,
                              location: entity.companyLocation,
                              onTap: () {
                                _navigateToLocationSearch(context, initialIsCorporate: true);
                              },
                            ),

                          // Recent / Quick Repeat Ride Card
                          RecentRideCard(
                            title: recentTitle,
                            details: recentDetails,
                            onRepeatTap: () {
                              context
                                  .read<HomeBloc>()
                                  .add(const RepeatRideEvent());
                              _navigateToLocationSearch(context);
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
                              _navigateToLocationSearch(context);
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

          return ValueListenableBuilder<ActiveBookingData?>(
            valueListenable: sl.isRegistered<ActiveBookingService>()
                ? sl<ActiveBookingService>().activeBookingNotifier
                : ValueNotifier<ActiveBookingData?>(null),
            builder: (context, activeData, _) {
              Widget currentContent;
              final activeStatus = activeData?.status.toUpperCase() ?? '';
              final isTripActive = activeStatus == 'TRIP_STARTED' ||
                  activeStatus == 'IN_TRANSIT' ||
                  activeStatus == 'ON_THE_WAY' ||
                  activeStatus == 'STARTED';

              if (activeData != null && isTripActive && state.selectedNavIndex == 0) {
                currentContent = LiveTripTrackingPage(
                  key: const ValueKey('home_embedded_live_trip'),
                  driverName: activeData.driverName,
                  driverRating: activeData.driverRating,
                  vehicleInfo: activeData.vehicleInfo,
                  pickupAddress: activeData.pickupAddress,
                  dropAddress: activeData.dropAddress,
                  pickupLatLng: activeData.pickupLatLng,
                  dropLatLng: activeData.dropLatLng,
                  initialRiderLatLng: activeData.initialRiderLatLng,
                  startOtp: activeData.startOtp,
                  initialStatus: activeData.status,
                );
              } else {
                currentContent = mainContent;
              }

              return Stack(
                children: [
                  Positioned.fill(
                    child: currentContent,
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
          );
        },
      ),
    );
  }

  Widget _buildActiveRideBanner(BuildContext context, ActiveBookingData activeData, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primaryBlue.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.directions_car_rounded, color: Colors.white, size: 14),
                    const SizedBox(width: 6),
                    Text(
                      'ACTIVE RIDE IN PROGRESS',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              if (activeData.startOtp != null && activeData.startOtp!.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'OTP: ${activeData.startOtp}',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '${activeData.driverName} • ${activeData.vehicleInfo}',
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.white : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${activeData.pickupAddress} ➔ ${activeData.dropAddress}',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _resumeActiveRide(context, activeData),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.navigation_rounded, color: Colors.white, size: 16),
                  label: Text(
                    'Resume Ride',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                height: 38,
                child: OutlinedButton(
                  onPressed: () => _showCancelRideDialog(context, activeData),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: isDark ? const Color(0xFF2C1E1E) : Colors.white,
                    side: const BorderSide(color: Color(0xFFFECDD3), width: 1.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Cancel Ride',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFEF4444),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
