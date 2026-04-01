class EditPasswordResponse {
  final String? message;
  final Map<String, dynamic>? data;

  const EditPasswordResponse({this.message, this.data});

  factory EditPasswordResponse.fromJson(Map<String, dynamic> json) {
    return EditPasswordResponse(
      message: json['message']?.toString(),
      data: json['data'] as Map<String, dynamic>?,
    );
  }
}
