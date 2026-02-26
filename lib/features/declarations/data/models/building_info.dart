import 'package:flutter/material.dart';

class BuildingInfo {
  final String id;
  int floorsCount;
  final TextEditingController areaController;
  final TextEditingController marketValueController;

  BuildingInfo({required this.id})
    : floorsCount = 1,
      areaController = TextEditingController(),
      marketValueController = TextEditingController();

  void dispose() {
    areaController.dispose();
    marketValueController.dispose();
  }
}
