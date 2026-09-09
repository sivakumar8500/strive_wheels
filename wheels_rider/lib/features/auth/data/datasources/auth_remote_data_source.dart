import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/send_otp_response.dart';
import '../models/verify_otp_response.dart';

abstract class AuthRemoteDataSource {
  Future<SendOtpResponse> sendOtp({required String countryCode, required String phoneNumber});
  Future<VerifyOtpResponse> verifyOtp({required String countryCode, required String phoneNumber, required String code, required String fullName, required String role});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<SendOtpResponse> sendOtp({required String countryCode, required String phoneNumber}) async {
    try {
      String phone = phoneNumber;
      if (!phone.startsWith('+')) {
        phone = '$countryCode$phone';
      }
      final response = await apiClient.post(
        ApiEndpoints.sendOtp,
        data: {
          "phone": phone,
        },
      );

      if (response.statusCode == 200) {
        return SendOtpResponse.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to send OTP',
        );
      }
    } on DioException catch (e) {
      String errorMessage = 'Unknown error occurred while sending OTP';
      final responseData = e.response?.data;
      if (responseData is Map) {
        final message = responseData['message'];
        if (message is String && message.isNotEmpty) {
          errorMessage = message;
        }
      } else {
        if (e.message != null && e.message!.isNotEmpty) {
          errorMessage = e.message!;
        }
      }
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('An unexpected error occurred');
    }
  }

  @override
  Future<VerifyOtpResponse> verifyOtp({required String countryCode, required String phoneNumber, required String code, required String fullName, required String role}) async {
    try {
      String phone = phoneNumber;
      if (!phone.startsWith('+')) {
        phone = '$countryCode$phone';
      }
      final response = await apiClient.post(
        ApiEndpoints.verifyOtp,
        data: {
          "phone": phone,
          "otp": code,
          "full_name": fullName,
          "role": role,
        },
      );

      if (response.statusCode == 200) {
        return VerifyOtpResponse.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to verify OTP',
        );
      }
    } on DioException catch (e) {
      String errorMessage = 'Unknown error occurred while verifying OTP';
      final responseData = e.response?.data;
      if (responseData is Map) {
        final message = responseData['message'];
        if (message is String && message.isNotEmpty) {
          errorMessage = message;
        }
      } else {
        if (e.message != null && e.message!.isNotEmpty) {
          errorMessage = e.message!;
        }
      }
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('An unexpected error occurred');
    }
  }
}
