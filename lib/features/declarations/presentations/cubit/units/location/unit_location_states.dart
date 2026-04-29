import 'package:reta/features/declarations/data/models/street_model.dart';

import '../../../../../../core/helpers/app_enum.dart';
import '../../../../data/models/declarations_lookups.dart';

class UnitLocationState {
  final UnitType? unitType;
  final ApplicantType? applicantType;

  final List<DeclarationLookup> governoratesList;
  final bool isLoadingGovernorates;
  final String? selectedGovernorate;

  final String? selectedDistrict;
  final List<DeclarationLookup>? districtsList;
  final bool isLoadingDistricts;

  final String? selectedNeighborhood;
  final String? selectedStreet;
  final List<DeclarationLookup>? villagesList;
  final List<StreetModel>? allStreetsList;
  final List<StreetModel>? streetsList;
  final List<DeclarationLookup>? buildingList;
  final bool isLoadingVillages;

  final String? selectedBuildingNumber;

  final bool isDistrictOther;
  final bool isNeighborhoodOther;
  final bool isStreetOther;
  final bool isBuildingNumberOther;
  final String? districtOtherText;
  final String? neighborhoodOtherText;
  final String? streetOtherText;

  final int? selectedGovernorateId;
  final int? selectedDistrictId;
  final int? selectedVillageId;
  final int? selectedStreetId;
  final int? selectedBuildingNumberId;
  final bool isInitializing;
  final bool isNearestProperty;
  final bool isUrban;

  const UnitLocationState({
    this.selectedGovernorate,
    this.selectedDistrict,
    this.selectedNeighborhood,
    this.selectedStreet,
    this.selectedBuildingNumber,
    this.isDistrictOther = false,
    this.isNeighborhoodOther = false,
    this.isStreetOther = false,
    this.isBuildingNumberOther = false,
    this.districtOtherText,
    this.neighborhoodOtherText,
    this.streetOtherText,
    this.unitType,
    this.applicantType,
    this.governoratesList = const [],
    this.isLoadingGovernorates = false,
    this.districtsList,
    this.isLoadingDistricts = false,
    this.villagesList,
    this.allStreetsList,
    this.streetsList,
    this.isLoadingVillages = false,
    this.selectedGovernorateId,
    this.selectedDistrictId,
    this.selectedVillageId,
    this.selectedStreetId,
    this.selectedBuildingNumberId,
    this.isInitializing = false,
    this.buildingList,
    this.isNearestProperty = false,
    this.isUrban = false,
  });

  UnitLocationState copyWith({
    String? selectedGovernorate,
    String? selectedDistrict,
    String? selectedNeighborhood,
    String? selectedStreet,
    String? selectedBuildingNumber,
    bool? isDistrictOther,
    bool? isNeighborhoodOther,
    bool? isStreetOther,
    bool? isBuildingNumberOther,
    String? districtOtherText,
    String? neighborhoodOtherText,
    String? streetOtherText,
    List<DeclarationLookup>? governoratesList,
    bool? isLoadingGovernorates,
    List<DeclarationLookup>? districtsList,
    bool? isLoadingDistricts,
    List<DeclarationLookup>? villagesList,
    List<StreetModel>? allStreetsList,
    List<StreetModel>? streetsList,
    List<DeclarationLookup>? buildingList,
    bool? isLoadingVillages,

    int? selectedGovernorateId,
    int? selectedDistrictId,
    int? selectedVillageId,
    int? selectedStreetId,
    int? selectedBuildingNumberId,
    bool? isInitializing,
    bool? isNearestProperty,
    bool? isUrban,
  }) {
    return UnitLocationState(
      isDistrictOther: isDistrictOther ?? this.isDistrictOther,
      isNeighborhoodOther: isNeighborhoodOther ?? this.isNeighborhoodOther,
      governoratesList: governoratesList ?? this.governoratesList,
      isLoadingGovernorates:
          isLoadingGovernorates ?? this.isLoadingGovernorates,
      districtsList: districtsList ?? this.districtsList,
      isLoadingDistricts: isLoadingDistricts ?? this.isLoadingDistricts,
      isStreetOther: isStreetOther ?? this.isStreetOther,
      isBuildingNumberOther:
          isBuildingNumberOther ?? this.isBuildingNumberOther,
      districtOtherText: districtOtherText == 'null'
          ? null
          : districtOtherText ?? this.districtOtherText,
      neighborhoodOtherText: neighborhoodOtherText == 'null'
          ? null
          : neighborhoodOtherText ?? this.neighborhoodOtherText,
      streetOtherText: streetOtherText == 'null'
          ? null
          : streetOtherText ?? this.streetOtherText,
      selectedBuildingNumber: selectedBuildingNumber == 'null'
          ? null
          : selectedBuildingNumber ?? this.selectedBuildingNumber,
      selectedStreet: selectedStreet == 'null'
          ? null
          : selectedStreet ?? this.selectedStreet,
      selectedNeighborhood: selectedNeighborhood == 'null'
          ? null
          : selectedNeighborhood ?? this.selectedNeighborhood,
      selectedDistrict: selectedDistrict == 'null'
          ? null
          : selectedDistrict ?? this.selectedDistrict,
      selectedGovernorate: selectedGovernorate == 'null'
          ? null
          : selectedGovernorate ?? this.selectedGovernorate,
      villagesList: villagesList ?? this.villagesList,
      allStreetsList: allStreetsList ?? this.allStreetsList,
      streetsList: streetsList ?? this.streetsList,
      isLoadingVillages: isLoadingVillages ?? this.isLoadingVillages,
      selectedGovernorateId:
          selectedGovernorateId ?? this.selectedGovernorateId,
      selectedDistrictId: selectedDistrictId ?? this.selectedDistrictId,
      selectedVillageId: selectedVillageId ?? this.selectedVillageId,
      selectedStreetId: selectedStreetId ?? this.selectedStreetId,
      selectedBuildingNumberId:
          selectedBuildingNumberId ?? this.selectedBuildingNumberId,
      isInitializing: isInitializing ?? this.isInitializing,
      buildingList: buildingList ?? this.buildingList,
      isNearestProperty: isNearestProperty ?? this.isNearestProperty,
      isUrban: isUrban ?? this.isUrban,
    );
  }
}
