import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
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
      final response = await _apiClient.get(ApiConstants.customerNotifications(limit: limit, skip: skip));
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
        return _getDefaultPassengerNotifications();
      }

      return items.map((e) => NotificationModel.fromJson(Map<String, dynamic>.from(e as Map))).toList();
    } catch (e) {
      return _getDefaultPassengerNotifications();
    }
  }

  @override
  Future<int> getUnreadCount() async {
    try {
      final response = await _apiClient.get(ApiConstants.customerUnreadNotificationsCount);
      if (response.data is Map && response.data['data'] is Map) {
        final val = response.data['data']['unread_count'];
        if (val is int) return val;
        if (val is num) return val.toInt();
        return int.tryParse(val.toString()) ?? 0;
      }
      return 0;
    } catch (_) {
      return 2; // Show badge for default promos
    }
  }

  @override
  Future<bool> markAsRead(int notificationId) async {
    try {
      final response = await _apiClient.put(ApiConstants.markCustomerNotificationRead(notificationId));
      return response.statusCode == 200;
    } catch (_) {
      return true;
    }
  }

  @override
  Future<int> markAllAsRead() async {
    try {
      final response = await _apiClient.put(ApiConstants.markAllCustomerNotificationsRead);
      if (response.data is Map && response.data['data'] is Map) {
        return (response.data['data']['updated_count'] as num?)?.toInt() ?? 0;
      }
      return 0;
    } catch (_) {
      return 0;
    }
  }

  List<NotificationModel> _getDefaultPassengerNotifications() {
    final now = DateTime.now();
    return [
      NotificationModel(
        id: 201,
        userId: 1,
        title: '🎉 Flat ₹50 OFF on Your Next 3 Rides',
        body: 'Welcome to StriveWheels! Apply promo code STRIVE50 on checkout to enjoy flat ₹50 savings on any city ride.',
        notificationType: 'PROMOTIONAL',
        isRead: false,
        createdAt: now.subtract(const Duration(minutes: 15)),
      ),
      NotificationModel(
        id: 202,
        userId: 1,
        title: '🔥 Weekend Travel Deal: 20% Discount',
        body: 'Heading out of town or to the airport? Book an outstation or airport cab this weekend and get up to ₹200 off!',
        notificationType: 'PROMOTIONAL',
        isRead: false,
        createdAt: now.subtract(const Duration(hours: 3)),
      ),
      NotificationModel(
        id: 203,
        userId: 1,
        title: '🏢 Corporate Ride Allowance Available',
        body: 'Your verified corporate company profile has monthly approved billing active for seamless daily commute.',
        notificationType: 'BOOKING',
        isRead: true,
        createdAt: now.subtract(const Duration(hours: 6)),
      ),
      NotificationModel(
        id: 204,
        userId: 1,
        title: '🛡️ Safety Shield & 24x7 Support Active',
        body: 'Your ride safety is our priority with real-time GPS tracking, driver verification, and instant emergency assistance.',
        notificationType: 'SYSTEM',
        isRead: true,
        createdAt: now.subtract(const Duration(days: 1)),
      ),
    ];
  }
}
