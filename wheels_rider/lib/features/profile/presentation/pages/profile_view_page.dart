import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';


import '../../../../core/widgets/corporate_details_card.dart';
import '../../../../core/widgets/zoomable_image_dialog.dart';
import '../../domain/entities/profile_entity.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import 'edit_profile_page.dart';

class ProfileViewPage extends StatefulWidget {
  final ProfileEntity? initialProfile;

  const ProfileViewPage({super.key, this.initialProfile});

  @override
  State<ProfileViewPage> createState() => _ProfileViewPageState();
}

class _ProfileViewPageState extends State<ProfileViewPage> {
  ProfileEntity? _currentProfile;

  @override
  void initState() {
    super.initState();
    _currentProfile = widget.initialProfile;
    context.read<ProfileBloc>().add(GetProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFFBFAFD);
    final cardBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          'Driver Profile',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        centerTitle: true,
        backgroundColor: cardBg,
        elevation: 0,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black87),
        actions: [
          if (_currentProfile != null)
            IconButton(
              icon: const Icon(Icons.edit_note, color: Color(0xFF0D6EFD), size: 26),
              tooltip: 'Edit Profile',
              onPressed: () => _navigateToEditProfile(context, _currentProfile!),
            ),
        ],
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded) {
            setState(() {
              _currentProfile = state.profile;
            });
          } else if (state is ProfileUpdateSuccess) {
            setState(() {
              _currentProfile = state.profile;
            });
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading && _currentProfile == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final profile = _currentProfile ??
              (state is ProfileLoaded
                  ? state.profile
                  : (state is ProfileUpdateSuccess ? state.profile : null));

          if (profile == null) {
            if (state is ProfileError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline_rounded, color: Colors.red, size: 48),
                      const SizedBox(height: 12),
                      Text(
                        'Failed to load profile',
                        style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(fontSize: 13, color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => context.read<ProfileBloc>().add(GetProfileEvent()),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          }

          final hasCorporate = profile.isCorporate ||
              (profile.companyName != null && profile.companyName!.trim().isNotEmpty);

          return RefreshIndicator(
            onRefresh: () async {
              context.read<ProfileBloc>().add(GetProfileEvent());
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Profile Hero Card
                  _buildHeroCard(isDark, cardBg, profile),
                  const SizedBox(height: 18),

                  // 2. Earnings & Performance Strip
                  _buildMetricsStrip(isDark, cardBg, profile),
                  const SizedBox(height: 24),

                  // 3. Personal Information
                  _buildSectionHeader('PERSONAL INFORMATION', isDark),
                  const SizedBox(height: 10),
                  _buildPersonalInfoCard(isDark, cardBg, profile),
                  const SizedBox(height: 24),

                  // 4. Vehicle Details
                  _buildSectionHeader('REGISTERED VEHICLE', isDark),
                  const SizedBox(height: 10),
                  _buildVehicleCard(isDark, cardBg, profile),
                  const SizedBox(height: 24),

                  // 5. Corporate Details (if associated)
                  if (hasCorporate) ...[
                    _buildSectionHeader('CORPORATE PARTNER', isDark),
                    const SizedBox(height: 10),
                    CorporateDetailsCard(
                      companyName: profile.companyName ?? 'Corporate Partner',
                      corporateApprovalStatus: profile.corporateApprovalStatus,
                      corporateRoute: profile.corporateRoute,
                      companyLocation: profile.companyLocation,
                      companyEmail: profile.companyEmail,
                      companyPhone: profile.companyPhone,
                    ),
                    const SizedBox(height: 24),
                  ],

                  // 6. KYC & Verification
                  _buildSectionHeader('VERIFICATION & COMPLIANCE', isDark),
                  const SizedBox(height: 10),
                  _buildComplianceCard(isDark, cardBg, profile),
                  const SizedBox(height: 28),

                  // 7. Edit Profile Button
                  SizedBox(
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () => _navigateToEditProfile(context, profile),
                      icon: const Icon(Icons.edit, size: 18),
                      label: Text(
                        'Edit Profile Details',
                        style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D6EFD),
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _navigateToEditProfile(BuildContext context, ProfileEntity profile) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<ProfileBloc>(),
          child: EditProfilePage(profile: profile),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _buildHeroCard(bool isDark, Color cardBg, ProfileEntity profile) {
    final nameText = profile.name.isNotEmpty ? profile.name : 'Puja Sri';
    final imageUrl = profile.profileImageUrl;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              ZoomableImageDialog.show(
                context,
                imagePath: imageUrl,
                title: nameText,
              );
            },
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFF0D6EFD), Color(0xFF00C6FF)],
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 44,
                    backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                    child: ClipOval(
                      child: imageUrl.isNotEmpty
                          ? Image.network(
                              imageUrl,
                              width: 88,
                              height: 88,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Image.asset(
                                'assets/images/strive_logo.jpg',
                                width: 88,
                                height: 88,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Image.asset(
                              'assets/images/strive_logo.jpg',
                              width: 88,
                              height: 88,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 2,
                  right: 2,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981),
                      shape: BoxShape.circle,
                      border: Border.all(color: cardBg, width: 2),
                    ),
                    child: const Icon(Icons.check, size: 12, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            nameText,
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Color(0xFF10B981),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'VERIFIED DRIVER',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF10B981),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsStrip(bool isDark, Color cardBg, ProfileEntity profile) {
    final ratingVal = profile.rating > 0 ? profile.rating.toStringAsFixed(1) : '5.0';
    final earningsVal = profile.totalEarnings.toStringAsFixed(0);
    final walletVal = profile.walletBalance.toStringAsFixed(0);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildMetricItem(
            icon: Icons.star_rounded,
            iconColor: const Color(0xFFFFB800),
            value: '$ratingVal ★',
            label: 'RATING',
            isDark: isDark,
          ),
          Container(width: 1, height: 32, color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
          _buildMetricItem(
            icon: Icons.payments_rounded,
            iconColor: const Color(0xFF10B981),
            value: '₹$earningsVal',
            label: 'EARNINGS',
            isDark: isDark,
          ),
          Container(width: 1, height: 32, color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
          _buildMetricItem(
            icon: Icons.account_balance_wallet_rounded,
            iconColor: const Color(0xFF0D6EFD),
            value: '₹$walletVal',
            label: 'WALLET',
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
    required bool isDark,
  }) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: iconColor),
            const SizedBox(width: 4),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF1E293B),
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade500,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalInfoCard(bool isDark, Color cardBg, ProfileEntity profile) {
    final phoneText = profile.phone.isNotEmpty ? profile.phone : '+91 9876543210';
    final emailText = profile.email.isNotEmpty ? profile.email : 'rider@strivewheels.com';
    final dobText = profile.dob.isNotEmpty ? profile.dob : 'Not specified';
    final genderText = profile.gender.isNotEmpty ? profile.gender.toUpperCase() : 'MALE';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildDetailRow(Icons.phone_android_rounded, 'Mobile Number', phoneText, isDark),
          Divider(height: 20, color: isDark ? Colors.grey.shade800 : Colors.grey.shade100),
          _buildDetailRow(Icons.email_outlined, 'Email Address', emailText, isDark),
          Divider(height: 20, color: isDark ? Colors.grey.shade800 : Colors.grey.shade100),
          _buildDetailRow(Icons.cake_outlined, 'Date of Birth', dobText, isDark),
          Divider(height: 20, color: isDark ? Colors.grey.shade800 : Colors.grey.shade100),
          _buildDetailRow(Icons.person_outline_rounded, 'Gender', genderText, isDark),
        ],
      ),
    );
  }

  Widget _buildVehicleCard(bool isDark, Color cardBg, ProfileEntity profile) {
    final makeModel = "${profile.vehicleMake} ${profile.vehicleModel}".trim();
    final plateNumber = profile.vehicleNumber.isNotEmpty ? profile.vehicleNumber : 'TS 09 EQ 1234';
    final colorYear = "${profile.vehicleColor} • ${profile.vehicleYear}";
    final typeFuel = "${profile.vehicleType} • ${profile.fuelType}";

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D6EFD).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.directions_car_filled, color: Color(0xFF0D6EFD), size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      makeModel.isNotEmpty ? makeModel : 'Toyota Innova Crysta',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      plateNumber,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF0D6EFD),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'ACTIVE',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF10B981),
                  ),
                ),
              ),
            ],
          ),
          Divider(height: 24, color: isDark ? Colors.grey.shade800 : Colors.grey.shade100),
          _buildDetailRow(Icons.palette_outlined, 'Color & Year', colorYear, isDark),
          Divider(height: 20, color: isDark ? Colors.grey.shade800 : Colors.grey.shade100),
          _buildDetailRow(Icons.local_gas_station_outlined, 'Category & Fuel', typeFuel, isDark),
        ],
      ),
    );
  }

  Widget _buildComplianceCard(bool isDark, Color cardBg, ProfileEntity profile) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildComplianceItem('Driving License (DL)', 'VERIFIED', true, isDark),
          Divider(height: 20, color: isDark ? Colors.grey.shade800 : Colors.grey.shade100),
          _buildComplianceItem('Vehicle Registration (RC)', 'VERIFIED', true, isDark),
          Divider(height: 20, color: isDark ? Colors.grey.shade800 : Colors.grey.shade100),
          _buildComplianceItem('Vehicle Insurance', 'VALID', true, isDark),
          Divider(height: 20, color: isDark ? Colors.grey.shade800 : Colors.grey.shade100),
          _buildComplianceItem('Background Verification', 'APPROVED', true, isDark),
        ],
      ),
    );
  }

  Widget _buildComplianceItem(String title, String badgeText, bool isVerified, bool isDark) {
    final badgeColor = isVerified ? const Color(0xFF10B981) : Colors.orange;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              isVerified ? Icons.verified_user_rounded : Icons.pending_actions_rounded,
              size: 16,
              color: badgeColor,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white70 : const Color(0xFF334155),
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: badgeColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            badgeText,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: badgeColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, bool isDark) {
    return Row(
      children: [
        Icon(icon, size: 16, color: isDark ? Colors.grey.shade400 : Colors.grey.shade500),
        const SizedBox(width: 10),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : const Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }
}
