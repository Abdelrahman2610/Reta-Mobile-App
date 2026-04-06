class DeclarationDetailsModel {
  final int id;
  final bool viewMode;
  final bool editMode;
  final String? declarationNumber;
  final String tempNumber;
  final String isDraft;
  final String declarationTypeId;
  final String declarationTypeText;
  final String? applicantRoleOther;
  String statusId;
  String statusText;
  final String applicantRoleId;
  final String applicantRoleText;

  final TaxpayerAttachmentModel? powerOfAttorney;
  final TaxpayerAttachmentModel? jointOwnershipDocument;

  final TaxpayerModel taxpayer;
  final UnitsCountModel unitsCount;

  final ResidentialUnitsModel residentialUnits;

  final String? submissionDate;
  final String? updateDate;
  final String createdAt;
  final String updatedAt;
  final Map<String, dynamic>? data;

  DeclarationDetailsModel({
    required this.id,
    required this.viewMode,
    required this.editMode,
    this.declarationNumber,
    required this.tempNumber,
    required this.isDraft,
    required this.declarationTypeId,
    required this.declarationTypeText,
    this.applicantRoleOther,
    required this.statusId,
    required this.statusText,
    required this.applicantRoleId,
    required this.applicantRoleText,
    this.powerOfAttorney,
    this.jointOwnershipDocument,
    required this.taxpayer,
    required this.unitsCount,
    required this.residentialUnits,
    this.submissionDate,
    this.updateDate,
    required this.createdAt,
    required this.updatedAt,
    required this.data,
  });

  factory DeclarationDetailsModel.fromJson(Map<String, dynamic> json) {
    return DeclarationDetailsModel(
      id: json['id'],
      viewMode: json['viewMode'] ?? false,
      editMode: json['editMode'] ?? false,
      declarationNumber: json['declaration_number'],
      tempNumber: json['temp_number'] ?? '',
      isDraft: json['is_draft'] ?? '',
      declarationTypeId: json['declaration_type_id'] ?? '',
      declarationTypeText: json['declaration_type_text'] ?? '',
      applicantRoleOther: json['applicant_role_other'],
      statusId: json['status_id'] ?? '',
      statusText: json['status_text'] ?? '',
      applicantRoleId: json['applicant_role_id'] ?? '',
      applicantRoleText: json['applicant_role_text'] ?? '',
      powerOfAttorney: json['power_of_attorney'] != null
          ? TaxpayerAttachmentModel.fromJson(json['power_of_attorney'])
          : null,
      jointOwnershipDocument: json['joint_ownership_document'] != null
          ? TaxpayerAttachmentModel.fromJson(json['joint_ownership_document'])
          : null,
      taxpayer: TaxpayerModel.fromJson(json['taxpayer'] ?? {}),
      unitsCount: UnitsCountModel.fromJson(json['units_count'] ?? {}),
      residentialUnits: ResidentialUnitsModel.fromJson(
        json['residential_units'] ?? {},
      ),
      submissionDate: json['submission_date'],
      updateDate: json['update_date'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      data: json,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'declaration_type_id':
          int.tryParse(declarationTypeId) ?? declarationTypeId,
      'applicant_role_id': int.tryParse(applicantRoleId) ?? applicantRoleId,
    };

    map['applicant_role_other'] = applicantRoleOther;

    map['power_of_attorney'] = powerOfAttorney?.toJson();

    map['joint_ownership_document'] = jointOwnershipDocument?.toJson();

    // Taxpayer
    map['taxpayer'] = taxpayer.toJson();

    return map;
  }
}

class ResidentialUnitsModel {
  final List<ResidentialUnitModel> data;

  ResidentialUnitsModel({required this.data});

  factory ResidentialUnitsModel.fromJson(Map<String, dynamic> json) {
    return ResidentialUnitsModel(
      data: (json['data'] as List? ?? [])
          .map((e) => ResidentialUnitModel.fromJson(e))
          .toList(),
    );
  }
}

class ResidentialUnitModel {
  final int id;
  final String uniqueId;
  final String usageType;
  final String area;
  final String marketValue;
  final bool exemptedAsResidence;

  final List<int> attachments;
  final List<String> attachmentsText;

  final TaxpayerAttachmentModel? ownershipDeed;
  final TaxpayerAttachmentModel? leaseContract;
  final List<TaxpayerAttachmentModel> supportingDocuments;

  final String createdAt;
  final String updatedAt;

  ResidentialUnitModel({
    required this.id,
    required this.uniqueId,
    required this.usageType,
    required this.area,
    required this.marketValue,
    required this.exemptedAsResidence,
    required this.attachments,
    required this.attachmentsText,
    this.ownershipDeed,
    this.leaseContract,
    required this.supportingDocuments,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ResidentialUnitModel.fromJson(Map<String, dynamic> json) {
    return ResidentialUnitModel(
      id: json['id'],
      uniqueId: json['unique_id'] ?? '',
      usageType: json['usage_type'] ?? '',
      area: json['area'] ?? '',
      marketValue: json['market_value'] ?? '',
      exemptedAsResidence: json['exempted_as_residence'] ?? false,
      attachments: (json['attachments'] as List? ?? [])
          .map((e) => e as int)
          .toList(),
      attachmentsText: (json['attachments_text'] as List? ?? [])
          .map((e) => e.toString())
          .toList(),
      ownershipDeed: json['ownership_deed'] != null
          ? TaxpayerAttachmentModel.fromJson(json['ownership_deed'])
          : null,
      leaseContract: json['lease_contract'] != null
          ? TaxpayerAttachmentModel.fromJson(json['lease_contract'])
          : null,
      supportingDocuments: (json['supporting_documents'] as List? ?? [])
          .map((e) => TaxpayerAttachmentModel.fromJson(e))
          .toList(),
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}

class TaxpayerAttachmentModel {
  final int id;
  final String fieldName;
  final String? name;
  final String? path;
  final String url;
  final String? originalFileName;
  final String fullUrl;

  const TaxpayerAttachmentModel({
    required this.id,
    required this.fieldName,
    this.name,
    required this.url,
    this.originalFileName,
    required this.fullUrl,
    this.path,
  });

  factory TaxpayerAttachmentModel.fromJson(Map<String, dynamic> json) {
    return TaxpayerAttachmentModel(
      id: json['id'] as int,
      fieldName: json['field_name'] as String,
      name: json['name'] as String?,
      path: json['path'] as String?,
      url: json['url'] as String,
      originalFileName: json['original_file_name'] as String?,
      fullUrl: json['full_url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'field_name': fieldName,
      // 'path': path,
      if (name != null) 'name': name,
      'url': url,
      'full_url': fullUrl,
      'original_file_name': originalFileName,
    };
  }
}

class TaxpayerModel {
  final int? id;
  final int? typeId;
  final String? typeText;

  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? email;
  final String? nationalId;
  final String? passportNumber;

  final String? name;
  final String? taxCardNumber;
  final String? commercialRegister;

  final int? nationalityId;
  final String? nationalityText;

  final TaxpayerAttachmentModel? nationalIdAttachment;
  final TaxpayerAttachmentModel? passportAttachment;
  final TaxpayerAttachmentModel? taxCardAttachment;
  final TaxpayerAttachmentModel? commercialRegisterAttachment;
  final TaxpayerAttachmentModel? otherAttachment;
  final String? otherAttachmentName;

  const TaxpayerModel({
    required this.id,
    required this.typeId,
    required this.typeText,
    this.firstName,
    this.lastName,
    this.phone,
    this.email,
    this.nationalId,
    this.passportNumber,
    this.name,
    this.taxCardNumber,
    this.commercialRegister,
    required this.nationalityId,
    this.nationalityText,
    this.nationalIdAttachment,
    this.passportAttachment,
    this.taxCardAttachment,
    this.commercialRegisterAttachment,
    this.otherAttachment,
    this.otherAttachmentName,
  });

  bool get isNatural => typeId == 1;

  bool get isCompany => typeId == 2;

  String get displayName =>
      isNatural ? '${firstName ?? ''} ${lastName ?? ''}'.trim() : name ?? '';

  factory TaxpayerModel.fromJson(Map<String, dynamic> json) {
    TaxpayerAttachmentModel? parseAttachment(String key) {
      final data = json[key];
      if (data == null) return null;
      return TaxpayerAttachmentModel.fromJson(data as Map<String, dynamic>);
    }

    return TaxpayerModel(
      id: int.tryParse(json['id'].toString()),
      typeId: int.tryParse(json['type_id'].toString()),
      typeText: json['type_text'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      phone: json['phone'],
      email: json['email'],
      nationalId: json['national_id'],
      passportNumber: json['passport_number'],
      name: json['name'],
      taxCardNumber: json['tax_card_number'],
      commercialRegister: json['commercial_register'],
      nationalityId: int.tryParse(json['nationality_id'].toString()),
      nationalityText: json['nationality_text'],
      nationalIdAttachment: parseAttachment('national_id_attachment'),
      passportAttachment: parseAttachment('passport_attachment'),
      taxCardAttachment: parseAttachment('tax_card_attachment'),
      commercialRegisterAttachment: parseAttachment(
        'commercial_register_attachment',
      ),
      otherAttachment: parseAttachment('other_attachment'),
      otherAttachmentName: json['other_attachment_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type_id': typeId,
      'type_text': typeText,
      if (isNatural) ...{
        'first_name': firstName,
        'last_name': lastName,
        'phone': phone,
        'email': email,
        'national_id': nationalId,
        'passport_number': passportNumber,
      },
      if (isCompany) ...{
        'name': name,
        'tax_card_number': taxCardNumber,
        'commercial_register': commercialRegister,
        'other_attachment_name': otherAttachmentName,

        'tax_card_attachment': taxCardAttachment?.toJson(),
        'commercial_register_attachment': commercialRegisterAttachment
            ?.toJson(),
        'other_attachment': otherAttachment?.toJson(),
      },
      'nationality_id': nationalityId,
      'nationality_text': nationalityText,
    };
  }
}

class UnitsCountModel {
  final int residential;
  final int commercial;
  final int service;
  final int total;

  UnitsCountModel({
    required this.residential,
    required this.commercial,
    required this.service,
    required this.total,
  });

  factory UnitsCountModel.fromJson(Map<String, dynamic> json) {
    return UnitsCountModel(
      residential: json['residential'] ?? 0,
      commercial: json['commercial'] ?? 0,
      service: json['service'] ?? 0,
      total: json['total'] ?? 0,
    );
  }
}

class CategoryConfig {
  final String key;
  final String label;
  final String deleteLabel;
  final String deleteID;

  final List<String> summaryFields; // fields to show in card

  const CategoryConfig({
    required this.key,
    required this.label,
    required this.summaryFields,
    required this.deleteLabel,
    required this.deleteID,
  });
}
