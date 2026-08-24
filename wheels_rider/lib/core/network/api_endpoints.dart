class ApiEndpoints {
  // Base URL
  static const String baseUrl = 'http://15.252.129.37:8200/api/v1';

  // Auth Endpoints
  static const String sendOtp = '$baseUrl/auth/send-otp';
  static const String verifyOtp = '$baseUrl/auth/verify-otp';

  // File Upload
  static const String fileUpload = '$baseUrl/files/upload';

  // WebSocket
  // Note: For staging/prod, change to wss:// if applicable.
  static const String wsConnect = 'ws://15.252.129.37:8200/ws/v1/connect';

  // Rider Trip Endpoints
  static const String riderAvailability = '$baseUrl/rider/availability';
  static const String riderLocation = '$baseUrl/rider/location';
  static String acceptBooking(int id) => '$baseUrl/rider/booking-requests/$id/accept';
  static String markArrived(int id) => '$baseUrl/rider/bookings/$id/arrived';
  static String startTrip(int id) => '$baseUrl/rider/bookings/$id/start';
  static String completeTrip(int id) => '$baseUrl/rider/bookings/$id/complete';

  // Rider Registration Flow Endpoints
  static const String registrationPersonal = '$baseUrl/driver-registration/personal';
  static const String registrationAddress = '$baseUrl/driver-registration/address';
  static const String registrationKyc = '$baseUrl/driver-registration/kyc';
  static const String registrationVehicle = '$baseUrl/driver-registration/vehicle';
  static const String registrationVehicleDocs = '$baseUrl/driver-registration/vehicle-documents';
  static const String registrationBankDetails = '$baseUrl/driver-registration/bank-details';
  static const String registrationEmergencyContact = '$baseUrl/driver-registration/emergency-contact';
  static const String registrationSubmit = '$baseUrl/driver-registration/submit';
}
