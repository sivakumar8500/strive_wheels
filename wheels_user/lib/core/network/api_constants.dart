class ApiConstants {
  // Base URLs
  static const String baseUrl = 'http://15.252.129.37:8200';
  static const String wsBaseUrl = 'ws://15.252.129.37:8200/api/v1';
  
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
  static const String vehicleTypes = '/api/v1/customer/vehicle-types';
  static const String fareEstimate = '/api/v1/bookings/fare-estimate';

  // Offers Endpoints
  static const String coupons = '/api/v1/customer/coupons';

  // Google Maps & Places API (New)
  static const String googleMapsApiKey = 'AIzaSyDWeoIAJVD66D6Jvon6k_4Q6ixxJirPdW0';
  static const String googlePlacesNewAutocomplete = 'https://places.googleapis.com/v1/places:autocomplete';
  static const String googlePlacesNewDetails = 'https://places.googleapis.com/v1/places';
  static const String nominatimReverse = 'https://nominatim.openstreetmap.org/reverse';
  static const String nominatimSearch = 'https://nominatim.openstreetmap.org/search';
  static const String osrmRoute = 'https://router.project-osrm.org/route/v1/driving';
}
