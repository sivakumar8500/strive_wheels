import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../history/presentation/widgets/ride_history_top_bar.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../bloc/settings_bloc.dart';
import '../bloc/settings_event.dart';
import '../bloc/settings_state.dart';
import '../widgets/corporate_details_card.dart';
import '../widgets/logout_button.dart';
import '../widgets/personal_details_card.dart';
import '../widgets/profile_header_card.dart';
import '../widgets/settings_group_card.dart';
import '../widgets/user_stats_row.dart';
import '../../../../core/di/injection_container.dart';
import '../../../login/presentation/bloc/login_bloc.dart';
import '../../../login/presentation/pages/auth_page.dart';

/// User Profile & Settings Screen matching exact reference UI design.
class SettingsPage extends StatefulWidget {
  final VoidCallback? onMenuTap;
  final VoidCallback? onNotificationTap;

  const SettingsPage({
    super.key,
    this.onMenuTap,
    this.onNotificationTap,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    context.read<SettingsBloc>().add(const LoadSettingsEvent());
  }

  void _showComingSoonSnackBar(String featureName) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info_outline_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Text(
              '$featureName feature is coming soon!',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
            ),
          ],
        ),
        backgroundColor: AppColors.primaryBlue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showEditProfileBottomSheet(BuildContext context, UserProfileEntity? profile) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final nameController = TextEditingController(text: profile?.name ?? '');
    final phoneController = TextEditingController(text: profile?.phone ?? '');
    final emailController = TextEditingController(text: profile?.email ?? '');
    String selectedGender = profile?.gender ?? 'Female';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: isDark ? AppColors.onboardingBgDark : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (bottomSheetContext) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 24,
                bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom +
                    MediaQuery.of(bottomSheetContext).padding.bottom +
                    24,
              ),
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
                  Text(
                    'Edit Personal Details',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.white : AppColors.onboardingTextPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.person_outline_rounded),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.phone_android_rounded),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.email_outlined),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Gender',
                    style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: ['Female', 'Male', 'Other'].map((g) {
                      final isSel = selectedGender == g;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(g),
                          selected: isSel,
                          onSelected: (val) {
                            if (val) {
                              setModalState(() {
                                selectedGender = g;
                              });
                            }
                          },
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        context.read<SettingsBloc>().add(
                              UpdateUserProfileEvent(
                                name: nameController.text,
                                phone: phoneController.text,
                                email: emailController.text,
                                gender: selectedGender,
                              ),
                            );
                        Navigator.pop(bottomSheetContext);
                      },
                      child: Text(
                        'Save Changes',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showContactSupportModal(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: isDark ? AppColors.onboardingBgDark : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (bottomSheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(bottomSheetContext).padding.bottom + 24,
          ),
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
                children: [
                  const Icon(Icons.support_agent_rounded, color: AppColors.primaryBlue, size: 26),
                  const SizedBox(width: 10),
                  Text(
                    'Contact Us & Support',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.white : AppColors.onboardingTextPrimaryLight,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'We are here 24/7 to help you with your rides, fares, or safety concerns.',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.onboardingTextSecondaryLight,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.phone_in_talk_rounded, color: AppColors.primaryBlue),
                ),
                title: Text('Customer Care Helpline', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14)),
                subtitle: Text('+91 1800-123-4567 (Toll Free)', style: GoogleFonts.inter(fontSize: 13)),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Calling Support Helpline: +91 1800-123-4567')),
                    );
                  },
                  child: const Text('Call Now'),
                ),
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.email_rounded, color: Color(0xFF10B981)),
                ),
                title: Text('Email Support', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14)),
                subtitle: Text('support@strivewheels.com', style: GoogleFonts.inter(fontSize: 13)),
                trailing: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF10B981)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Email support ticket initialized')),
                    );
                  },
                  child: const Text('Email Us', style: TextStyle(color: Color(0xFF10B981))),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showTermsConditionsModal(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: isDark ? AppColors.onboardingBgDark : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (bottomSheetContext) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(bottomSheetContext).size.height * 0.75,
          ),
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(bottomSheetContext).padding.bottom + 24,
          ),
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
                children: [
                  const Icon(Icons.description_outlined, color: AppColors.primaryBlue, size: 26),
                  const SizedBox(width: 10),
                  Text(
                    'Terms & Conditions',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.white : AppColors.onboardingTextPrimaryLight,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Text(
                    'Welcome to StriveWheels. By booking a ride through our platform, you agree to comply with all transport guidelines, safety norms, fare regulations, and community standards.\n\n'
                    '1. Ride Bookings & Cancellations: Rides must be booked through the official app. Cancellation charges may apply if a ride is cancelled after driver allocation.\n\n'
                    '2. Fares & Payments: Estimated fares are subject to traffic conditions, route variations, and surge pricing during peak hours. Full payment must be completed upon ride completion.\n\n'
                    '3. Safety & Behavior: Users must refrain from damaging vehicle property, treating drivers respectfully, and adhering to local traffic regulations.\n\n'
                    '4. Liability: StriveWheels facilitates rides through verified drivers and holds safety as top priority.',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      height: 1.5,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.onboardingTextSecondaryLight,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => Navigator.pop(bottomSheetContext),
                  child: Text('Close', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPrivacyPolicyModal(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: isDark ? AppColors.onboardingBgDark : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (bottomSheetContext) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(bottomSheetContext).size.height * 0.75,
          ),
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(bottomSheetContext).padding.bottom + 24,
          ),
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
                children: [
                  const Icon(Icons.shield_outlined, color: Color(0xFF10B981), size: 26),
                  const SizedBox(width: 10),
                  Text(
                    'Privacy Policy',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.white : AppColors.onboardingTextPrimaryLight,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Text(
                    'At StriveWheels, we prioritize protecting your personal data and location privacy.\n\n'
                    '1. Data Collection: We collect necessary information including your name, phone number, email address, and precise GPS location to facilitate seamless pickup and trip tracking.\n\n'
                    '2. Location Usage: Your live location is accessed while using the app to calculate fares, display nearby drivers, and provide accurate navigation.\n\n'
                    '3. Data Protection & Sharing: We do not sell or share your personal details with unauthorized third parties. All communication between the app and servers is encrypted.\n\n'
                    '4. Your Rights: You have the right to request deletion of your account data or update your profile details at any time.',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      height: 1.5,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.onboardingTextSecondaryLight,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => Navigator.pop(bottomSheetContext),
                  child: Text('Got It', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
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
      appBar: RideHistoryTopBar(
        onMenuTap: widget.onMenuTap,
        onNotificationTap: widget.onNotificationTap,
      ),
      body: BlocConsumer<SettingsBloc, SettingsState>(
        listener: (context, state) {
          if (state.isLoggedOut) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (_) => BlocProvider<LoginBloc>(
                  create: (_) => sl<LoginBloc>(),
                  child: const AuthPage(),
                ),
              ),
              (route) => false,
            );
          } else if (state.actionMessage != null) {
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

          final entity = state.settingsEntity;
          final profile = entity?.profile;

          final bool isCorpUser = profile?.isCorporate == true;
          final String? compName = profile?.companyName;
          final bool hasCorporateInfo = isCorpUser &&
              compName != null &&
              compName.trim().isNotEmpty;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 8,
              bottom: 110,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Profile Avatar & Info Card
                ProfileHeaderCard(
                  name: (profile?.name != null && profile!.name.trim().isNotEmpty) ? profile.name : 'User',
                  membershipTier: profile?.membershipTier ?? AppStrings.diamondMember,
                  onEditProfileTap: () => _showEditProfileBottomSheet(context, profile),
                ),

                const SizedBox(height: 20),

                // 2. User Stats Row (Total Rides & Rating)
                UserStatsRow(
                  totalRides: profile?.totalRides ?? '0',
                  rating: profile?.rating ?? '5.0',
                ),

                const SizedBox(height: 20),

                // 3. Direct Personal Details Card
                PersonalDetailsCard(
                  phone: profile?.phone ?? '',
                  email: (profile?.email != null && profile!.email.trim().isNotEmpty)
                      ? profile.email
                      : (profile?.corporateEmail ?? 'No email provided'),
                  gender: profile?.gender ?? 'Not Specified',
                  onEditTap: () => _showEditProfileBottomSheet(context, profile),
                ),

                // 4. Corporate Collaborated Company Card (Hidden if not corporate-collaborated)
                if (hasCorporateInfo) ...[
                  const SizedBox(height: 20),
                  CorporateDetailsCard(
                    companyName: profile!.companyName!,
                    corporateEmail: profile.corporateEmail,
                    corporateId: profile.corporateId,
                    department: profile.department,
                    designation: profile.designation,
                    spendingLimit: profile.spendingLimit,
                    location: profile.companyLocation,
                  ),
                ],

                const SizedBox(height: 20),

                // 5. Account Settings Group (Wallet & Payments)
                SettingsGroupCard(
                  categoryTitle: AppStrings.accountCategory,
                  rows: [
                    SettingsRowData(
                      title: AppStrings.walletAndPayments,
                      subtitle: AppStrings.walletAndPaymentsSub,
                      icon: Icons.account_balance_wallet_outlined,
                      onTap: () => _showComingSoonSnackBar(AppStrings.walletAndPayments),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // 6. Preferences Settings Group
                SettingsGroupCard(
                  categoryTitle: AppStrings.preferencesCategory,
                  rows: [
                    SettingsRowData(
                      title: AppStrings.rideNotifications,
                      subtitle: AppStrings.rideNotificationsSub,
                      icon: Icons.notifications_active_outlined,
                      isSwitch: true,
                      switchValue: state.rideNotificationsEnabled,
                      onSwitchChanged: (value) {
                        context
                            .read<SettingsBloc>()
                            .add(ToggleRideNotificationsEvent(value));
                      },
                    ),
                    SettingsRowData(
                      title: AppStrings.appearance,
                      subtitle: state.isDarkMode ? 'Dark mode' : AppStrings.lightMode,
                      icon: Icons.brightness_4_outlined,
                      isSwitch: true,
                      switchValue: state.isDarkMode,
                      onSwitchChanged: (value) {
                        context
                            .read<SettingsBloc>()
                            .add(ToggleDarkModeEvent(value));
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // 7. Support & Legal Group
                SettingsGroupCard(
                  categoryTitle: 'Support & Legal',
                  rows: [
                    SettingsRowData(
                      title: 'Contact Us & Support',
                      subtitle: 'Get help 24/7 or talk to customer care',
                      icon: Icons.support_agent_rounded,
                      onTap: () => _showContactSupportModal(context),
                    ),
                    SettingsRowData(
                      title: 'Terms & Conditions',
                      subtitle: 'Service rules and user agreement',
                      icon: Icons.description_outlined,
                      onTap: () => _showTermsConditionsModal(context),
                    ),
                    SettingsRowData(
                      title: 'Privacy Policy',
                      subtitle: 'Data usage and privacy information',
                      icon: Icons.shield_outlined,
                      onTap: () => _showPrivacyPolicyModal(context),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // 8. Logout Button
                LogoutButton(
                  onLogoutTap: () {
                    context.read<SettingsBloc>().add(const LogoutEvent());
                  },
                ),

                const SizedBox(height: 20),

                // 9. App Version Footer
                Center(
                  child: Text(
                    entity?.appVersion ?? AppStrings.appVersionString,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.onboardingTextSecondaryLight,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
