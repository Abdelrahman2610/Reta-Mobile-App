class NotificationModel {
  final String id;
  final String type;
  final String titleAr;
  final String titleEn;
  final String messageAr;
  final String messageEn;
  final bool isRead;
  final String? readAt;

  const NotificationModel({
    required this.id,
    required this.type,
    required this.titleAr,
    required this.titleEn,
    required this.messageAr,
    required this.messageEn,
    required this.isRead,
    this.readAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'].toString(),
      type: json['type']?.toString() ?? '',
      titleAr: json['title_ar']?.toString() ?? '',
      titleEn: json['title_en']?.toString() ?? '',
      messageAr: json['message_ar']?.toString() ?? '',
      messageEn: json['message_en']?.toString() ?? '',
      isRead: json['is_read'] == true,
      readAt: json['read_at']?.toString(),
    );
  }

  NotificationModel copyWith({bool? isRead, String? readAt}) {
    return NotificationModel(
      id: id,
      type: type,
      titleAr: titleAr,
      titleEn: titleEn,
      messageAr: messageAr,
      messageEn: messageEn,
      isRead: isRead ?? this.isRead,
      readAt: readAt ?? this.readAt,
    );
  }
}
