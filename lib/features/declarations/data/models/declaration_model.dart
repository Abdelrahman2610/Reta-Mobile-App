List<DeclarationModel> declarationListFromJson(dynamic json) {
  if (json is List) {
    return json.map((e) => DeclarationModel.fromJson(e)).toList();
  }
  return [];
}

class DeclarationModel {
  final int? id;
  final String? declarationNumber;
  final String? declarationTypeId;
  final String? declarationTypeText;
  final String? statusId;
  final String? statusText;
  final String? creationDate;
  final String? submittionDate;
  final String? updateDate;
  final String? submitterType;
  final String? taxpayer;
  final UnitsCountModel? unitsCount;

  DeclarationModel({
    this.id,
    this.declarationNumber,
    this.declarationTypeId,
    this.declarationTypeText,
    this.statusId,
    this.statusText,
    this.creationDate,
    this.submittionDate,
    this.updateDate,
    this.submitterType,
    this.taxpayer,
    this.unitsCount,
  });

  factory DeclarationModel.fromJson(Map<String, dynamic> json) {
    return DeclarationModel(
      id: json['id'],
      declarationNumber: json['declaration_number'] ?? '',
      declarationTypeId: json['declaration_type_id'] ?? '',
      declarationTypeText: json['declaration_type_text'] ?? '',
      statusId: json['status_id'] ?? '',
      statusText: json['status_text'] ?? '',
      creationDate: json['creation_date'] ?? '',
      submittionDate: json['submittion_date'],
      updateDate: json['update_date'],
      submitterType: json['submitter_type'] ?? '',
      taxpayer: json['taxpayer'] ?? '',
      unitsCount: json['units_count'] != null
          ? UnitsCountModel.fromJson(json['units_count'])
          : null,
    );
  }
}

class UnitsCountModel {
  final int residential;
  final int commercial;
  final int service;
  final int hotelFacilities;
  final int industrialFacility;
  final int productionFacility;
  final int petroleumFacility;
  final int mineQuarry;
  final int vacantLand;
  final int fixedInstallation;
  final int total;

  UnitsCountModel({
    this.residential = 0,
    this.commercial = 0,
    this.service = 0,
    this.hotelFacilities = 0,
    this.industrialFacility = 0,
    this.productionFacility = 0,
    this.petroleumFacility = 0,
    this.mineQuarry = 0,
    this.vacantLand = 0,
    this.fixedInstallation = 0,
    this.total = 0,
  });

  factory UnitsCountModel.fromJson(Map<String, dynamic> json) {
    return UnitsCountModel(
      residential: json['residential'] ?? 0,
      commercial: json['commercial'] ?? 0,
      service: json['service'] ?? 0,
      hotelFacilities: json['hotel_facilities'] ?? 0,
      industrialFacility: json['industrial_facility'] ?? 0,
      productionFacility: json['production_facility'] ?? 0,
      petroleumFacility: json['petroleum_facility'] ?? 0,
      mineQuarry: json['mine_quarry'] ?? 0,
      vacantLand: json['vacant_land'] ?? 0,
      fixedInstallation: json['fixed_installation'] ?? 0,
      total: json['total'] ?? 0,
    );
  }
}
