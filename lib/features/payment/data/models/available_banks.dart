class AvailableBanks {
  final int index;
  final String? imagePath;
  final String title;

  const AvailableBanks({
    required this.index,
    this.imagePath,
    required this.title,
  });

  factory AvailableBanks.fromJson(Map<String, dynamic> json) {
    return AvailableBanks(
      index: json['index'] as int,
      imagePath: json['image_path'] as String?,
      title: json['title'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'index': index, 'image_path': imagePath, 'title': title};
  }

  AvailableBanks copyWith({int? index, String? imagePath, String? title}) {
    return AvailableBanks(
      index: index ?? this.index,
      imagePath: imagePath ?? this.imagePath,
      title: title ?? this.title,
    );
  }
}
