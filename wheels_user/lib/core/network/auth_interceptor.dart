import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_constants.dart';

class AuthInterceptor extends Interceptor {
  final SharedPreferences _sharedPreferences;
  
  AuthInterceptor(this._sharedPreferences);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add Content-Type header if not present
    options.headers[ApiConstants.contentTypeKey] ??= ApiConstants.applicationJson;

    // Fetch the access token from SharedPreferences
    final accessToken = _sharedPreferences.getString('access_token');
    
    // If token exists, add it to the Authorization header
    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers[ApiConstants.authorizationKey] = 'Bearer $accessToken';
    }

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Check if the error is due to an unauthorized request (e.g., token expired)
    if (err.response?.statusCode == 401) {
      // TODO: Handle token refresh logic here
      // For now, we just pass the error along
    }

    super.onError(err, handler);
  }
}
