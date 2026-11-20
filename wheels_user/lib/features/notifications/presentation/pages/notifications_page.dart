import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection_container.dart';
import '../../domain/entities/notification_entity.dart';
import '../bloc/notification_bloc.dart';
import '../bloc/notification_event.dart';
import '../bloc/notification_state.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (_) => BlocProvider<NotificationBloc>(
        create: (_) => sl<NotificationBloc>()..add(const LoadNotificationsEvent()),
        child: const NotificationsPage(),
      ),
    );
  }

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late final NotificationBloc _notificationBloc;
  String _selectedFilter = 'ALL'; // 'ALL', 'PROMOTIONAL', 'BOOKING', 'SYSTEM'

  @override
  void initState() {
    super.initState();
    _notificationBloc = sl<NotificationBloc>()..add(const LoadNotificationsEvent());
  }

  @override
  void dispose() {
    _notificationBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider.value(
      value: _notificationBloc,
      child: Scaffold(
        backgroundColor: isDark ? AppColors.onboardingBgDark : const Color(0xFFF8FAFC),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: isDark ? AppColors.cardBgDark : Colors.white,
          leading: IconButton(
            key: const Key('notifications_back_button'),
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
              color: isDark ? Colors.white : const Color(0xFF1E293B),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'Notifications',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF1E293B),
            ),
          ),
          actions: [
            BlocBuilder<NotificationBloc, NotificationState>(
              builder: (context, state) {
                final hasUnread = state is NotificationLoaded && state.unreadCount > 0;
                if (!hasUnread) return const SizedBox.shrink();

                return TextButton.icon(
                  key: const Key('mark_all_read_button'),
                  onPressed: () {
                    _notificationBloc.add(const MarkAllNotificationsAsReadEvent());
                  },
                  icon: const Icon(Icons.done_all_rounded, size: 16, color: AppColors.primaryBlue),
                  label: Text(
                    'Mark all read',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: Column(
          children: [
            // Filter Pills Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: isDark ? AppColors.cardBgDark : Colors.white,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    _buildFilterChip('All', 'ALL', isDark),
                    const SizedBox(width: 8),
                    _buildFilterChip('🔥 Offers & Promos', 'PROMOTIONAL', isDark),
                    const SizedBox(width: 8),
                    _buildFilterChip('🚗 Rides & Trips', 'BOOKING', isDark),
                    const SizedBox(width: 8),
                    _buildFilterChip('🔔 System & Alerts', 'SYSTEM', isDark),
                  ],
                ),
              ),
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            ),

            // Notifications List
            Expanded(
              child: BlocBuilder<NotificationBloc, NotificationState>(
                builder: (context, state) {
                  if (state is NotificationLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
                      ),
                    );
                  }

                  if (state is NotificationError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline_rounded, size: 48, color: Colors.red.shade400),
                            const SizedBox(height: 12),
                            Text(
                              'Failed to load notifications',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              state.message,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => _notificationBloc.add(const LoadNotificationsEvent()),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryBlue,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: const Text('Try Again', style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (state is NotificationLoaded) {
                    final filteredList = _filterNotifications(state.notifications);

                    if (filteredList.isEmpty) {
                      return RefreshIndicator(
                        onRefresh: () async {
                          _notificationBloc.add(const LoadNotificationsEvent());
                        },
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            SizedBox(height: MediaQuery.of(context).size.height * 0.25),
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.notifications_off_outlined,
                                      size: 40,
                                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No notifications found',
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? Colors.white : Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _selectedFilter == 'ALL'
                                        ? 'You are completely caught up!'
                                        : 'No ${_selectedFilter.toLowerCase()} notifications at this time.',
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () async {
                        _notificationBloc.add(const LoadNotificationsEvent());
                      },
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                        itemCount: filteredList.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final item = filteredList[index];
                          return _buildNotificationCard(item, isDark);
                        },
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, bool isDark) {
    final isSelected = _selectedFilter == value;

    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryBlue
              : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryBlue
                : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected
                ? Colors.white
                : (isDark ? Colors.grey.shade300 : const Color(0xFF334155)),
          ),
        ),
      ),
    );
  }

  List<NotificationEntity> _filterNotifications(List<NotificationEntity> all) {
    if (_selectedFilter == 'ALL') return all;
    if (_selectedFilter == 'PROMOTIONAL') {
      return all.where((n) =>
          n.notificationType == 'PROMOTIONAL' ||
          n.notificationType == 'PROMOTION' ||
          n.title.toLowerCase().contains('discount') ||
          n.title.toLowerCase().contains('off') ||
          n.title.toLowerCase().contains('deal') ||
          n.title.toLowerCase().contains('coupon') ||
          n.title.toLowerCase().contains('promo') ||
          n.title.toLowerCase().contains('%')).toList();
    }
    if (_selectedFilter == 'BOOKING') {
      return all.where((n) =>
          n.notificationType == 'BOOKING' ||
          n.notificationType == 'TRIP_UPDATE' ||
          n.title.toLowerCase().contains('ride') ||
          n.title.toLowerCase().contains('trip') ||
          n.title.toLowerCase().contains('driver') ||
          n.title.toLowerCase().contains('booking')).toList();
    }
    return all.where((n) =>
        n.notificationType == 'SYSTEM' ||
        n.notificationType == 'ALERT' ||
        n.notificationType == _selectedFilter).toList();
  }

  Widget _buildNotificationCard(NotificationEntity item, bool isDark) {
    final isPromo = item.notificationType == 'PROMOTIONAL' ||
        item.notificationType == 'PROMOTION' ||
        item.title.toLowerCase().contains('discount') ||
        item.title.toLowerCase().contains('off') ||
        item.title.toLowerCase().contains('deal') ||
        item.title.toLowerCase().contains('coupon') ||
        item.title.toLowerCase().contains('promo') ||
        item.title.toLowerCase().contains('%');

    final isTrip = item.notificationType == 'BOOKING' ||
        item.notificationType == 'TRIP_UPDATE' ||
        item.title.toLowerCase().contains('ride') ||
        item.title.toLowerCase().contains('trip');

    Color iconBgColor;
    Color iconColor;
    IconData iconData;
    String badgeText = 'NOTIFICATION';

    if (isPromo) {
      iconBgColor = const Color(0xFFFF9800).withValues(alpha: 0.15);
      iconColor = const Color(0xFFFF9800);
      iconData = Icons.local_fire_department_rounded;
      badgeText = 'PROMO OFFER';
    } else if (isTrip) {
      iconBgColor = const Color(0xFF0D6EFD).withValues(alpha: 0.15);
      iconColor = const Color(0xFF0D6EFD);
      iconData = Icons.directions_car_rounded;
      badgeText = 'RIDE UPDATE';
    } else {
      iconBgColor = const Color(0xFF8B5CF6).withValues(alpha: 0.15);
      iconColor = const Color(0xFF8B5CF6);
      iconData = Icons.notifications_active_rounded;
      badgeText = 'SYSTEM';
    }

    final formattedDate = _formatTimeAgo(item.createdAt);

    return GestureDetector(
      onTap: () {
        if (!item.isRead) {
          _notificationBloc.add(MarkNotificationAsReadEvent(item.id));
        }
        if (isPromo) {
          _showPromoDetailsDialog(item, isDark);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: item.isRead
              ? (isDark ? AppColors.cardBgDark : Colors.white)
              : (isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF)),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: item.isRead
                ? (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0))
                : AppColors.primaryBlue.withValues(alpha: 0.4),
            width: item.isRead ? 1 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon Badge
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(iconData, color: iconColor, size: 22),
            ),
            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: iconColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          badgeText,
                          style: GoogleFonts.inter(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: iconColor,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        formattedDate,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
                        ),
                      ),
                      if (!item.isRead) ...[
                        const SizedBox(width: 6),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryBlue,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.title,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: item.isRead ? FontWeight.w600 : FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.body,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: isDark ? Colors.grey.shade300 : const Color(0xFF475569),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPromoDetailsDialog(NotificationEntity item, bool isDark) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.cardBgDark : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.celebration_rounded, color: Colors.orange, size: 22),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Promotional Offer',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.title,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              item.body,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: isDark ? Colors.grey.shade300 : Colors.grey.shade600,
                height: 1.5,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Close',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Promo applied to your ride account!',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                  ),
                  backgroundColor: const Color(0xFF10A142),
                  duration: const Duration(seconds: 3),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(
              'Use Now',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]}';
  }
}
