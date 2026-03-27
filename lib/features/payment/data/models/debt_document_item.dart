import 'package:flutter/material.dart';

import 'debt_unit_item.dart';

class DebtDocumentItem {
  final String id;
  final TextEditingController nameController;
  String? filePath;
  String? originalFileName;
  String? fullUrl;
  String? path;
  bool isExisting;
  bool isUploading = false;

  DebtDocumentItem({
    required this.id,
    String? existingName,
    this.filePath,
    this.originalFileName,
    this.fullUrl,
    this.path,
    this.isExisting = false,
  }) : nameController = TextEditingController(text: existingName ?? '');

  bool get hasFile => path != null || filePath != null;
  bool get isValid => nameController.text.trim().isNotEmpty && hasFile;

  void dispose() => nameController.dispose();

  factory DebtDocumentItem.fromExisting(DebtSupportingDocument doc) {
    return DebtDocumentItem(
      id: doc.id.toString(),
      existingName: doc.name,
      filePath: doc.fullUrl,
      originalFileName: doc.originalFileName,
      fullUrl: doc.fullUrl,
      path: doc.path,
      isExisting: true,
    );
  }
}
