import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'declarations_lookups.dart';

class ProductionBuilding {
  final String id;
  int floorsCount;
  final TextEditingController marketValue = TextEditingController();
  final TextEditingController totalArea = TextEditingController();

  ProductionBuilding({String? id})
    : id = id ?? const Uuid().v4(),
      floorsCount = 1;

  void dispose() {
    marketValue.dispose();
    totalArea.dispose();
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
