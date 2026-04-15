import 'package:flutter/material.dart';

import 'declarations_lookups.dart';

class PetroBuilding {
  String id;

  final TextEditingController buildingType = TextEditingController();
  final TextEditingController bookCostBuilding = TextEditingController();
  final TextEditingController totalArea = TextEditingController();
  final TextEditingController buildingDate = TextEditingController();

  PetroBuilding({String? id})
    : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  void dispose() {
    buildingDate.dispose();
    buildingType.dispose();
    totalArea.dispose();
    bookCostBuilding.dispose();
  }

  void initFromMap(
    Map<String, dynamic> data,
    List<DeclarationLookup> buildingTypeLookups,
  ) {
    id = data['id']?.toString() ?? '';
    buildingType.text = data['building_type_text']?.toString() ?? '';
    totalArea.text = data['total_area']?.toString() ?? '';
    buildingDate.text = data['construction_date']?.toString() ?? "";
    bookCostBuilding.text = data['book_value']?.toString() ?? "";
  }
}
