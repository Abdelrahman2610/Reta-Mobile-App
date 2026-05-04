import 'package:flutter/material.dart';

import 'declarations_lookups.dart';
import 'map_location_result.dart';

class PetroBuilding {
  String id;

  final TextEditingController buildingType = TextEditingController();
  final TextEditingController bookCostBuilding = TextEditingController();
  final TextEditingController totalArea = TextEditingController();
  final TextEditingController buildingDate = TextEditingController();
  final TextEditingController knownBuildingNumber = TextEditingController();

  MapLocationResult? mapLocationResult;
  bool? isNearestProperty;
  bool isServerRecord = false;

  PetroBuilding({String? id})
    : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  void dispose() {
    buildingDate.dispose();
    buildingType.dispose();
    totalArea.dispose();
    bookCostBuilding.dispose();
    knownBuildingNumber.dispose();
  }

  Map<String, dynamic> toPayload(List<DeclarationLookup> buildingTypeLookups) {
    return {
      'id': id,
      ...?mapLocationResult?.toMap(),
      'known_build_num': knownBuildingNumber.text.trim(),
      'is_nearest_property': isNearestProperty == true ? 1 : 0,
      'building_type_text': buildingType.text.trim(),
      'total_area': double.tryParse(totalArea.text.trim()) ?? 0,
      'construction_date': buildingDate.text.trim(),
      'book_value': double.tryParse(bookCostBuilding.text.trim()),
    };
  }

  PetroBuilding copyWith({
    String? id,
    MapLocationResult? mapLocationResult,
    bool? isNearestProperty,
    bool? isServerRecord,
    String? buildingType,
    String? bookCostBuilding,
    String? totalArea,
    String? buildingDate,
    String? knownBuildingNumber,
  }) {
    final newBuilding = PetroBuilding(id: id ?? this.id);
    newBuilding.mapLocationResult = mapLocationResult ?? this.mapLocationResult;
    newBuilding.isNearestProperty = isNearestProperty ?? this.isNearestProperty;
    newBuilding.isServerRecord = isServerRecord ?? this.isServerRecord;
    newBuilding.buildingType.text = buildingType ?? this.buildingType.text;
    newBuilding.bookCostBuilding.text =
        bookCostBuilding ?? this.bookCostBuilding.text;
    newBuilding.totalArea.text = totalArea ?? this.totalArea.text;
    newBuilding.buildingDate.text = buildingDate ?? this.buildingDate.text;
    newBuilding.knownBuildingNumber.text =
        knownBuildingNumber ?? this.knownBuildingNumber.text;
    return newBuilding;
  }

  void initFromMap(
    Map<String, dynamic> data,
    List<DeclarationLookup> buildingTypeLookups,
  ) {
    id = data['id']?.toString() ?? id;
    buildingType.text = data['building_type_text']?.toString() ?? '';
    totalArea.text = data['total_area']?.toString() ?? '';
    buildingDate.text = data['construction_date']?.toString() ?? '';
    bookCostBuilding.text = data['book_value']?.toString() ?? '';
    knownBuildingNumber.text = data['known_build_num']?.toString() ?? '';
    isNearestProperty = data['is_nearest_property'] == 1;
    mapLocationResult = MapLocationResult.fromMap(data);
    isServerRecord = true;
  }
}
