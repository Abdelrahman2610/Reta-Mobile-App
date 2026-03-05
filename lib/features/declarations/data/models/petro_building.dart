import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'declarations_lookups.dart';

class PetroBuilding {
  final String id;

  final TextEditingController buildingType = TextEditingController();
  final TextEditingController bookCostBuilding = TextEditingController();
  final TextEditingController totalArea = TextEditingController();
  final TextEditingController buildingDate = TextEditingController();

  PetroBuilding({String? id}) : id = id ?? const Uuid().v4();

  void dispose() {
    buildingDate.dispose();
    buildingType.dispose();
    totalArea.dispose();
    bookCostBuilding.dispose();
  }

  Map<String, dynamic> toPayload(List<DeclarationLookup> buildingTypeLookups) {
    return {'total_area': double.tryParse(totalArea.text.trim())};
  }

  void initFromMap(
    Map<String, dynamic> data,
    List<DeclarationLookup> buildingTypeLookups,
  ) {
    totalArea.text = data['total_area']?.toString() ?? '';
  }
}
