import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'declarations_lookups.dart';

class HotelSubUnit {
  final String id;

  final TextEditingController buildingNumber = TextEditingController();
  final TextEditingController unitNumber = TextEditingController();
  final TextEditingController activityType = TextEditingController();
  final TextEditingController area = TextEditingController();
  final TextEditingController accountCode = TextEditingController();
  final TextEditingController marketPrice = TextEditingController();
  final TextEditingController annualRent = TextEditingController();

  String? floorNumber;
  String? insideOperationLicense;
  String? retaContactAboutUnit;

  HotelSubUnit({String? id}) : id = id ?? const Uuid().v4();

  void dispose() {
    buildingNumber.dispose();
    unitNumber.dispose();
    activityType.dispose();
    area.dispose();
    accountCode.dispose();
    marketPrice.dispose();
    annualRent.dispose();
  }

  Map<String, dynamic> toPayload(List<DeclarationLookup> floorLookups) {
    final floorLookup = floorNumber == null
        ? null
        : floorLookups.firstWhere(
            (f) => f.name == floorNumber,
            orElse: () => DeclarationLookup(id: -1, name: ''),
          );

    return {
      'building_number': int.tryParse(buildingNumber.text.trim()),
      'floor_number_id': (floorLookup == null || floorLookup.id == -1)
          ? null
          : floorLookup.id,
      'unit_number': int.tryParse(unitNumber.text.trim()),
      'activity_type': activityType.text.trim(),
      'area': double.tryParse(area.text.trim()),
      'inside_operation_license': insideOperationLicense == 'نعم' ? 1 : 2,
      'reta_contact_about_unit': retaContactAboutUnit == 'نعم' ? 1 : 2,
      'account_code': accountCode.text.trim().isEmpty
          ? null
          : int.tryParse(accountCode.text.trim()),
      'market_price': double.tryParse(marketPrice.text.trim()),
      'annual_rent': double.tryParse(annualRent.text.trim()),
    };
  }

  void initFromMap(
    Map<String, dynamic> data,
    List<DeclarationLookup> floorLookups,
  ) {
    buildingNumber.text = data['building_number']?.toString() ?? '';
    unitNumber.text = data['unit_number']?.toString() ?? '';
    activityType.text = data['activity_type']?.toString() ?? '';
    area.text = data['area']?.toString() ?? '';
    accountCode.text = data['account_code']?.toString() ?? '';
    marketPrice.text = data['market_price']?.toString() ?? '';
    annualRent.text = data['annual_rent']?.toString() ?? '';

    final floorId = data['floor_number_id'];
    if (floorId != null) {
      final found = floorLookups.firstWhere(
        (f) => f.id == floorId,
        orElse: () => DeclarationLookup(id: -1, name: ''),
      );
      floorNumber = found.id == -1 ? null : found.name;
    }

    final insideLicense = data['inside_operation_license'];
    insideOperationLicense = insideLicense == null
        ? null
        : (insideLicense == 1 ? 'نعم' : 'لا');

    final retaContact = data['reta_contact_about_unit'];
    retaContactAboutUnit = retaContact == null
        ? null
        : (retaContact == 1 ? 'نعم' : 'لا');
  }
}
