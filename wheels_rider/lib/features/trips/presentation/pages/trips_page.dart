import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/widgets/animated_empty_state.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../earnings/presentation/pages/earnings_page.dart';
import '../../../settings/presentation/pages/settings_page.dart';
import '../../domain/entities/trip_entity.dart';
import '../bloc/trips_bloc.dart';
import '../bloc/trips_event.dart';
import '../bloc/trips_state.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../../../profile/presentation/bloc/profile_event.dart';
import '../../../profile/presentation/bloc/profile_state.dart';

class TripsPage extends StatefulWidget {
  const TripsPage({super.key});

  @override
  State<TripsPage> createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> {
  int _currentIndex = 1; // Trips is selected
  String _selectedFilter = 'All Rides';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  TripsBloc? _tripsBloc;

  @override
  void initState() {
    super.initState();
    if (sl.isRegistered<TripsBloc>()) {
      _tripsBloc = sl<TripsBloc>()..add(GetTripsEvent());
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF9F9FC);

    final effectiveTripsBloc = _tripsBloc ?? context.read<TripsBloc>();

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: effectiveTripsBloc),
        if (sl.isRegistered<ProfileBloc>())
          BlocProvider(create: (_) => sl<ProfileBloc>()..add(GetProfileEvent())),
      ],
      child: Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
          child: BlocBuilder<TripsBloc, TripsState>(
            builder: (context, state) {
              if (state is TripsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is TripsError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: AnimatedEmptyState(
                      title: 'Oops!',
                      subtitle: 'Failed to load trips. Please pull down to refresh.',
                      icon: Icons.cloud_off,
                    ),
                  ),
                );
              } else if (state is TripsLoaded) {
                final tripData = state.tripEntity;
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 12),
                        _buildTopBar(isDark),
                        const SizedBox(height: 14),
                        _buildSearchAndFilters(isDark),
                        const SizedBox(height: 14),
                        _buildStatCardsRow(isDark, tripData.totalRides, tripData.avgRating),
                        const SizedBox(height: 16),
                        _buildTripsList(isDark, tripData.bookings),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
        bottomNavigationBar: _buildBottomNavigationBar(context, isDark),
      ),
    );
  }

  Widget _buildTopBar(bool isDark) {
    Widget buildHeader(String name, String rating, String imageUrl) {
      return Expanded(
        child: Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.grey.shade200,
                  child: ClipOval(
                    child: imageUrl.isNotEmpty
                        ? Image.network(
                            imageUrl,
                            width: 36,
                            height: 36,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Image.asset(
                              'assets/images/strive_logo.jpg',
                              width: 36,
                              height: 36,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Image.asset(
                            'assets/images/strive_logo.jpg',
                            width: 36,
                            height: 36,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: -2,
                  child: Container(
                    width: 11,
                    height: 11,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D6EFD), // Blue dot
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0D6EFD),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(Icons.drive_eta, size: 9, color: Colors.white),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          name.isEmpty ? 'Puja Sri' : name,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey.shade800 : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star_rounded, size: 13, color: Color(0xFFFFB800)),
                        const SizedBox(width: 3),
                        Text(
                          rating == '0.0' || rating.isEmpty ? '5.0' : rating,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        sl.isRegistered<ProfileBloc>()
            ? BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  String name = 'Puja Sri';
                  String rating = '5.0';
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

                  return buildHeader(name, rating, imageUrl);
                },
              )
            : buildHeader('Puja Sri', '5.0', ''),
        const SizedBox(width: 10),
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade800 : Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(Icons.notifications_none, size: 18, color: isDark ? Colors.white70 : Colors.black87),
            ),
            Positioned(
              top: 8,
              right: 10,
              child: Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.2),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchAndFilters(bool isDark) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                height: 42,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 12),
                    Icon(Icons.search, color: Colors.grey.shade500, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (val) => setState(() => _searchQuery = val.trim()),
                        style: GoogleFonts.inter(fontSize: 13.5, color: isDark ? Colors.white : Colors.black),
                        decoration: InputDecoration(
                          hintText: 'Search rides, clients, locations...',
                          hintStyle: GoogleFonts.inter(
                            fontSize: 13.5,
                            color: Colors.grey.shade500,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 10),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? GestureDetector(
                                  onTap: () {
                                    _searchController.clear();
                                    setState(() => _searchQuery = '');
                                  },
                                  child: Icon(Icons.clear, size: 16, color: Colors.grey.shade500),
                                )
                              : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              'All Rides',
              'Corporate',
              'Private',
              'Completed',
              'Cancelled',
              'Last Month',
            ].map((filter) {
              final isSelected = filter == _selectedFilter;
              return GestureDetector(
                onTap: () => setState(() => _selectedFilter = filter),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF0D52D6) : (isDark ? Colors.grey.shade800 : const Color(0xFFEFEFF4)),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    filter,
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : (isDark ? Colors.grey.shade300 : const Color(0xFF4A5568)),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCardsRow(bool isDark, int totalRides, double avgRating) {
    final ratingVal = avgRating > 0 ? avgRating : 5.0;
    return Row(
      children: [
        Expanded(
          child: _buildModernStatCard(
            isDark: isDark,
            title: 'Total Rides',
            value: totalRides.toString(),
            icon: Icons.directions_car,
            accentColor: const Color(0xFF0D52D6),
            badgeText: 'Completed',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildModernStatCard(
            isDark: isDark,
            title: 'Avg. Rating',
            value: '${ratingVal.toStringAsFixed(1)} ★',
            icon: Icons.star,
            accentColor: const Color(0xFFFF9800),
            badgeText: 'Driver Rating',
          ),
        ),
      ],
    );
  }

  Widget _buildModernStatCard({
    required bool isDark,
    required String title,
    required String value,
    required IconData icon,
    required Color accentColor,
    required String badgeText,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : accentColor.withValues(alpha: 0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: accentColor, size: 16),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  badgeText,
                  style: GoogleFonts.inter(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: accentColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripsList(bool isDark, List<BookingEntity> bookings) {
    final filteredBookings = bookings.where((booking) {
      // 1. Search Query Filter
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchesName = booking.clientName.toLowerCase().contains(q);
        final matchesPickup = booking.pickupLocation.toLowerCase().contains(q);
        final matchesDrop = booking.dropoffLocation.toLowerCase().contains(q);
        final matchesStatus = booking.status.toLowerCase().contains(q);
        final matchesTag = booking.tag.toLowerCase().contains(q);
        if (!matchesName && !matchesPickup && !matchesDrop && !matchesStatus && !matchesTag) {
          return false;
        }
      }

      // 2. Category / Filter Chip
      if (_selectedFilter == 'Corporate') {
        return booking.tag.toUpperCase() == 'CORPORATE';
      } else if (_selectedFilter == 'Private') {
        return booking.tag.toUpperCase() == 'SELF' || booking.tag.toUpperCase() == 'PRIVATE';
      } else if (_selectedFilter == 'Completed') {
        final st = booking.status.toUpperCase();
        return st.contains('COMPLET') || st == 'PAYMENT_COMPLETED' || st == 'TRIP_COMPLETED';
      } else if (_selectedFilter == 'Cancelled') {
        final st = booking.status.toUpperCase();
        return st.contains('CANCEL') || st == 'EXPIRED';
      } else if (_selectedFilter == 'Last Month') {
        final now = DateTime.now();
        final lastMonth = now.subtract(const Duration(days: 30));
        return booking.timestamp.isAfter(lastMonth);
      }

      return true; // 'All Rides'
    }).toList();

    if (filteredBookings.isEmpty) {
      return AnimatedEmptyState(
        title: 'No Matching Rides',
        subtitle: _searchQuery.isNotEmpty
            ? 'No rides found matching "$_searchQuery".'
            : 'No rides found under "$_selectedFilter".',
        icon: Icons.search_off_rounded,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDateHeader('RIDES (${filteredBookings.length})', isDark),
        const SizedBox(height: 10),
        ...filteredBookings.map((booking) => Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: _buildTripCard(
                name: booking.clientName,
                rating: booking.clientRating.toStringAsFixed(1),
                tag: booking.tag,
                price: '₹${booking.price.toStringAsFixed(2)}',
                pickup: booking.pickupLocation,
                dropoff: booking.dropoffLocation,
                status: booking.status,
                isDark: isDark,
              ),
            )),
      ],
    );
  }

  Widget _buildDateHeader(String text, bool isDark) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
        color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
      ),
    );
  }

  Widget _buildTripCard({
    required String name,
    required String rating,
    required String tag,
    required String price,
    required String pickup,
    required String dropoff,
    required String status,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 16,
                      backgroundImage: AssetImage('assets/images/login.png'),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : const Color(0xFF1E293B),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 6,
                            runSpacing: 4,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.star, color: Colors.amber, size: 11),
                                  const SizedBox(width: 3),
                                  Text(
                                    rating,
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: 3,
                                height: 3,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade400,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEAF1FF),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  tag,
                                  style: GoogleFonts.inter(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF0D52D6),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    price,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  _buildStatusFlag(status, isDark),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Route Locations
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  const SizedBox(height: 4),
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade500,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 16,
                    color: Colors.grey.shade300,
                    margin: const EdgeInsets.symmetric(vertical: 3),
                  ),
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF0D52D6), width: 2),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pickup,
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
                        color: isDark ? Colors.grey.shade300 : const Color(0xFF4A5568),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      dropoff,
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
                        color: isDark ? Colors.grey.shade300 : const Color(0xFF4A5568),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusFlag(String status, bool isDark) {
    final upper = status.toUpperCase();

    Color bgColor;
    Color textColor;
    String displayText;
    IconData? icon;

    if (upper.contains('COMPLET') || upper == 'PAYMENT_COMPLETED' || upper == 'TRIP_COMPLETED') {
      // Green flag for Completed
      bgColor = isDark ? const Color(0xFF1B3A2B) : const Color(0xFFE6F4EA);
      textColor = isDark ? const Color(0xFF81C784) : const Color(0xFF137333);
      displayText = 'Completed';
      icon = Icons.check_circle;
    } else if (upper.contains('DROP') || upper.contains('EARLY') || upper == 'DROP_REQUESTED' || upper == 'DROP_ACCEPTED') {
      // Yellow flag for Drop Request
      bgColor = isDark ? const Color(0xFF3A301B) : const Color(0xFFFEF7E0);
      textColor = isDark ? const Color(0xFFFFD54F) : const Color(0xFFB06000);
      displayText = 'Drop Requested';
      icon = Icons.alt_route;
    } else if (upper.contains('CANCEL') || upper.contains('EXPIRED') || upper == 'CUSTOMER_CANCELLED' || upper == 'RIDER_CANCELLED') {
      // Red flag for Cancelled
      bgColor = isDark ? const Color(0xFF3C1E1E) : const Color(0xFFFCE8E6);
      textColor = isDark ? const Color(0xFFE57373) : const Color(0xFFC5221F);
      displayText = 'Cancelled';
      icon = Icons.cancel;
    } else {
      // Default blue flag for Active / Searching / Accepted / In Progress
      bgColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFEAF1FF);
      textColor = isDark ? const Color(0xFF90CAF9) : const Color(0xFF0D52D6);
      displayText = status.replaceAll('_', ' ').toLowerCase();
      displayText = displayText.isEmpty ? 'Active' : '${displayText[0].toUpperCase()}${displayText.substring(1)}';
      icon = Icons.directions_car;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: textColor),
          const SizedBox(width: 3),
          Text(
            displayText,
            style: GoogleFonts.inter(
              fontSize: 9.5,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context, bool isDark) {
    return Container(
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
          if (index == 0) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
          } else if (index == 2) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const EarningsPage()));
          } else if (index == 3) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SettingsPage()));
          } else {
            setState(() => _currentIndex = index);
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
        selectedItemColor: AppColors.primaryBlue,
        unselectedItemColor: isDark ? Colors.grey.shade500 : Colors.grey.shade500,
        selectedLabelStyle: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w500),
        items: const [
          BottomNavigationBarItem(icon: Padding(padding: EdgeInsets.only(bottom: 2), child: Icon(Icons.home_outlined, size: 20)), activeIcon: Padding(padding: EdgeInsets.only(bottom: 2), child: Icon(Icons.home, size: 20)), label: 'Home'),
          BottomNavigationBarItem(icon: Padding(padding: EdgeInsets.only(bottom: 2), child: Icon(Icons.history, size: 20)), label: 'Trips'),
          BottomNavigationBarItem(icon: Padding(padding: EdgeInsets.only(bottom: 2), child: Icon(Icons.currency_rupee, size: 20)), label: 'Earnings'),
          BottomNavigationBarItem(icon: Padding(padding: EdgeInsets.only(bottom: 2), child: Icon(Icons.settings_outlined, size: 20)), label: 'Settings'),
        ],
      ),
    );
  }
}

