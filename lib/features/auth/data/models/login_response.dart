class LoginResponse {
  final String? tokenType;
  final int? expiresIn;
  final String? accessToken;
  final String? refreshToken;
  final String? firstName;
  final String? lastName;
  final String? mobile;
  final String? email;
  final bool phoneVerified;
  final bool ocrVerified;
  final bool emailVerified;
  final int? idleTimeoutMinutes;

  const LoginResponse({
    this.tokenType,
    this.expiresIn,
    this.accessToken,
    this.refreshToken,
    this.firstName,
    this.lastName,
    this.mobile,
    this.email,
    this.phoneVerified = false,
    this.ocrVerified = false,
    this.emailVerified = false,
    this.idleTimeoutMinutes,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      tokenType: json['token_type']?.toString(),
      expiresIn: json['expires_in'] as int?,
      accessToken: json['access_token']?.toString(),
      refreshToken: json['refresh_token']?.toString(),
      firstName: json['first_name']?.toString(),
      lastName: json['last_name']?.toString(),
      mobile: json['mobile']?.toString(),
      email: json['email']?.toString(),
      phoneVerified: json['phone_verified'] == true,
      ocrVerified: json['ocr_verified'] == true,
      emailVerified: json['email_verified'] == true,
      idleTimeoutMinutes: json['idle_timeout_minutes'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'token_type': tokenType,
    'expires_in': expiresIn,
    'access_token': accessToken,
    'refresh_token': refreshToken,
    'first_name': firstName,
    'last_name': lastName,
    'mobile': mobile,
    'email': email,
    'phone_verified': phoneVerified,
    'ocr_verified': ocrVerified,
    'email_verified': emailVerified,
    'idle_timeout_minutes': idleTimeoutMinutes,
  };

  String get displayName =>
      [firstName, lastName].where((s) => s != null && s.isNotEmpty).join(' ');

  bool get isFullyVerified => phoneVerified && ocrVerified;
}
