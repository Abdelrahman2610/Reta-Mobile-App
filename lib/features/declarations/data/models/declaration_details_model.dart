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
  final String statusId;
  final String statusText;
  final String applicantRoleId;
  final String applicantRoleText;

  final FileModel? powerOfAttorney;
  final FileModel? jointOwnershipDocument;

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
          ? FileModel.fromJson(json['power_of_attorney'])
          : null,
      jointOwnershipDocument: json['joint_ownership_document'] != null
          ? FileModel.fromJson(json['joint_ownership_document'])
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

  final FileModel? ownershipDeed;
  final FileModel? leaseContract;
  final List<FileModel> supportingDocuments;

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
          ? FileModel.fromJson(json['ownership_deed'])
          : null,
      leaseContract: json['lease_contract'] != null
          ? FileModel.fromJson(json['lease_contract'])
          : null,
      supportingDocuments: (json['supporting_documents'] as List? ?? [])
          .map((e) => FileModel.fromJson(e))
          .toList(),
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}

class FileModel {
  final int? id;
  final String? fieldName;
  final String? name;
  final String? url;
  final String? path;
  final String? originalFileName;
  final String? fullUrl;

  FileModel({
    this.id,
    this.fieldName,
    this.name,
    this.url,
    this.path,
    this.originalFileName,
    this.fullUrl,
  });

  factory FileModel.fromJson(Map<String, dynamic> json) {
    return FileModel(
      id: json['id'],
      path: json['path'],
      fieldName: json['field_name'],
      name: json['name'],
      url: json['url'],
      originalFileName: json['original_file_name'],
      fullUrl: json['full_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (fieldName != null) 'field_name': fieldName,
      if (path != null) 'path': path,
      if (name != null) 'name': name,
      if (url != null) 'url': url,
      if (fullUrl != null) 'full_url': fullUrl,
      if (originalFileName != null) 'original_file_name': originalFileName,
    };
  }
}

class TaxpayerModel {
  final String? name;
  final String? firstName;
  final String? lastName;
  final int? nationalityId;
  final String? nationalId;
  final String? phone;
  final String? email;
  final String? taxCardNumber;
  final String? otherAttachmentName;
  final int? typeId;
  final FileModel? otherAttachment;
  final FileModel? nationalIdAttachment;
  final FileModel? taxCardAttachment;

  TaxpayerModel({
    this.name,
    this.firstName,
    this.lastName,
    this.nationalId,
    this.nationalityId,
    this.taxCardNumber,
    this.otherAttachmentName,
    this.phone,
    this.email,
    this.typeId,
    this.otherAttachment,
    this.nationalIdAttachment,
    this.taxCardAttachment,
  });

  factory TaxpayerModel.fromJson(Map<String, dynamic> json) {
    return TaxpayerModel(
      name: json['name'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      nationalId: json['national_id'],
      taxCardNumber: json['tax_card_number'],
      otherAttachmentName: json['other_attachment_name'],
      nationalityId: json['nationality_id'],
      phone: json['phone'],
      email: json['email'],
      typeId: json['type_id'],
      otherAttachment: json['other_attachment'] != null
          ? FileModel.fromJson(json['other_attachment'])
          : null,
      nationalIdAttachment: json['national_id_attachment'] != null
          ? FileModel.fromJson(json['national_id_attachment'])
          : null,
      taxCardAttachment: json['tax_card_attachment'] != null
          ? FileModel.fromJson(json['tax_card_attachment'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'type_id': typeId,
      'nationality_id': nationalityId,
    };

    map['first_name'] = firstName;
    map['last_name'] = lastName;
    map['phone'] = phone;
    map['email'] = email;

    map['name'] = name;
    map['tax_card_number'] = taxCardNumber;

    // Egyptian → national_id, otherwise → passport
    if (nationalityId == 1) {
      map['national_id'] = nationalId;
    } else {
      map['passport_number'] = nationalId; // or add a passportNumber field
    }

    map['national_id_attachment'] = nationalIdAttachment?.toJson();

    map['tax_card_attachment'] = taxCardAttachment?.toJson();

    map['other_attachment'] = otherAttachment?.toJson();
    map['other_attachment_name'] = otherAttachmentName;

    return map;
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
