class ApiConstants {
  // Base URLs
  static const String baseUrl = 'http://15.252.129.37:8200';
  static const String wsBaseUrl = 'ws://15.252.129.37:8200/api/v1';

  /// Returns full image URL by prepending baseUrl if the path is relative.
  static String getImageUrl(String? path) {
    if (path == null || path.trim().isEmpty) return '';
    final cleanPath = path.trim();
    if (cleanPath.startsWith('http://') ||
        cleanPath.startsWith('https://') ||
        cleanPath.startsWith('blob:') ||
        cleanPath.startsWith('file://') ||
        cleanPath.startsWith('/data/') ||
        cleanPath.startsWith('/var/') ||
        cleanPath.startsWith('/private/') ||
        cleanPath.startsWith('/Users/') ||
        cleanPath.contains(RegExp(r'^[a-zA-Z]:[\\/]'))) {
      return cleanPath;
    }
    if (!cleanPath.startsWith('/')) {
      return '$baseUrl/$cleanPath';
    }
    return '$baseUrl$cleanPath';
  }
  
  // Timeout constants
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // Header keys
  static const String contentTypeKey = 'Content-Type';
  static const String authorizationKey = 'Authorization';
  
  // Header values
  static const String applicationJson = 'application/json';

  // Auth Endpoints
  static const String sendOtp = '/api/v1/auth/send-otp';
  static const String verifyOtp = '/api/v1/auth/verify-otp';
  static const String updateFcmToken = '/api/v1/auth/fcm-token';

  // Profile Endpoints
  static const String customerProfile = '/api/v1/customer/profile';

  // Saved Locations Endpoints
  static const String savedLocations = '/api/v1/customer/saved-locations';
  static const String addLocations = '/api/v1/customer/saved-locations';

  // Explore & Discover Endpoints
  static const String quickServices = '/api/v1/customer/quick-services';
  static const String popularLocations = '/api/v1/customer/popular-locations';

  // Bookings & History Endpoints
  static const String bookings = '/api/v1/customer/bookings';
  static const String vehicleTypes = '/api/v1/customer/vehicle-types';
  static const String fareEstimate = '/api/v1/bookings/fare-estimate';

  // Offers Endpoints
  static const String coupons = '/api/v1/customer/coupons';

  // Notifications Endpoints
  static String customerNotifications({int limit = 50, int skip = 0}) =>
      '/api/v1/customer/notifications?limit=$limit&skip=$skip';
  static const String customerUnreadNotificationsCount = '/api/v1/customer/notifications/unread-count';
  static String markCustomerNotificationRead(int id) => '/api/v1/customer/notifications/$id/read';
  static const String markAllCustomerNotificationsRead = '/api/v1/customer/notifications/read-all';

  // Google Maps & Places API (New)
  static const String googleMapsApiKey = 'AIzaSyDWeoIAJVD66D6Jvon6k_4Q6ixxJirPdW0';
  static const String googlePlacesNewAutocomplete = 'https://places.googleapis.com/v1/places:autocomplete';
  static const String googlePlacesNewDetails = 'https://places.googleapis.com/v1/places';
  static const String nominatimReverse = 'https://nominatim.openstreetmap.org/reverse';
  static const String nominatimSearch = 'https://nominatim.openstreetmap.org/search';
  static const String osrmRoute = 'https://router.project-osrm.org/route/v1/driving';
}
