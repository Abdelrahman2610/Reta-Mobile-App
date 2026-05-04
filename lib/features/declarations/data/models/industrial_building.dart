import 'package:flutter/material.dart';

import 'declarations_lookups.dart';
import 'map_location_result.dart';

class IndustrialBuilding {
  String id;

  final TextEditingController totalArea = TextEditingController();
  final TextEditingController constructionDate = TextEditingController();
  final TextEditingController marketValue = TextEditingController();
  final TextEditingController knownBuildingNumber = TextEditingController();

  String? buildingType;
  int floorsCount = 1;
  MapLocationResult? mapLocationResult;
  bool? isNearestProperty;
  bool isServerRecord = false;

  IndustrialBuilding({String? id})
    : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  void dispose() {
    totalArea.dispose();
    constructionDate.dispose();
    marketValue.dispose();
    knownBuildingNumber.dispose();
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
      'id': id.toString(),
      ...?mapLocationResult?.toMap(),
      'known_build_num': knownBuildingNumber.text.trim(),
      'is_nearest_property': isNearestProperty == true ? 1 : 0,
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
    id = data['id'].toString();
    totalArea.text = data['total_area']?.toString() ?? '';
    constructionDate.text = data['construction_date']?.toString() ?? '';
    marketValue.text = data['market_value']?.toString() ?? '';
    floorsCount = data['floors_count'] ?? 1;
    knownBuildingNumber.text = data['known_build_num']?.toString() ?? '';
    isNearestProperty = data['is_nearest_property'] == 1;
    mapLocationResult = MapLocationResult.fromMap(data);

    isServerRecord = true;

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
