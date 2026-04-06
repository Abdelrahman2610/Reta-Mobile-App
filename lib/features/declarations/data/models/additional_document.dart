import 'package:flutter/material.dart';

class AdditionalDocument {
  final String id;
  final TextEditingController nameController;
  String? filePath;
  String? originalFileName;
  String? fullUrl;

  AdditionalDocument({required this.id})
    : nameController = TextEditingController();

  void dispose() {
    nameController.dispose();
  }

  factory AdditionalDocument.fromJson(Map<String, dynamic> json) {
    final doc = AdditionalDocument(id: json['id'].toString());
    doc.nameController.text = json['name'] as String? ?? '';
    doc.filePath = json['url'] as String?;
    doc.originalFileName = json['original_file_name'] as String?;
    doc.fullUrl = json['full_url'] as String?;
    return doc;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': nameController.text,
    'url': filePath,
    'original_file_name': originalFileName,
    'full_url': fullUrl,
  };
}
