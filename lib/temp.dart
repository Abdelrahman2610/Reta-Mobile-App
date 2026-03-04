// // ════════════════════════════════════════════════════════════════════
// // التعديلات المطلوبة على unit_data_state.dart
// // ════════════════════════════════════════════════════════════════════
//
// // ── 1. أضف import ────────────────────────────────────────────────────
// import 'package:reta/features/declarations/data/models/hotel_sub_unit.dart';
//
// // ── 2. في class UnitDataState أضف الـ fields دي بعد `hasSubUnits` ──
// //
// //   final int roomsCount;               // عدد الغرف للمنشأة الفندقية
// //   final List<HotelSubUnit> hotelSubUnits;
// //   final int hotelSubUnitsUpdateCount;
// //
//
// // ── 3. في الـ constructor أضف ─────────────────────────────────────────
// //   this.roomsCount = 1,
// //   this.hotelSubUnits = const [],
// //   this.hotelSubUnitsUpdateCount = 0,
//
// // ── 4. في copyWith — أضف parameters ──────────────────────────────────
// //   int? roomsCount,
// //   List<HotelSubUnit>? hotelSubUnits,
// //   int? hotelSubUnitsUpdateCount,
//
// // ── 5. في الـ return داخل copyWith أضف ───────────────────────────────
// //   roomsCount: roomsCount ?? this.roomsCount,
// //   hotelSubUnits: hotelSubUnits ?? this.hotelSubUnits,
// //   hotelSubUnitsUpdateCount: hotelSubUnitsUpdateCount ?? this.hotelSubUnitsUpdateCount,
//
// // ════════════════════════════════════════════════════════════════════
// // التعديلات المطلوبة على unit_data_cubit.dart
// // ════════════════════════════════════════════════════════════════════
//
// // ── 1. أضف import ────────────────────────────────────────────────────
// import '../../../../data/models/hotel_sub_unit.dart';
//
// // ── 2. أضف controller للـ license_date (موجود بالفعل) ───────────────
// // operatingLicenseDateController — موجود ✓
//
// // ── 3. عدّل _initHotelData() تبقى كده ────────────────────────────────
// void _initHotelData() {
//   facilityNameController.text = unitData!['trade_name'] ?? '';
//   operatingLicenseDateController.text = unitData!['license_date'] ?? '';
//
//   // view_type_id → display text
//   final viewTypeId = unitData!['view_type_id'];
//   final viewText = viewTypeId != null
//       ? lookups.hotelViews
//             .firstWhere(
//               (v) => v.id == viewTypeId,
//               orElse: () => DeclarationLookup(id: -1, name: ''),
//             )
//             .name
//       : null;
//
//   // star_rating_id → display text
//   final starRatingId = unitData!['star_rating_id'];
//   final starText = starRatingId != null
//       ? lookups.starRatings
//             .firstWhere(
//               (s) => s.id == starRatingId,
//               orElse: () => DeclarationLookup(id: -1, name: ''),
//             )
//             .name
//       : null;
//
//   final constructionLicense = unitData!['copy_of_the_construction_permits'];
//   final operatingLicense = unitData!['copy_of_the_operating_licenses'];
//   final starCertificate = unitData!['certificate_of_stardom_level'];
//
//   emit(
//     state.copyWith(
//       selectedHotelView: viewText,
//       selectedStarRating: starText,
//       buildingsCount:
//           int.tryParse(unitData!['buildings_count']?.toString() ?? '') ?? 1,
//       roomsCount: int.tryParse(unitData!['rooms_count']?.toString() ?? '') ?? 1,
//       hasSubUnits: unitData!['has_sub_units'] == 1,
//       constructionLicenseFilePath: constructionLicense?['path'],
//       constructionLicenseOriginalName:
//           constructionLicense?['original_file_name'],
//       operatingLicenseFilePath: operatingLicense?['path'],
//       operatingLicenseOriginalName: operatingLicense?['original_file_name'],
//       starCertificateFilePath: starCertificate?['path'],
//       starCertificateOriginalName: starCertificate?['original_file_name'],
//       contactedTaxAuthority: unitData!['reta_contact_about_unit'] == 1,
//       hasAdditionalDocuments:
//           unitData!['submit_other_supporting_documents'] == 1,
//     ),
//   );
//
//   // ── init hotel sub-units ──────────────────────────────────────────
//   final subUnitsData = unitData!['hotelUnits'] as List? ?? [];
//   if (subUnitsData.isNotEmpty) {
//     final subUnits = subUnitsData.map((u) {
//       final unit = HotelSubUnit();
//       unit.initFromMap(u as Map<String, dynamic>, lookups.realEstateFloors);
//       return unit;
//     }).toList();
//     emit(
//       state.copyWith(
//         hotelSubUnits: subUnits,
//         hotelSubUnitsUpdateCount: state.hotelSubUnitsUpdateCount + 1,
//       ),
//     );
//   }
// }
//
// // ── 4. عدّل buildHotelPayload() تبقى كده ─────────────────────────────
// Map<String, dynamic> buildHotelPayload(DeclarationLookupsModel lookups) {
//   // view_type_id من display text
//   final viewTypeId = lookups.hotelViews
//       .firstWhere(
//         (v) => v.name == state.selectedHotelView,
//         orElse: () => DeclarationLookup(id: -1, name: ''),
//       )
//       .id;
//
//   // star_rating_id من display text
//   final starRatingId = lookups.starRatings
//       .firstWhere(
//         (s) => s.name == state.selectedStarRating,
//         orElse: () => DeclarationLookup(id: -1, name: ''),
//       )
//       .id;
//
//   return {
//     ..._buildBaseUnitPayload(),
//     'trade_name': facilityNameController.text.trim(),
//     'view_type_id': viewTypeId,
//     'license_date': operatingLicenseDateController.text.trim(),
//     'buildings_count': state.buildingsCount,
//     'rooms_count': state.roomsCount,
//     'star_rating_id': starRatingId,
//     'has_sub_units': state.hasSubUnits == true ? 1 : 2,
//     'hotelUnits': state.hotelSubUnits
//         .map((u) => u.toPayload(lookups.realEstateFloors))
//         .toList(),
//     if (state.constructionLicenseFilePath != null)
//       'copy_of_the_construction_permits': {
//         'path': state.constructionLicenseFilePath,
//         'original_file_name': state.constructionLicenseOriginalName,
//       },
//     if (state.operatingLicenseFilePath != null)
//       'copy_of_the_operating_licenses': {
//         'path': state.operatingLicenseFilePath,
//         'original_file_name': state.operatingLicenseOriginalName,
//       },
//     if (state.starCertificateFilePath != null)
//       'certificate_of_stardom_level': {
//         'path': state.starCertificateFilePath,
//         'original_file_name': state.starCertificateOriginalName,
//       },
//     ..._buildSupportingDocsPayload(),
//   };
// }
//
// // ── 5. أضف الـ actions الجديدة بعد setHasSubUnits() ──────────────────
//
// void addHotelSubUnit() {
//   final updated = [...state.hotelSubUnits, HotelSubUnit()];
//   emit(
//     state.copyWith(
//       hotelSubUnits: updated,
//       hotelSubUnitsUpdateCount: state.hotelSubUnitsUpdateCount + 1,
//     ),
//   );
// }
//
// void removeHotelSubUnit(String id) {
//   final unit = state.hotelSubUnits.firstWhere((u) => u.id == id);
//   unit.dispose();
//   final updated = state.hotelSubUnits.where((u) => u.id != id).toList();
//   // لو الليست فضت — ارجع hasSubUnits لـ false
//   emit(
//     state.copyWith(
//       hotelSubUnits: updated,
//       hasSubUnits: updated.isEmpty ? false : state.hasSubUnits,
//       hotelSubUnitsUpdateCount: state.hotelSubUnitsUpdateCount + 1,
//     ),
//   );
// }
//
// void triggerHotelSubUnitRebuild() {
//   emit(
//     state.copyWith(
//       hotelSubUnitsUpdateCount: state.hotelSubUnitsUpdateCount + 1,
//     ),
//   );
// }
//
// // ── 6. في close() — أضف قبل return super.close() ─────────────────────
// // for (final unit in state.hotelSubUnits) unit.dispose();
//
// // ════════════════════════════════════════════════════════════════════
// // ملاحظة مهمة على الـ lookups
// // ════════════════════════════════════════════════════════════════════
// // لو lookups.hotelViews و lookups.starRatings مش موجودين في
// // DeclarationLookupsModel — محتاج تضيفهم هناك،
// // أو استخدم الـ hardcoded lists الموجودة في الـ cubit:
// //   cubit.hotelViews   → ['مطل على النيل', 'مطل على البحر', 'غير مطل']
// //   cubit.starRatings  → ['نجمة واحدة', ...]
// // وتحتفظ بالـ ID كـ Map في الـ cubit نفسه لو مفيش lookup.
