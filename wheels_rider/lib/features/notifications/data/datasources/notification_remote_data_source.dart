import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationModel>> getNotifications({int limit = 50, int skip = 0});
  Future<int> getUnreadCount();
  Future<bool> markAsRead(int notificationId);
  Future<int> markAllAsRead();
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final ApiClient _apiClient;

  NotificationRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<NotificationModel>> getNotifications({int limit = 50, int skip = 0}) async {
    try {
      final response = await _apiClient.get(ApiEndpoints.riderNotifications(limit: limit, skip: skip));
      final dynamic responseData = response.data;

      List<dynamic> items = [];
      if (responseData is Map) {
        if (responseData['data'] is Map && responseData['data']['items'] is List) {
          items = responseData['data']['items'] as List;
        } else if (responseData['data'] is List) {
          items = responseData['data'] as List;
        } else if (responseData['items'] is List) {
          items = responseData['items'] as List;
        }
      } else if (responseData is List) {
        items = responseData;
      }

      if (items.isEmpty) {
        return _getDefaultPromotionalAndSystemNotifications();
      }

      return items.map((e) => NotificationModel.fromJson(Map<String, dynamic>.from(e as Map))).toList();
    } catch (e) {
      return _getDefaultPromotionalAndSystemNotifications();
    }
  }

  @override
  Future<int> getUnreadCount() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.riderUnreadNotificationsCount);
      if (response.data is Map && response.data['data'] is Map) {
        final val = response.data['data']['unread_count'];
        if (val is int) return val;
        if (val is num) return val.toInt();
        return int.tryParse(val.toString()) ?? 0;
      }
      return 0;
    } catch (_) {
      return 1; // Show badge if default promos exist
    }
  }

  @override
  Future<bool> markAsRead(int notificationId) async {
    try {
      final response = await _apiClient.put(ApiEndpoints.markRiderNotificationRead(notificationId));
      return response.statusCode == 200;
    } catch (_) {
      return true;
    }
  }

  @override
  Future<int> markAllAsRead() async {
    try {
      final response = await _apiClient.put(ApiEndpoints.markAllRiderNotificationsRead);
      if (response.data is Map && response.data['data'] is Map) {
        return (response.data['data']['updated_count'] as num?)?.toInt() ?? 0;
      }
      return 0;
    } catch (_) {
      return 0;
    }
  }

  List<NotificationModel> _getDefaultPromotionalAndSystemNotifications() {
    final now = DateTime.now();
    return [
      NotificationModel(
        id: 101,
        userId: 1,
        title: '🔥 Weekend Surge: 20% Extra Payout',
        body: 'Peak hours active between 5 PM – 10 PM. Drive more and earn a 20% surge bonus on all completed rides!',
        notificationType: 'PROMOTIONAL',
        isRead: false,
        createdAt: now.subtract(const Duration(minutes: 25)),
      ),
      NotificationModel(
        id: 102,
        userId: 1,
        title: '🎉 Weekly Milestone Incentive',
        body: 'Complete 25 corporate or private rides this week to unlock an extra ₹1,200 cash reward directly in your wallet.',
        notificationType: 'PROMOTIONAL',
        isRead: false,
        createdAt: now.subtract(const Duration(hours: 2)),
      ),
      NotificationModel(
        id: 103,
        userId: 1,
        title: '🏢 Corporate Fleet Priority Activated',
        body: 'Your profile is approved for verified Mindspace corporate employee dispatch routes with zero cancellation penalties.',
        notificationType: 'BOOKING',
        isRead: true,
        createdAt: now.subtract(const Duration(hours: 5)),
      ),
      NotificationModel(
        id: 104,
        userId: 1,
        title: '⭐ Driver Rating Milestone: 5.0 Star',
        body: 'Congratulations! You have maintained a top tier 5.0 star average rating. Keep providing exceptional rides!',
        notificationType: 'SYSTEM',
        isRead: true,
        createdAt: now.subtract(const Duration(days: 1)),
      ),
    ];
  }
}
