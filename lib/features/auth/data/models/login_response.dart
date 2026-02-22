class LoginResponse {
  final String? accessToken;
  final String? tokenType;
  final Map<String, dynamic>? user;

  const LoginResponse({
    this.accessToken,
    this.tokenType,
    this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['access_token']?.toString(),
      tokenType: json['token_type']?.toString(),
      user: json['user'] as Map<String, dynamic>?,
    );
  }
}
