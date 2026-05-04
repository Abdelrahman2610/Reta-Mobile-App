import 'package:flutter/material.dart';

import 'hotel_sub_unit.dart';
import 'map_location_result.dart';

class HotelBuildingInfo {
  final String id;
  int floorsCount;
  int roomsCount;
  final TextEditingController knownBuildingNumber;
  MapLocationResult? mapLocationResult;
  bool? isNearestProperty;
  bool isServerRecord = false;
  final List<HotelSubUnit> hotelUnits = [];

  HotelBuildingInfo({
    required this.id,
    this.mapLocationResult,
    this.isNearestProperty,
  }) : floorsCount = 1,
       roomsCount = 1,
       knownBuildingNumber = TextEditingController();

  HotelBuildingInfo._({
    required this.id,
    required this.floorsCount,
    required this.roomsCount,
    required this.knownBuildingNumber,
    this.mapLocationResult,
    this.isNearestProperty,
  });

  HotelBuildingInfo copyWith({
    String? id,
    int? floorsCount,
    int? roomsCount,
    String? knownBuildingNum,
    MapLocationResult? mapLocationResult,
    bool? isNearestProperty,
  }) {
    return HotelBuildingInfo._(
      id: id ?? this.id,
      floorsCount: floorsCount ?? this.floorsCount,
      roomsCount: roomsCount ?? this.roomsCount,
      knownBuildingNumber: TextEditingController(
        text: knownBuildingNum ?? knownBuildingNumber.text,
      ),
      mapLocationResult: mapLocationResult ?? this.mapLocationResult,
      isNearestProperty: isNearestProperty ?? this.isNearestProperty,
    );
  }

  void addSubUnit() {
    hotelUnits.add(HotelSubUnit());
  }

  void removeSubUnit(String unitId) {
    final unit = hotelUnits.firstWhere((u) => u.id == unitId);
    unit.dispose();
    hotelUnits.removeWhere((u) => u.id == unitId);
  }

  void dispose() {
    knownBuildingNumber.dispose();
    for (final unit in hotelUnits) {
      unit.dispose();
    }
  }
}
