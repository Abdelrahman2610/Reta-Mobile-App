class RegisterOtpResponse {
  final String? userId;
  final String? token;
  final String? message;
  final String? mobile;

  const RegisterOtpResponse({
    this.userId,
    this.token,
    this.message,
    this.mobile,
  });

  factory RegisterOtpResponse.fromJson(Map<String, dynamic> json) {
    return RegisterOtpResponse(
      userId: json['user_id']?.toString(),
      token: json['token']?.toString(),
      message: json['message']?.toString(),
      mobile: json['mobile']?.toString(),
    );
  }
}

class ConfirmOtpResponse {
  final bool success;
  final String? message;

  const ConfirmOtpResponse({required this.success, this.message});

  factory ConfirmOtpResponse.fromJson(Map<String, dynamic> json) {
    return ConfirmOtpResponse(
      success: true,
      message: json['message']?.toString(),
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
