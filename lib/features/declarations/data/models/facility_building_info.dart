import 'package:flutter/material.dart';

import 'map_location_result.dart';

class ServiceFacilityBuildingInfo {
  final String id;
  int floorsCount;
  final TextEditingController areaController;
  final TextEditingController knownBuildingNumber;
  MapLocationResult? mapLocationResult;
  bool? isNearestProperty;

  ServiceFacilityBuildingInfo({
    required this.id,
    this.mapLocationResult,
    this.isNearestProperty,
  }) : floorsCount = 1,
       areaController = TextEditingController(),
       knownBuildingNumber = TextEditingController();

  ServiceFacilityBuildingInfo._({
    required this.id,
    required this.floorsCount,
    required this.areaController,
    required this.knownBuildingNumber,
    this.mapLocationResult,
    this.isNearestProperty,
  });

  ServiceFacilityBuildingInfo copyWith({
    String? id,
    int? floorsCount,
    String? area,
    String? knownBuildingNum,
    MapLocationResult? mapLocationResult,
    bool? isNearestProperty,
  }) {
    return ServiceFacilityBuildingInfo._(
      id: id ?? this.id,
      floorsCount: floorsCount ?? this.floorsCount,
      areaController: TextEditingController(text: area ?? areaController.text),
      knownBuildingNumber: TextEditingController(
        text: knownBuildingNum ?? knownBuildingNumber.text,
      ),
      mapLocationResult: mapLocationResult ?? this.mapLocationResult,
      isNearestProperty: isNearestProperty ?? this.isNearestProperty,
    );
  }

  void dispose() {
    areaController.dispose();
    knownBuildingNumber.dispose();
  }
}
