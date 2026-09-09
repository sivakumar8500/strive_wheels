class ApiEndpoints {
  // Base URL
  static const String baseUrl = 'http://15.252.129.37:8200/api/v1';

  // Auth Endpoints
  static const String sendOtp = '$baseUrl/auth/send-otp';
  
  // WebSocket Endpoints
  static const String wsBaseUrl = 'ws://15.252.129.37:8200/api/v1';
  static const String wsConnect = '$wsBaseUrl/ws/v1/connect';
  static String wsCustomerConnect(int customerId) => '$wsBaseUrl/ws/customer/$customerId';
}
