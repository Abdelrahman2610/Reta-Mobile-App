class EditProfileResponse {
  final String message;
  final OtpResponseData? otpResponse;
  final bool sendNewMailVerification;
  final String? sendNewEmailVerificationError;
  final OcrVerifiedData? ocrVerified;

  const EditProfileResponse({
    required this.message,
    this.otpResponse,
    this.sendNewMailVerification = false,
    this.sendNewEmailVerificationError,
    this.ocrVerified,
  });

  factory EditProfileResponse.fromJson(Map<String, dynamic> json) {
    final otpRaw = json['otp_response'];
    final ocrRaw = json['ocr_verified'];

    return EditProfileResponse(
      message: json['message']?.toString() ?? '',
      otpResponse: otpRaw is Map<String, dynamic>
          ? OtpResponseData.fromJson(otpRaw)
          : null,
      sendNewMailVerification: json['send_new_mail_verification'] == true,
      sendNewEmailVerificationError: json['send_new_email_verification_error']
          ?.toString(),
      ocrVerified: ocrRaw is Map<String, dynamic>
          ? OcrVerifiedData.fromJson(ocrRaw)
          : null,
    );
  }
}

class OtpResponseData {
  final bool ok;
  final int responseCode;
  final String? message;
  final String? requestCode;
  final int? waitSeconds;
  final int? remainingAttempts;
  final String? mobile;
  final String? context;
  final int? userId;
  final String? smsOtpExpire;

  const OtpResponseData({
    required this.ok,
    required this.responseCode,
    this.message,
    this.requestCode,
    this.waitSeconds,
    this.remainingAttempts,
    this.mobile,
    this.context,
    this.userId,
    this.smsOtpExpire,
  });

  factory OtpResponseData.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    return OtpResponseData(
      ok: json['ok'] == true,
      responseCode: json['responseCode'] as int? ?? 0,
      message: json['message']?.toString(),
      requestCode: data['request_code']?.toString(),
      waitSeconds: data['wait_seconds'] as int?,
      remainingAttempts: data['remaining_attempts'] as int?,
      mobile: data['mobile']?.toString(),
      context: data['context']?.toString(),
      userId: data['user_id'] as int?,
      smsOtpExpire: data['sms_otp_expire']?.toString(),
    );
  }
}

class OcrVerifiedData {
  final bool ok;
  final int status;
  final String? message;
  final bool connectionError;

  const OcrVerifiedData({
    required this.ok,
    required this.status,
    this.message,
    this.connectionError = false,
  });

  factory OcrVerifiedData.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    return OcrVerifiedData(
      ok: json['ok'] == true,
      status: json['status'] as int? ?? 0,
      message: json['message']?.toString(),
      connectionError: data?['connection_error'] == true,
    );
  }
}
