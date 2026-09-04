import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../../../trips/presentation/pages/trips_page.dart';
import '../../../earnings/presentation/pages/earnings_page.dart';
import '../../../settings/presentation/pages/settings_page.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../../../../core/di/injection_container.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../../../profile/presentation/bloc/profile_event.dart';
import '../../../profile/presentation/bloc/profile_state.dart';
import '../bloc/booking_bloc.dart';
import '../bloc/booking_event.dart';
import '../bloc/booking_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_colors.dart';
import '../widgets/availability_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  bool _isOnDuty = true;
  String _rideType = 'Self'; // 'Corporate' or 'Self'
  List<DateTime> _corporateSelectedDates = [];
  bool _isRideRequestMinimized = false;
  bool _hasActiveRideRequest = true;

  // ignore: unused_field
  GoogleMapController? _mapController;

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(37.7800, -122.4050),
    zoom: 14.5,
  );

  late final HomeBloc _homeBloc;
  late final ProfileBloc _profileBloc;
  late final BookingBloc _bookingBloc;
  
  BitmapDescriptor? _customMarker;
  LatLng? _currentLatLng;

  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    _homeBloc = sl<HomeBloc>();
    _profileBloc = sl<ProfileBloc>()..add(GetProfileEvent());
    _bookingBloc = sl<BookingBloc>();
    _loadCustomMarker();
    _determinePositionAndSend();
  }

  Future<void> _loadCustomMarker() async {
    _customMarker = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/images/rider_marker.png',
    );
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _homeBloc.close();
    _profileBloc.close();
    _bookingBloc.close();
    super.dispose();
  }

  Future<void> _determinePositionAndSend() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
      if (mounted) {
        setState(() {
          _currentLatLng = LatLng(position.latitude, position.longitude);
        });
        if (_mapController != null && _currentLatLng != null) {
          _mapController!.animateCamera(CameraUpdate.newLatLng(_currentLatLng!));
        }
        _homeBloc.add(
          HomeEvent.updateLocation(
            lat: position.latitude,
            lng: position.longitude,
          ),
        );
      }
    } catch (e) {
      debugPrint("Error getting location: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _homeBloc),
        BlocProvider.value(value: _profileBloc),
        BlocProvider.value(value: _bookingBloc),
      ],
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xFF1A1A1A) : const Color(0xFFEFE9E1),
      body: MultiBlocListener(
        listeners: [
          BlocListener<ProfileBloc, ProfileState>(
            listener: (context, state) async {
              if (state is ProfileLoaded) {
                final prefs = await SharedPreferences.getInstance();
                final token = prefs.getString('user_token') ?? '';
                _bookingBloc.add(ConnectWebSocketEvent(
                  driverId: state.profile.id,
                  token: token,
                ));
              }
            },
          ),
          BlocListener<BookingBloc, BookingState>(
            listener: (context, state) {
              if (state is NewRideRequestState) {
                setState(() {
                  _hasActiveRideRequest = true;
                  _isRideRequestMinimized = false;
                });
              } else if (state is RideAcceptedSuccessState) {
                setState(() {
                  _hasActiveRideRequest = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Ride accepted successfully!')),
                );
                // Here we would typically navigate to ActiveTripPage
              } else if (state is BookingErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${state.message}')),
                );
              } else if (state is BookingConnected) {
                setState(() {
                  _hasActiveRideRequest = false;
                });
              }
            },
          ),
        ],
        child: Stack(
          children: [
          // 1. Map Layer
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return GoogleMap(
                  initialCameraPosition: _initialPosition,
                  onMapCreated: (controller) => _mapController = controller,
                  zoomControlsEnabled: false,
                  myLocationEnabled: false,
                  myLocationButtonEnabled: false,
                  polylines: const <Polyline>{},
                  markers: _currentLatLng != null && _customMarker != null
                      ? {
                          Marker(
                            markerId: const MarkerId('current_location'),
                            position: _currentLatLng!,
                            icon: _customMarker!,
                            anchor: const Offset(0.5, 0.5),
                          ),
                        }
                      : const <Marker>{},
                  circles: _currentLatLng != null
                      ? {
                          Circle(
                            circleId: const CircleId('pulse'),
                            center: _currentLatLng!,
                            radius: _pulseController.value * 200, // up to 200 meters
                            fillColor: const Color(0xFF10A142).withValues(alpha: 0.3 * (1 - _pulseController.value)),
                            strokeWidth: 2,
                            strokeColor: const Color(0xFF10A142).withValues(alpha: 0.6 * (1 - _pulseController.value)),
                          ),
                        }
                      : const <Circle>{},
                );
              },
            ),
          ),



          // 3. Floating Action Buttons (GPS and Filters)
          Positioned(
            top: MediaQuery.of(context).padding.top + 180,
            left: 16,
            child: _buildFloatingButton(Icons.my_location, isDark, onTap: () {
              if (_mapController != null && _currentLatLng != null) {
                _mapController!.animateCamera(CameraUpdate.newLatLng(_currentLatLng!));
              }
            }),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 180,
            right: 16,
            child: _buildFloatingButton(Icons.tune, isDark),
          ),

          // 4. Top Dashboard Card
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Profile Section
                      Expanded(
                        flex: 3,
                        child: BlocBuilder<ProfileBloc, ProfileState>(
                          builder: (context, state) {
                            String name = 'Loading...';
                            String rating = '0.0';
                            String imageUrl = '';

                            if (state is ProfileLoaded) {
                              name = state.profile.name;
                              rating = state.profile.rating.toString();
                              imageUrl = state.profile.profileImageUrl;
                            } else if (state is ProfileUpdateSuccess) {
                              name = state.profile.name;
                              rating = state.profile.rating.toString();
                              imageUrl = state.profile.profileImageUrl;
                            }

                            return Row(
                              children: [
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Colors.grey.shade200,
                                      backgroundImage: imageUrl.isNotEmpty
                                          ? NetworkImage(imageUrl)
                                          : const AssetImage('assets/images/login.png') as ImageProvider,
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: -2,
                                      child: Container(
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF10A142),
                                          shape: BoxShape.circle,
                                          border: Border.all(color: Colors.white, width: 2),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: isDark ? Colors.white : Colors.black,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Row(
                                        children: [
                                          const Icon(Icons.star_outline, color: Colors.orange, size: 12),
                                          const SizedBox(width: 2),
                                          Expanded(
                                            child: Text(
                                              '$rating • Top Rated',
                                              style: GoogleFonts.inter(
                                                fontSize: 10,
                                                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
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
                              ],
                            );
                          }
                        ),
                      ),

                      // Duty Toggle Section
                      Expanded(
                        flex: 4,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF10A142),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'ON DUTY',
                                      style: GoogleFonts.inter(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF10A142),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "You're available\nfor rides",
                                  textAlign: TextAlign.right,
                                  style: GoogleFonts.inter(
                                    fontSize: 8,
                                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                            Transform.scale(
                              scale: 0.7,
                              child: Switch(
                                value: _isOnDuty,
                                onChanged: (val) {
                                  setState(() {
                                    _isOnDuty = val;
                                  });
                                  final String mode = _rideType == 'Corporate' ? 'EMPLOYEE' : 'NORMAL';
                                  _homeBloc.add(HomeEvent.updateAvailability(availabilityMode: mode, isOnline: _isOnDuty));
                                },
                                activeThumbColor: Colors.white,
                                activeTrackColor: AppColors.primaryBlue,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Wallet Section
                      Expanded(
                        flex: 3,
                        child: BlocBuilder<ProfileBloc, ProfileState>(
                          builder: (context, state) {
                            String earnings = '0.0';
                            if (state is ProfileLoaded) {
                              earnings = state.profile.totalEarnings.toString();
                            } else if (state is ProfileUpdateSuccess) {
                              earnings = state.profile.totalEarnings.toString();
                            }
                            
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Total Earnings',
                                        style: GoogleFonts.inter(
                                          fontSize: 9,
                                          color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        '₹$earnings',
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: isDark ? Colors.white : Colors.black,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Segmented Control
                  Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              if (_rideType == 'Corporate') return;

                              final selectedDates = await showModalBottomSheet<List<DateTime>>(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) => const AvailabilityBottomSheet(),
                              );

                              if (selectedDates != null && selectedDates.isNotEmpty) {
                                setState(() {
                                  _rideType = 'Corporate';
                                  _corporateSelectedDates = selectedDates;
                                });
                                final String mode = 'EMPLOYEE';
                                _homeBloc.add(HomeEvent.updateAvailability(
                                  availabilityMode: mode, 
                                  isOnline: _isOnDuty,
                                  selectedDates: selectedDates,
                                ));
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: _rideType == 'Corporate' ? AppColors.primaryBlue : Colors.transparent,
                                borderRadius: BorderRadius.circular(22),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.work_outline,
                                      size: 18,
                                      color: _rideType == 'Corporate' ? Colors.white : (isDark ? Colors.grey.shade400 : Colors.black87),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Corporate',
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: _rideType == 'Corporate' ? Colors.white : (isDark ? Colors.grey.shade400 : Colors.black87),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _rideType = 'Self';
                                _corporateSelectedDates = [];
                              });
                              final String mode = 'NORMAL';
                              _homeBloc.add(HomeEvent.updateAvailability(availabilityMode: mode, isOnline: _isOnDuty));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: _rideType == 'Self' ? AppColors.primaryBlue : Colors.transparent,
                                borderRadius: BorderRadius.circular(22),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.person_outline,
                                      size: 18,
                                      color: _rideType == 'Self' ? Colors.white : (isDark ? Colors.grey.shade400 : Colors.black87),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Self',
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: _rideType == 'Self' ? Colors.white : (isDark ? Colors.grey.shade400 : Colors.black87),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),
          ),

          // 5. Bottom Ride Request Card
          if (_hasActiveRideRequest && _isOnDuty)
            BlocBuilder<BookingBloc, BookingState>(
              builder: (context, state) {
                if (state is NewRideRequestState) {
                  return _isRideRequestMinimized
                      ? _buildMinimizedRideRequestCard(isDark)
                      : _buildMaximizedRideRequestCard(isDark, state);
                } else if (state is AcceptingRideState) {
                  return const Center(child: CircularProgressIndicator());
                }
                return const SizedBox.shrink();
              }
            ),
        ],
      ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            if (index == 1) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const TripsPage()),
              );
            } else if (index == 2) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const EarningsPage()),
              );
            } else if (index == 3) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const SettingsPage()),
              );
            } else {
              setState(() => _currentIndex = index);
            }
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
          selectedItemColor: AppColors.primaryBlue,
          unselectedItemColor: isDark ? Colors.grey.shade500 : Colors.grey.shade500,
          selectedLabelStyle: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600),
          unselectedLabelStyle: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500),
          items: const [
            BottomNavigationBarItem(icon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.home)), label: 'Home'),
            BottomNavigationBarItem(icon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.history)), label: 'Trips'),
            BottomNavigationBarItem(icon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.currency_rupee)), label: 'Earnings'),
            BottomNavigationBarItem(icon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.settings_outlined)), label: 'Settings'),
          ],
        ),
      ),
    ));
  }

  Widget _buildFloatingButton(IconData icon, bool isDark, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: AppColors.primaryBlue, size: 24),
      ),
    );
  }



  Widget _buildMaximizedRideRequestCard(bool isDark, NewRideRequestState state) {
    final ride = state.rideRequest;
    return Positioned(
      bottom: 16,
      left: 16,
      right: 16,
      child: GestureDetector(
        onVerticalDragUpdate: (details) {
          if (details.delta.dy > 10) {
            setState(() {
              _isRideRequestMinimized = true;
            });
          }
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Line 1: Amount, Ride Type, and Minimize Button
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'EST. PAYOUT',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
                          ),
                        ),
                        Text(
                          '₹${ride.estimatedFare}',
                          style: GoogleFonts.inter(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF0D6EFD),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D6EFD).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Self',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF0D6EFD),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isRideRequestMinimized = true;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.keyboard_arrow_down, 
                        color: isDark ? Colors.white : Colors.black54, 
                        size: 20
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),

              // Line 2: From Location
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                      CustomPaint(
                        size: const Size(1, 24),
                        painter: DashedLinePainter(),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PICKUP',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          ride.pickupAddress,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              // Line 3: To Location
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Color(0xFF0D6EFD),
                      shape: BoxShape.rectangle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'DROPOFF',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF0D6EFD),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          ride.dropAddress,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: OutlinedButton(
                      onPressed: () {
                        _bookingBloc.add(DeclineRideEvent());
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Decline',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D6EFD),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Accept ride',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
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
      ),
    );
  }

  Widget _buildMinimizedRideRequestCard(bool isDark) {
    return Positioned(
      bottom: 24,
      left: 16,
      right: 16,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isRideRequestMinimized = false;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              // Amount
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PAYOUT',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
                    ),
                  ),
                  Text(
                    '₹70.50',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0D6EFD),
                    ),
                  ),
                ],
              ),
              
              Container(
                width: 1,
                height: 30,
                color: Colors.grey.shade300,
                margin: const EdgeInsets.symmetric(horizontal: 16),
              ),
              
              // Locations
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '142 Market St',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(color: Color(0xFF0D6EFD), shape: BoxShape.rectangle),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '88 King St',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : Colors.black87,
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
              
              const SizedBox(width: 8),
              
              // Action Buttons
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _hasActiveRideRequest = false;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        color: isDark ? Colors.white : Colors.black54,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      // Accept logic here
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Color(0xFF0D6EFD),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const dashWidth = 3.0;
    const dashSpace = 3.0;
    double startY = 0;
    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashWidth), paint);
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
