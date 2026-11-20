import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';

class QuickServiceItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color bgColor;
  final Color iconColor;

  const QuickServiceItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.bgColor,
    required this.iconColor,
  });
}

class QuickServicesGrid extends StatelessWidget {
  final Function(String serviceName)? onServiceTap;

  const QuickServicesGrid({
    super.key,
    this.onServiceTap,
  });

  static const List<QuickServiceItem> _services = [
    QuickServiceItem(
      title: AppStrings.serviceBike,
      subtitle: AppStrings.serviceBikeSubtitle,
      icon: Icons.two_wheeler_rounded,
      bgColor: AppColors.bikeServiceBg,
      iconColor: AppColors.bikeServiceIcon,
    ),
    QuickServiceItem(
      title: AppStrings.serviceAuto,
      subtitle: AppStrings.serviceAutoSubtitle,
      icon: Icons.electric_rickshaw_rounded,
      bgColor: AppColors.autoServiceBg,
      iconColor: AppColors.autoServiceIcon,
    ),
    QuickServiceItem(
      title: AppStrings.serviceCab,
      subtitle: AppStrings.serviceCabSubtitle,
      icon: Icons.directions_car_rounded,
      bgColor: AppColors.cabServiceBg,
      iconColor: AppColors.cabServiceIcon,
    ),
    QuickServiceItem(
      title: AppStrings.serviceRental,
      subtitle: AppStrings.serviceRentalSubtitle,
      icon: Icons.access_time_filled_rounded,
      bgColor: AppColors.rentalServiceBg,
      iconColor: AppColors.rentalServiceIcon,
    ),
    QuickServiceItem(
      title: AppStrings.serviceParcel,
      subtitle: AppStrings.serviceParcelSubtitle,
      icon: Icons.inventory_2_rounded,
      bgColor: AppColors.parcelServiceBg,
      iconColor: AppColors.parcelServiceIcon,
    ),
    QuickServiceItem(
      title: AppStrings.serviceCourier,
      subtitle: AppStrings.serviceCourierSubtitle,
      icon: Icons.send_rounded,
      bgColor: AppColors.courierServiceBg,
      iconColor: AppColors.courierServiceIcon,
    ),
    QuickServiceItem(
      title: AppStrings.serviceAirport,
      subtitle: AppStrings.serviceAirportSubtitle,
      icon: Icons.account_balance_rounded,
      bgColor: AppColors.airportServiceBg,
      iconColor: AppColors.airportServiceIcon,
    ),
    QuickServiceItem(
      title: AppStrings.serviceCorporate,
      subtitle: AppStrings.serviceCorporateSubtitle,
      icon: Icons.receipt_long_rounded,
      bgColor: AppColors.corporateServiceBg,
      iconColor: AppColors.corporateServiceIcon,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _services.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 16,
        childAspectRatio: 0.72,
      ),
      itemBuilder: (context, index) {
        final item = _services[index];
        return InkWell(
          onTap: () => onServiceTap?.call(item.title),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.serviceTileBgDark
                  : AppColors.serviceTileBgLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: item.bgColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    item.icon,
                    color: item.iconColor,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.title,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppColors.white
                        : AppColors.onboardingTextPrimaryLight,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  item.subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.onboardingTextSecondaryLight,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
