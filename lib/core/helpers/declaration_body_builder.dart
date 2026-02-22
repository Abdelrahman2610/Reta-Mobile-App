/// Helper class for building the declaration POST/PUT body.
///
/// This isolates the JSON construction logic from your cubits.
/// Every method returns a [Map<String, dynamic>] ready to pass
/// to [DeclarationsRepository.createDeclaration] or [updateDeclaration].
///
/// Usage example:
/// ```dart
/// final body = DeclarationBodyBuilder.buildTaxpayerSection(
///   typeId: 1,
///   firstName: 'أحمد',
///   lastName: 'محمد',
///   nationalityId: 1,
///   nationalId: '29012011234567',
///   phone: '01012345678',
///   email: 'ahmed@example.com',
///   nationalIdAttachment: uploadedNationalId.toAttachmentMap(),
/// );
/// ```
class DeclarationBodyBuilder {

  // ── Taxpayer (المكلف) ──────────────────────────────────────

  /// Builds the `taxpayer` section for an INDIVIDUAL (type_id = 1).
  static Map<String, dynamic> buildIndividualTaxpayer({
    required String firstName,
    required String lastName,
    required int nationalityId,
    String? nationalId,
    String? passportNumber,
    required String phone,
    required String email,
    Map<String, String>? nationalIdAttachment,
    Map<String, String>? passportAttachment,
    String? otherAttachmentName,
    Map<String, String>? otherAttachment,
  }) {
    return {
      'type_id': 1,
      'first_name': firstName,
      'last_name': lastName,
      'nationality_id': nationalityId,
      if (nationalId != null) 'national_id': nationalId,
      if (passportNumber != null) 'passport_number': passportNumber,
      'phone': phone,
      'email': email,
      if (nationalIdAttachment != null)
        'national_id_attachment': nationalIdAttachment,
      if (passportAttachment != null)
        'passport_attachment': passportAttachment,
      if (otherAttachmentName != null)
        'other_attachment_name': otherAttachmentName,
      if (otherAttachment != null) 'other_attachment': otherAttachment,
    };
  }

  /// Builds the `taxpayer` section for a COMPANY (type_id = 2).
  static Map<String, dynamic> buildCompanyTaxpayer({
    required String name,
    required int nationalityId,
    required String nationalId,
    required String phone,
    required String email,
    required String taxCardNumber,
    String? commercialRegister,
    Map<String, String>? taxCardAttachment,
    Map<String, String>? commercialRegisterAttachment,
  }) {
    return {
      'type_id': 2,
      'name': name,
      'nationality_id': nationalityId,
      'national_id': nationalId,
      'phone': phone,
      'email': email,
      'tax_card_number': taxCardNumber,
      if (commercialRegister != null) 'commercial_register': commercialRegister,
      if (taxCardAttachment != null) 'tax_card_attachment': taxCardAttachment,
      if (commercialRegisterAttachment != null)
        'commercial_register_attachment': commercialRegisterAttachment,
    };
  }

  // ── Location (الموقع) ─────────────────────────────────────

  /// Builds the location fields shared by ALL unit types.
  static Map<String, dynamic> buildLocationFields({
    required int governorateId,
    required int districtId,
    required int villageId,
    String? villageOther,
    required int regionId,
    String? regionOther,
    required dynamic realEstateId, // int or '-1'
    String? realEstateOther,
    int? realEstateFloorId,
    String? realEstateFloorOther,
    int? unitId,
    String? unitOther,
  }) {
    return {
      'governorate_id': governorateId,
      'district_id': districtId,
      'village_id': villageId,
      if (villageOther != null) 'village_other': villageOther,
      'region_id': regionId,
      if (regionOther != null) 'region_other': regionOther,
      'real_estate_id': realEstateId,
      if (realEstateOther != null) 'real_estate_other': realEstateOther,
      if (realEstateFloorId != null) 'real_estate_floor_id': realEstateFloorId,
      if (realEstateFloorOther != null)
        'real_estate_floor_other': realEstateFloorOther,
      if (unitId != null) 'unit_id': unitId,
      if (unitOther != null) 'unit_other': unitOther,
    };
  }

  // ── Supporting documents ──────────────────────────────────

  /// Builds a single supporting document entry.
  static Map<String, String> buildSupportingDoc({
    required String name,
    required String path,
    required String originalFileName,
  }) =>
      {'name': name, 'path': path, 'original_file_name': originalFileName};

  // ── Full declaration wrapper ──────────────────────────────

  /// Wraps taxpayer + unit into the final declaration body.
  static Map<String, dynamic> buildDeclarationBody({
    required int declarationTypeId,
    required int applicantRoleId,
    String? applicantRoleOther,
    Map<String, String>? powerOfAttorney,
    Map<String, String>? jointOwnershipDocument,
    required Map<String, dynamic> taxpayer,
    required Map<String, dynamic> unit,
  }) {
    return {
      'declaration_type_id': declarationTypeId,
      'applicant_role_id': applicantRoleId,
      if (applicantRoleOther != null) 'applicant_role_other': applicantRoleOther,
      if (powerOfAttorney != null) 'power_of_attorney': powerOfAttorney,
      if (jointOwnershipDocument != null)
        'joint_ownership_document': jointOwnershipDocument,
      'taxpayer': taxpayer,
      'unit': unit,
    };
  }
}
