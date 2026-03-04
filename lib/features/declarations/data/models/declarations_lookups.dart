class DeclarationLookup {
  final int id;
  final String name;

  const DeclarationLookup({required this.id, required this.name});

  factory DeclarationLookup.fromJson(Map<String, dynamic> json) {
    return DeclarationLookup(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}

class DeclarationLookupsModel {
  final List<DeclarationLookup> declarationTypes;
  final List<DeclarationLookup> applicantRoles;
  final List<DeclarationLookup> taxpayerTypes;
  final List<DeclarationLookup> propertyTypes;
  final List<DeclarationLookup> residentialUnitTypes;
  final List<DeclarationLookup> commercialUnitTypes;
  final List<DeclarationLookup> nationalities;
  final List<DeclarationLookup> unitAttachments;
  final List<DeclarationLookup> governorates;
  final List<DeclarationLookup> realEstateFloors;
  final List<DeclarationLookup> yesNoOptions;
  final List<DeclarationLookup> installationTypes;
  final List<DeclarationLookup> exemptionReasons;
  final int egyptNationalityId;
  final bool canCreateDeclaration;

  final List<DeclarationLookup> starRatings;
  final List<DeclarationLookup> hotelViewTypes;
  final List<DeclarationLookup> exploitationTypes;
  final List<DeclarationLookup> burdenActivityTypes;
  final List<DeclarationLookup> buildingTypes;

  const DeclarationLookupsModel({
    required this.declarationTypes,
    required this.applicantRoles,
    required this.taxpayerTypes,
    required this.propertyTypes,
    required this.residentialUnitTypes,
    required this.commercialUnitTypes,
    required this.nationalities,
    required this.unitAttachments,
    required this.governorates,
    required this.realEstateFloors,
    required this.yesNoOptions,
    required this.installationTypes,
    required this.exemptionReasons,
    required this.egyptNationalityId,
    required this.canCreateDeclaration,
    required this.starRatings,
    required this.hotelViewTypes,
    required this.exploitationTypes,
    required this.burdenActivityTypes,
    required this.buildingTypes,
  });

  factory DeclarationLookupsModel.fromJson(
    Map<String, dynamic> json, {
    List<DeclarationLookup> starRatings = const [],
    List<DeclarationLookup> viewTypes = const [],
    List<DeclarationLookup> exploitationTypes = const [],
    List<DeclarationLookup> burdenActivityTypes = const [],
    List<DeclarationLookup> buildingTypes = const [],
  }) {
    final data = json['data'] as Map<String, dynamic>;

    List<DeclarationLookup> parse(String key) {
      final list = data[key] as List? ?? [];
      return list
          .map((e) => DeclarationLookup.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return DeclarationLookupsModel(
      declarationTypes: parse('declaration_types'),
      applicantRoles: parse('applicant_roles'),
      taxpayerTypes: parse('taxpayer_types'),
      propertyTypes: parse('property_types'),
      residentialUnitTypes: parse('residential_unit_types'),
      commercialUnitTypes: parse('commercialUnitTypes'),
      nationalities: parse('nationalities'),
      unitAttachments: parse('unit_attachments'),
      governorates: parse('governorates'),
      realEstateFloors: parse('real_estate_floors'),
      yesNoOptions: parse('DoYouWantExtraAttachmentsForRequestTypes'),
      installationTypes: parse('installationTypes'),
      exemptionReasons: parse('exemptionReasons'),
      egyptNationalityId: data['egypt_nationality_id'] as int? ?? 63,
      canCreateDeclaration: data['can_create_declaration'] as bool? ?? false,
      starRatings: starRatings,
      hotelViewTypes: viewTypes,
      exploitationTypes: exploitationTypes,
      burdenActivityTypes: burdenActivityTypes,
      buildingTypes: buildingTypes,
    );
  }

  DeclarationLookupsModel copyWith({
    List<DeclarationLookup>? starRatings,
    List<DeclarationLookup>? hotelViewTypes,
    List<DeclarationLookup>? exploitationTypes,
    List<DeclarationLookup>? burdenActivityTypes,
    List<DeclarationLookup>? buildingTypes,
  }) {
    return DeclarationLookupsModel(
      declarationTypes: declarationTypes,
      applicantRoles: applicantRoles,
      taxpayerTypes: taxpayerTypes,
      propertyTypes: propertyTypes,
      residentialUnitTypes: residentialUnitTypes,
      commercialUnitTypes: commercialUnitTypes,
      nationalities: nationalities,
      unitAttachments: unitAttachments,
      governorates: governorates,
      realEstateFloors: realEstateFloors,
      yesNoOptions: yesNoOptions,
      installationTypes: installationTypes,
      exemptionReasons: exemptionReasons,
      egyptNationalityId: egyptNationalityId,
      canCreateDeclaration: canCreateDeclaration,
      starRatings: starRatings ?? this.starRatings,
      hotelViewTypes: hotelViewTypes ?? this.hotelViewTypes,
      exploitationTypes: exploitationTypes ?? this.exploitationTypes,
      burdenActivityTypes: burdenActivityTypes ?? this.burdenActivityTypes,
      buildingTypes: buildingTypes ?? this.buildingTypes,
    );
  }

  List<String> get nationalityNames =>
      nationalities.map((n) => n.name).toList();

  List<String> get governorateNames => governorates.map((g) => g.name).toList();

  List<String> get floorNames => realEstateFloors.map((f) => f.name).toList();

  List<String> get propertyTypeNames =>
      propertyTypes.map((p) => p.name).toList();

  List<String> get residentialUnitTypeNames =>
      residentialUnitTypes.map((r) => r.name).toList();

  List<String> get unitAttachmentNames =>
      unitAttachments.map((u) => u.name).toList();

  List<String> get installationTypeNames =>
      installationTypes.map((i) => i.name).toList();

  List<String> get exemptionReasonNames =>
      exemptionReasons.map((e) => e.name).toList();

  bool isEgyptian(int nationalityId) => nationalityId == egyptNationalityId;

  List<String> get starRatingNames => starRatings.map((s) => s.name).toList();

  List<String> get viewTypeNames => hotelViewTypes.map((v) => v.name).toList();
}
