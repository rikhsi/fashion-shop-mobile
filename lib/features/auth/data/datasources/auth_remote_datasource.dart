import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/auth_model.dart';
import '../models/otp_model.dart';

abstract class AuthRemoteDatasource {
  Future<OtpModel> sendOtp({required String phoneNumber});
  Future<AuthModel> verifyOtp({
    required String phoneNumber,
    required String otp,
    required String verificationId,
  });
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final ApiClient apiClient;

  AuthRemoteDatasourceImpl({required this.apiClient});

  @override
  Future<OtpModel> sendOtp({required String phoneNumber}) async {
    try {
      final response = await apiClient.post(
        '/auth/send-otp',
        data: {'phone_number': phoneNumber},
      );
      return OtpModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw const ServerException(message: 'Failed to send OTP');
    }
  }

  @override
  Future<AuthModel> verifyOtp({
    required String phoneNumber,
    required String otp,
    required String verificationId,
  }) async {
    try {
      final response = await apiClient.post(
        '/auth/verify-otp',
        data: {
          'phone_number': phoneNumber,
          'otp': otp,
          'verification_id': verificationId,
        },
      );
      return AuthModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw const ServerException(message: 'Failed to verify OTP');
    }
  }
}
