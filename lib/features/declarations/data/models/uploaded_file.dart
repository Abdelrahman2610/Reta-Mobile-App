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
  Map<String, String> toAttachmentMap() => {
    'path': path,
    'original_file_name': originalName,
  };
}
