class ApiEndpoints {
  // Base Server Host & API Base URL
  static const String serverHost = 'http://15.252.129.37:8200';
  static const String baseUrl = '$serverHost/api/v1';

  /// Returns full image URL by prepending serverHost if the path is relative.
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
        cleanPath.contains(RegExp(r'^[a-zA-Z]:\\'))) {
      return cleanPath;
    }
    if (!cleanPath.startsWith('/')) {
      return '$serverHost/$cleanPath';
    }
    return '$serverHost$cleanPath';
  }

  // Auth Endpoints
  static const String sendOtp = '$baseUrl/auth/send-otp';
  static const String verifyOtp = '$baseUrl/auth/verify-otp';

  // File Upload
  static const String fileUpload = '$baseUrl/files/upload';

  // WebSocket
  // Note: For staging/prod, change to wss:// if applicable.
  static const String wsConnect = 'ws://15.252.129.37:8200/ws/v1/connect';
  static String wsDriverConnect(int driverId) => 'ws://15.252.129.37:8200/ws/driver/$driverId';

  // Rider Trip Endpoints
  static const String riderAvailability = '$baseUrl/rider/availability';
  static const String riderAvailabilitySchedule = '$baseUrl/rider/availability-schedule';
  static const String riderLocation = '$baseUrl/rider/location';
  static const String riderProfile = '$baseUrl/rider/profile';
  static String acceptBooking(int id) => '$baseUrl/rider/booking-requests/$id/accept';
  static String markArrived(int id) => '$baseUrl/rider/bookings/$id/arrived';
  static String startTrip(int id) => '$baseUrl/rider/bookings/$id/start';
  static String completeTrip(int id) => '$baseUrl/rider/bookings/$id/complete';
  static String riderEarnings({int limit = 50, int offset = 0}) => '$baseUrl/rider/earnings?limit=$limit&offset=$offset';
  static String riderBookings({int limit = 50, int offset = 0}) => '$baseUrl/rider/bookings?limit=$limit&offset=$offset';


  // Rider Registration Flow Endpoints
  static const String registrationDraft = '$baseUrl/driver-registration';
  static const String registrationInstant = '$baseUrl/driver-registration/instant';
  static const String registrationPersonal = '$baseUrl/driver-registration/personal';
  static const String registrationAddress = '$baseUrl/driver-registration/address';
  static const String registrationKyc = '$baseUrl/driver-registration/kyc/unified';
  static const String registrationVehicle = '$baseUrl/driver-registration/vehicle';
  static const String registrationBankDetails = '$baseUrl/driver-registration/bank-details';
  static const String registrationEmergencyContact = '$baseUrl/driver-registration/emergency-contact';
  static const String registrationSubmit = '$baseUrl/driver-registration/submit';
  static const String registrationVehicleDocs = '$baseUrl/driver-registration/vehicle-documents';
  static const String registrationVehicleTypes = '$baseUrl/driver-registration/vehicle-types';

  // Customer / Common Endpoints
  static const String quickServices = '$baseUrl/driver-registration/vehicle-types';
}
