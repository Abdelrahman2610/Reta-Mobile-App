import 'package:flutter/material.dart';

import 'declarations_lookups.dart';
import 'map_location_result.dart';

class ProductionBuilding {
  String id;
  int floorsCount;
  final TextEditingController marketValue = TextEditingController();
  final TextEditingController totalArea = TextEditingController();
  final TextEditingController knownBuildingNumber = TextEditingController();

  MapLocationResult? mapLocationResult;
  bool? isNearestProperty;
  bool isServerRecord = false;

  ProductionBuilding({String? id})
    : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      floorsCount = 1;

  void dispose() {
    marketValue.dispose();
    totalArea.dispose();
    knownBuildingNumber.dispose();
  }

  Map<String, dynamic> toPayload(List<DeclarationLookup> buildingTypeLookups) {
    return {
      'id': id,
      ...?mapLocationResult?.toMap(),
      'known_build_num': knownBuildingNumber.text.trim(),
      'is_nearest_property': isNearestProperty == true ? 1 : 0,
      'floors_count': floorsCount,
      'total_area': double.tryParse(totalArea.text.trim()) ?? 0,
      'market_value': double.tryParse(marketValue.text.trim()),
    };
  }

  ProductionBuilding copyWith({
    String? id,
    int? floorsCount,
    MapLocationResult? mapLocationResult,
    bool? isNearestProperty,
    bool? isServerRecord,
    String? marketValue,
    String? totalArea,
    String? knownBuildingNumber,
  }) {
    final newBuilding = ProductionBuilding(id: id ?? this.id);
    newBuilding.floorsCount = floorsCount ?? this.floorsCount;
    newBuilding.mapLocationResult = mapLocationResult ?? this.mapLocationResult;
    newBuilding.isNearestProperty = isNearestProperty ?? this.isNearestProperty;
    newBuilding.isServerRecord = isServerRecord ?? this.isServerRecord;
    newBuilding.marketValue.text = marketValue ?? this.marketValue.text;
    newBuilding.totalArea.text = totalArea ?? this.totalArea.text;
    newBuilding.knownBuildingNumber.text =
        knownBuildingNumber ?? this.knownBuildingNumber.text;
    return newBuilding;
  }

  void initFromMap(
    Map<String, dynamic> data,
    List<DeclarationLookup> buildingTypeLookups,
  ) {
    id = data['id']?.toString() ?? id;
    totalArea.text = data['total_area']?.toString() ?? '';
    marketValue.text = data['market_value']?.toString() ?? '';
    floorsCount = data['floors_count'] ?? 1;
    knownBuildingNumber.text = data['known_build_num']?.toString() ?? '';
    isNearestProperty = data['is_nearest_property'] == 1;

    mapLocationResult = MapLocationResult.fromMap(data);

    isServerRecord = true;
  }
}
