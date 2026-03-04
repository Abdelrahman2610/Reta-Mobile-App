// // ════════════════════════════════════════════════════════════════════
// // unit_data_state.dart — أضف الـ fields دي
// // ════════════════════════════════════════════════════════════════════
//
// // ── Fields ────────────────────────────────────────────────────────
// //   final int industrialBuildingsCount;
// //   final bool? ministryBurden;
// //   final String? selectedBurdenActivity;
// //   final String? allocationContractFilePath;
// //   final String? allocationContractOriginalName;
//
// // ── Constructor ───────────────────────────────────────────────────
// //   this.industrialBuildingsCount = 1,
// //   this.ministryBurden,
// //   this.selectedBurdenActivity,
// //   this.allocationContractFilePath,
// //   this.allocationContractOriginalName,
//
// // ── copyWith parameters ───────────────────────────────────────────
// //   int? industrialBuildingsCount,
// //   bool? ministryBurden,
// //   String? selectedBurdenActivity,
// //   Object? allocationContractFilePath = _undefined,
// //   Object? allocationContractOriginalName = _undefined,
//
// // ── copyWith return ───────────────────────────────────────────────
// //   industrialBuildingsCount: industrialBuildingsCount ?? this.industrialBuildingsCount,
// //   ministryBurden: ministryBurden ?? this.ministryBurden,
// //   selectedBurdenActivity: selectedBurdenActivity ?? this.selectedBurdenActivity,
// //   allocationContractFilePath: allocationContractFilePath == _undefined
// //       ? this.allocationContractFilePath
// //       : allocationContractFilePath as String?,
// //   allocationContractOriginalName: allocationContractOriginalName == _undefined
// //       ? this.allocationContractOriginalName
// //       : allocationContractOriginalName as String?,
//
// // ════════════════════════════════════════════════════════════════════
// // unit_data_cubit.dart — إضافات
// // ════════════════════════════════════════════════════════════════════
//
// // ── 1. Import ─────────────────────────────────────────────────────
// // import '../../../../data/models/industrial_building.dart';
//
// // ── 2. في Dynamic Lists — أضف بعد buildings ──────────────────────
// // final List<IndustrialBuilding> industrialBuildings = [IndustrialBuilding()];
//
// // ── 3. في initUnitData() switch — عدّل ───────────────────────────
// // case UnitType.industrialFacility:
// //   _initIndustrialData();
// //   break;
//
// // ── 4. أضف _initIndustrialData() ─────────────────────────────────
// void _initIndustrialData() {
//   facilityNameController.text = unitData!['facility_name'] ?? '';
//   activityTypeController.text = unitData!['activity_type'] ?? '';
//   totalLandAreaFacilityController.text =
//       unitData!['total_land_area']?.toString() ?? '';
//   exploitedLandAreaController.text =
//       unitData!['used_land_area']?.toString() ?? '';
//   landMarketValueController.text = unitData!['market_value']?.toString() ?? '';
//   unitCodeController.text = unitData!['account_code'] ?? '';
//
//   // burden_activity_id → display text
//   String? burdenActivityText;
//   final burdenActivityId = unitData!['burden_activity_id'];
//   if (burdenActivityId != null) {
//     final found = lookups.burdenActivityTypes.firstWhere(
//       (b) => b.id == burdenActivityId,
//       orElse: () => DeclarationLookup(id: -1, name: ''),
//     );
//     burdenActivityText = found.id == -1 ? null : found.name;
//   }
//
//   // buildings
//   final buildingsData = unitData!['buildings'] as List? ?? [];
//   if (buildingsData.isNotEmpty) {
//     for (final b in industrialBuildings) b.dispose();
//     industrialBuildings.clear();
//     for (final b in buildingsData) {
//       final building = IndustrialBuilding();
//       building.initFromMap(b as Map<String, dynamic>, lookups.buildingTypes);
//       industrialBuildings.add(building);
//     }
//   }
//
//   // files
//   final constructionLicense = unitData!['construction_license'];
//   final operationLicense = unitData!['operation_license'];
//   final allocationContract = unitData!['allocation_contract'];
//   final ministryBurdenVal = unitData!['ministry_burden'];
//
//   emit(
//     state.copyWith(
//       ministryBurden: ministryBurdenVal == true || ministryBurdenVal == 1,
//       selectedBurdenActivity: burdenActivityText,
//       contactedTaxAuthority: unitData!['reta_contact_about_unit'] == 1,
//       hasAdditionalDocuments:
//           unitData!['submit_other_supporting_documents'] == 1,
//       industrialBuildingsCount: industrialBuildings.length,
//       constructionLicenseFilePath: constructionLicense?['path'],
//       constructionLicenseOriginalName:
//           constructionLicense?['original_file_name'],
//       operatingLicenseFilePath: operationLicense?['path'],
//       operatingLicenseOriginalName: operationLicense?['original_file_name'],
//       allocationContractFilePath: allocationContract?['path'],
//       allocationContractOriginalName: allocationContract?['original_file_name'],
//     ),
//   );
// }
//
// // ── 5. أضف الـ actions ────────────────────────────────────────────
//
// void addIndustrialBuilding() {
//   industrialBuildings.add(IndustrialBuilding());
//   emit(state.copyWith(industrialBuildingsCount: industrialBuildings.length));
// }
//
// void removeIndustrialBuilding(int index) {
//   if (industrialBuildings.length <= 1) return;
//   industrialBuildings[index].dispose();
//   industrialBuildings.removeAt(index);
//   emit(state.copyWith(industrialBuildingsCount: industrialBuildings.length));
// }
//
// // ── 6. في _buildUnitPayload عدّل ─────────────────────────────────
// // case UnitType.industrialFacility:
// //   return buildIndustrialPayload(lookups, industrialBuildings);
//
// // ── 7. في close() أضف ────────────────────────────────────────────
// // for (final b in industrialBuildings) b.dispose();
