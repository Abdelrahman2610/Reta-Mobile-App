/// Returned by the file upload endpoint.
/// Use [toAttachmentMap()] when embedding in a declaration body.
class UploadedFile {
  final String path;
  final String name;
  final String originalName;

  const UploadedFile({
    required this.path,
    required this.name,
    required this.originalName,
  });

  factory UploadedFile.fromJson(Map<String, dynamic> json) {
    return UploadedFile(
      path: json['path']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      originalName: json['original_name']?.toString() ?? '',
    );
  }

  /// Converts to the format expected by all declaration endpoints.
  /// Example usage: `"national_id_attachment": uploadedFile.toAttachmentMap()`
  Map<String, String> toAttachmentMap() => {
        'path': path,
        'original_file_name': originalName,
      };
}
