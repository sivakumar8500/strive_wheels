import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../history/presentation/widgets/ride_history_top_bar.dart';
import '../bloc/settings_bloc.dart';
import '../bloc/settings_event.dart';
import '../bloc/settings_state.dart';
import '../widgets/logout_button.dart';
import '../widgets/profile_header_card.dart';
import '../widgets/settings_group_card.dart';
import '../widgets/user_stats_row.dart';

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

          final entity = state.settingsEntity;
          final profile = entity?.profile;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 8,
              bottom: 32,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Profile Avatar & Info Card
                ProfileHeaderCard(
                  name: profile?.name ?? AppStrings.alexanderPierce,
                  membershipTier: profile?.membershipTier ?? AppStrings.diamondMember,
                  onEditProfileTap: () {
                    context
                        .read<SettingsBloc>()
                        .add(const SelectSettingItemEvent('Profile Edit'));
                  },
                ),

                const SizedBox(height: 20),

                // 2. User Stats Row (Total Rides & Rating)
                UserStatsRow(
                  totalRides: profile?.totalRides ?? AppStrings.totalRidesCount,
                  rating: profile?.rating ?? AppStrings.ratingValue,
                ),

                const SizedBox(height: 24),

                // 3. Account Settings Group
                SettingsGroupCard(
                  categoryTitle: AppStrings.accountCategory,
                  rows: [
                    SettingsRowData(
                      title: AppStrings.personalDetails,
                      subtitle: AppStrings.personalDetailsSub,
                      icon: Icons.person_outline_rounded,
                      onTap: () {
                        context.read<SettingsBloc>().add(
                              const SelectSettingItemEvent(
                                  AppStrings.personalDetails),
                            );
                      },
                    ),
                    SettingsRowData(
                      title: AppStrings.walletAndPayments,
                      subtitle: AppStrings.walletAndPaymentsSub,
                      icon: Icons.account_balance_wallet_outlined,
                      onTap: () {
                        context.read<SettingsBloc>().add(
                              const SelectSettingItemEvent(
                                  AppStrings.walletAndPayments),
                            );
                      },
                    ),
                    SettingsRowData(
                      title: AppStrings.corporateProfile,
                      subtitle: AppStrings.corporateProfileSub,
                      icon: Icons.credit_card_outlined,
                      onTap: () {
                        context.read<SettingsBloc>().add(
                              const SelectSettingItemEvent(
                                  AppStrings.corporateProfile),
                            );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // 4. Preferences Settings Group
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
                    SettingsRowData(
                      title: AppStrings.language,
                      subtitle: entity?.selectedLanguage ?? AppStrings.englishIndia,
                      icon: Icons.language_outlined,
                      onTap: () {
                        context.read<SettingsBloc>().add(
                              const SelectSettingItemEvent(AppStrings.language),
                            );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // 5. Logout Button
                LogoutButton(
                  onLogoutTap: () {
                    context.read<SettingsBloc>().add(const LogoutEvent());
                  },
                ),

                const SizedBox(height: 20),

                // 6. App Version Footer
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
