import 'package:dio/dio.dart';
import 'package:reta/core/network/api_constants.dart';
import 'package:reta/core/network/api_result.dart';
import 'package:reta/core/network/dio_client.dart';

class SendPhoneOtpResponse {
  final String requestCode;
  final String mobile;
  final String userId;
  final int waitSeconds;
  final int remainingAttempts;
  final int dailyLimit;
  final String smsOtpExpire;

  const SendPhoneOtpResponse({
    required this.requestCode,
    required this.mobile,
    required this.userId,
    required this.waitSeconds,
    required this.remainingAttempts,
    required this.dailyLimit,
    required this.smsOtpExpire,
  });

  factory SendPhoneOtpResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    return SendPhoneOtpResponse(
      requestCode: data['request_code']?.toString() ?? '',
      mobile: data['mobile']?.toString() ?? '',
      userId: data['user_id']?.toString() ?? '',
      waitSeconds: (data['wait_seconds'] as num?)?.toInt() ?? 60,
      remainingAttempts: (data['remaining_attempts'] as num?)?.toInt() ?? 3,
      dailyLimit: (data['daily_limit'] as num?)?.toInt() ?? 3,
      smsOtpExpire: data['sms_otp_expire']?.toString() ?? '300',
    );
  }

  Duration get otpDuration =>
      Duration(seconds: int.tryParse(smsOtpExpire) ?? 300);
}

class ConfirmPhoneOtpResponse {
  final bool phoneVerified;
  final String? mobile;

  const ConfirmPhoneOtpResponse({required this.phoneVerified, this.mobile});

  factory ConfirmPhoneOtpResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    return ConfirmPhoneOtpResponse(
      phoneVerified: data['phone_verified'] == true,
      mobile: data['mobile']?.toString(),
    );
  }
}

class ProfileVerificationRepository {
  final Dio _dio = DioClient.instance.dio;
  // ── Send phone verification OTP ───────────────────────────────────────────
  Future<ApiResult<SendPhoneOtpResponse>> sendPhoneVerificationOtp() async {
    return safeApiCall(() async {
      final response = await _dio.post(
        ApiConstants.validatePhoneSendOtp,
        data: FormData.fromMap({'context': 'profile_phone_verification'}),
      );
      return SendPhoneOtpResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
    });
  }

  // ── Confirm OTP ───────────────────────────────────────────────────────────
  Future<ApiResult<ConfirmPhoneOtpResponse>> confirmPhoneVerificationOtp({
    required String token,
    required String otp,
    required String mobile,
    required String userId,
  }) async {
    return safeApiCall(() async {
      final response = await _dio.post(
        ApiConstants.validatePhoneConfirmOtp,
        data: FormData.fromMap({
          'token': token,
          'otp': otp,
          'context': 'profile_phone_verification',
          'mobile': mobile,
          'user_id': userId,
        }),
      );
      return ConfirmPhoneOtpResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
    });
  }

  // ── Send email verification link ──────────────────────────────────────────
  Future<ApiResult<String>> sendEmailVerification({
    required String email,
  }) async {
    return safeApiCall(() async {
      final response = await _dio.post(
        ApiConstants.validateEmail,
        data: FormData.fromMap({'email': email}),
      );
      final data = response.data as Map<String, dynamic>;
      return data['message']?.toString() ?? 'تم إرسال رابط التحقق';
    });
  }

  // ── Validate identity (OCR) ───────────────────────────────────────────────
  Future<ApiResult<String>> validateIdentity() async {
    return safeApiCall(() async {
      final response = await _dio.post(ApiConstants.validateIdentity);
      final data = response.data as Map<String, dynamic>;
      return data['message']?.toString() ?? 'تم التحقق';
    });
  }
}
