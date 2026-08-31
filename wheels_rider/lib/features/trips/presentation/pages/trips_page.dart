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

class TripsPage extends StatefulWidget {
  const TripsPage({super.key});

  @override
  State<TripsPage> createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> {
  int _currentIndex = 1; // Trips is selected
  String _selectedFilter = 'All Rides';
  late final TripsBloc _tripsBloc;

  @override
  void initState() {
    super.initState();
    _tripsBloc = sl<TripsBloc>()..add(GetTripsEvent());
  }

  @override
  void dispose() {
    _tripsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF9F9FC);

    return BlocProvider.value(
      value: _tripsBloc,
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
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 16),
                      _buildTopBar(isDark),
                      const SizedBox(height: 24),
                      _buildSearchAndFilters(isDark),
                      const SizedBox(height: 24),
                      _buildTotalMileageCard(isDark, tripData.totalMileage),
                      const SizedBox(height: 16),
                      _buildStatCardsRow(isDark, tripData.totalRides, tripData.avgRating),
                      const SizedBox(height: 32),
                      _buildTripsList(isDark, tripData.bookings),
                      const SizedBox(height: 24),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: const AssetImage('assets/images/login.png'),
                ),
                Positioned(
                  bottom: 0,
                  right: -2,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D6EFD), // Blue dot
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D6EFD),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(Icons.drive_eta, size: 10, color: Colors.white),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Alex',
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey.shade800 : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 12),
                      const SizedBox(width: 4),
                      Text(
                        '4.98',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 44,
              height: 44,
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
              child: const Icon(Icons.notifications_none, color: Colors.black87),
            ),
            Positioned(
              top: 10,
              right: 12,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
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
                height: 50,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    Icon(Icons.search, color: Colors.grey.shade500, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search rides, clients...',
                          hintStyle: GoogleFonts.inter(
                            fontSize: 15,
                            color: Colors.grey.shade500,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
              ),
              child: const Icon(Icons.tune, color: Colors.black87),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              'All Rides',
              'Corporate',
              'Private',
              'Last Month',
            ].map((filter) {
              final isSelected = filter == _selectedFilter;
              return GestureDetector(
                onTap: () => setState(() => _selectedFilter = filter),
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF0D52D6) : (isDark ? Colors.grey.shade800 : const Color(0xFFEFEFF4)),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Text(
                    filter,
                    style: GoogleFonts.inter(
                      fontSize: 14,
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

  Widget _buildTotalMileageCard(bool isDark, double totalMileage) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 15,
            offset: const Offset(0, 5),
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
                'TOTAL MILEAGE',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    totalMileage.toStringAsFixed(0),
                    style: GoogleFonts.inter(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF1E293B),
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'km',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            width: 80,
            height: 40,
            child: CustomPaint(
              painter: WavePainter(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCardsRow(bool isDark, int totalRides, double avgRating) {
    return Row(
      children: [
        Expanded(
          child: _buildSquareStatCard(
            icon: Icons.directions_car_outlined,
            iconColor: const Color(0xFF0D52D6),
            iconBg: const Color(0xFFEAF1FF),
            title: 'Total Rides',
            value: totalRides.toString(),
            isDark: isDark,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildSquareStatCard(
            icon: Icons.star_outline,
            iconColor: const Color(0xFFE23C00),
            iconBg: const Color(0xFFFFF0EA),
            title: 'Avg. Rating',
            value: avgRating.toStringAsFixed(2),
            isDark: isDark,
          ),
        ),
      ],
    );
  }

  Widget _buildSquareStatCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String value,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripsList(bool isDark, List<BookingEntity> bookings) {
    if (bookings.isEmpty) {
      return const AnimatedEmptyState(
        title: 'No Recent Bookings',
        subtitle: 'Complete trips to see your bookings here.',
        icon: Icons.history,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDateHeader('RECENT RIDES', isDark),
        const SizedBox(height: 12),
        ...bookings.map((booking) => Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
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
        fontSize: 12,
        fontWeight: FontWeight.w600,
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 15,
            offset: const Offset(0, 5),
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
              Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage('assets/images/login.png'), // Placeholder
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : const Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 12),
                          const SizedBox(width: 4),
                          Text(
                            rating,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade400,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEAF1FF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              tag,
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF0D52D6),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    price,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    status,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0D52D6),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Route Locations
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  const SizedBox(height: 4),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade500,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 24,
                    color: Colors.grey.shade300,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                  ),
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF0D52D6), width: 2),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pickup,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: isDark ? Colors.grey.shade300 : const Color(0xFF4A5568),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 24), // Spacing matches the line
                    Text(
                      dropoff,
                      style: GoogleFonts.inter(
                        fontSize: 14,
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
        selectedLabelStyle: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500),
        items: const [
          BottomNavigationBarItem(icon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.home_outlined)), activeIcon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.home)), label: 'Home'),
          BottomNavigationBarItem(icon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.history)), label: 'Trips'),
          BottomNavigationBarItem(icon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.currency_rupee)), label: 'Earnings'),
          BottomNavigationBarItem(icon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.settings_outlined)), label: 'Settings'),
        ],
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF0D52D6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(0, size.height * 0.7);
    
    // Draw a smooth bezier curve resembling the mockup sparkline
    path.cubicTo(
      size.width * 0.25, size.height * 0.7, 
      size.width * 0.25, size.height * 0.1, 
      size.width * 0.5, size.height * 0.1
    );
    path.cubicTo(
      size.width * 0.75, size.height * 0.1, 
      size.width * 0.75, size.height * 0.8, 
      size.width, size.height * 0.1
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
