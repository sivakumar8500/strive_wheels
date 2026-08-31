class ApiConstants {
  // Base URLs
  static const String baseUrl = 'http://15.252.129.37:8200';
  
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

  // Offers Endpoints
  static const String coupons = '/api/v1/customer/coupons';
}
