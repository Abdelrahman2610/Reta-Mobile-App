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
}
