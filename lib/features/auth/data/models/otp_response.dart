class RegisterOtpResponse {
  final String? userId;
  final String? token;
  final String? message;
  final String? mobile;
  final int? waitSeconds;
  final int? remainingAttempts;

  const RegisterOtpResponse({
    this.userId,
    this.token,
    this.message,
    this.mobile,
    this.waitSeconds,
    this.remainingAttempts,
  });

  factory RegisterOtpResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};

    return RegisterOtpResponse(
      // server sends "request_code" not "token"
      token: data['request_code']?.toString(),
      // server sends "user_id" as int inside data
      userId: data['user_id']?.toString(),
      message: json['message']?.toString(),
      mobile: data['mobile']?.toString(),
      waitSeconds: data['wait_seconds'] as int?,
      remainingAttempts: data['remaining_attempts'] as int?,
    );
  }
}

class ConfirmOtpResponse {
  final bool success;
  final String? message;
  final bool? phoneVerified;
  final Map<String, dynamic>? userData;

  const ConfirmOtpResponse({
    required this.success,
    this.message,
    this.phoneVerified,
    this.userData,
  });

  factory ConfirmOtpResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    return ConfirmOtpResponse(
      success: json['ok'] == true,
      message: json['message']?.toString(),
      phoneVerified: data['phone_verified'] as bool?,
      userData: data['user'] as Map<String, dynamic>?,
    );
  }
}

class ConfirmOtpRequest {
  final String userId;
  final String mobile;
  final String token;
  final String otp;
  final String context;

  const ConfirmOtpRequest({
    required this.userId,
    required this.mobile,
    required this.token,
    required this.otp,
    this.context = 'register',
  });

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'mobile': mobile,
    'token': token,
    'otp': otp,
    'context': context,
  };
}
