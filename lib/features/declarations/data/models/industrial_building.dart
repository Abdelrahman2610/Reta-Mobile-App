import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'declarations_lookups.dart';

class IndustrialBuilding {
  final String id;

  final TextEditingController totalArea = TextEditingController();
  final TextEditingController constructionDate = TextEditingController();
  final TextEditingController marketValue = TextEditingController();

  String? buildingType;
  int floorsCount = 1;

  IndustrialBuilding({String? id}) : id = id ?? const Uuid().v4();

  void dispose() {
    totalArea.dispose();
    constructionDate.dispose();
    marketValue.dispose();
  }

  Map<String, dynamic> toPayload(List<DeclarationLookup> buildingTypeLookups) {
    final typeId = buildingType == null
        ? null
        : buildingTypeLookups
              .firstWhere(
                (t) => t.name == buildingType,
                orElse: () => DeclarationLookup(id: -1, name: ''),
              )
              .id;

    return {
      'building_type_id': (typeId == null || typeId == -1) ? null : typeId,
      'floors_count': floorsCount,
      'total_area': double.tryParse(totalArea.text.trim()),
      'construction_date': constructionDate.text.trim(),
      'market_value': marketValue.text.trim().isEmpty
          ? null
          : double.tryParse(marketValue.text.trim()),
    };
  }

  void initFromMap(
    Map<String, dynamic> data,
    List<DeclarationLookup> buildingTypeLookups,
  ) {
    totalArea.text = data['total_area']?.toString() ?? '';
    constructionDate.text = data['construction_date']?.toString() ?? '';
    marketValue.text = data['market_value']?.toString() ?? '';
    floorsCount = data['floors_count'] ?? 1;

    final typeId = data['building_type_id'];
    if (typeId != null) {
      final found = buildingTypeLookups.firstWhere(
        (t) => t.id == typeId,
        orElse: () => DeclarationLookup(id: -1, name: ''),
      );
      buildingType = found.id == -1 ? null : found.name;
    }
  }
}
