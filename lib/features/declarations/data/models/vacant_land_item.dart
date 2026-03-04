import 'package:flutter/material.dart';
import 'package:reta/features/declarations/data/models/declarations_lookups.dart';
import 'package:uuid/uuid.dart';

class VacantLandItem {
  final String id;
  final TextEditingController usedLandAreaController;
  final TextEditingController otherExploitationTypeController;
  final TextEditingController accountCodeController;
  final TextEditingController marketValueController;
  String? selectedExploitationType;
  bool retaContactAboutUnit = false;

  VacantLandItem({String? id})
    : id = id ?? const Uuid().v4(),
      usedLandAreaController = TextEditingController(),
      otherExploitationTypeController = TextEditingController(),
      accountCodeController = TextEditingController(),
      marketValueController = TextEditingController();

  void dispose() {
    usedLandAreaController.dispose();
    otherExploitationTypeController.dispose();
    accountCodeController.dispose();
    marketValueController.dispose();
  }

  Map<String, dynamic> toPayload(List<DeclarationLookup> exploitationTypes) {
    final exploitationTypeId = exploitationTypes
        .firstWhere(
          (t) => t.name == selectedExploitationType,
          orElse: () => DeclarationLookup(id: -1, name: ''),
        )
        .id;
    return {
      'used_land_area': usedLandAreaController.text.trim(),
      'exploitation_type_id': exploitationTypeId,
      'exploitation_type_other': selectedExploitationType == 'أخرى'
          ? otherExploitationTypeController.text.trim()
          : null,
      'reta_contact_about_unit': retaContactAboutUnit ? 1 : 2,
      'account_code': accountCodeController.text.trim().isEmpty
          ? null
          : accountCodeController.text.trim(),
      'market_value': marketValueController.text.trim().isEmpty
          ? null
          : marketValueController.text.trim(),
    };
  }
}
