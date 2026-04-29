class MapLocationResult {
  // Building data
  final dynamic renin;
  final String? buildingName;
  final String? buildingType;
  final double? areaMq;
  final Map<String, dynamic>? geometry;

  // address names
  final String? governorate;
  final String? policeStation;
  final String? neighborhood;
  final String? street;
  final String? region;
  final String? city;
  final String? mogawra;
  final String? village;
  final String? settlement;
  final dynamic streetNumber;

  // address IDs
  final String? regionId;
  final String? governorateId;
  final String? cityId;
  final String? districtId;
  final String? policeStationId;
  final String? neighborhoodId;
  final String? mogawraId;
  final String? villageId;
  final String? settlementId;
  final String? streetId;

  MapLocationResult({
    this.renin,
    this.buildingName,
    this.buildingType,
    this.areaMq,
    this.geometry,
    this.governorate,
    this.policeStation,
    this.neighborhood,
    this.street,
    this.region,
    this.city,
    this.mogawra,
    this.village,
    this.settlement,
    this.streetNumber,
    this.regionId,
    this.governorateId,
    this.cityId,
    this.districtId,
    this.policeStationId,
    this.neighborhoodId,
    this.mogawraId,
    this.villageId,
    this.settlementId,
    this.streetId,
  });

  Map<String, dynamic> toMap() => {
    'buildingProfile': {
      'renin': renin,
      'name': buildingName,
      'type': buildingType,
      'area_m2': areaMq,
      'address': {
        'region': region,
        'goveronrate': governorate,
        'city': city,
        'district': null,
        'policestation': policeStation,
        'neighborhood': neighborhood,
        'mogawra': mogawra,
        'village': village,
        'settlement': settlement,
        'street': street,
        'number': streetNumber,
      },
      'address_ids': {
        'region_id': regionId,
        'governorate_id': governorateId,
        'city_id': cityId,
        'district_id': districtId,
        'policestation_id': policeStationId,
        'neighborhood_id': neighborhoodId,
        'mogawra_id': mogawraId,
        'village_id': villageId,
        'settlement_id': settlementId,
        'street_id': streetId,
        'number_id': null,
      },
      if (geometry != null) 'geometry': geometry,
    },

    'gg_governorate_id': governorateId,
    'gg_police_station_id': policeStationId,
    'gg_street_id': streetId,
    'gg_city_id': cityId,
    'gg_district_id': districtId,
    'gg_mogawra_id': mogawraId,

    'governorate': governorate,
    'police_station': policeStation,
    'neighborhood': neighborhood,
    'street': street,
    'renin': renin,
    'type': buildingType,
  };
}
