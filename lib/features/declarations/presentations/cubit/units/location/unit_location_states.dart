import '../../../../../../core/helpers/app_enum.dart';

class UnitLocationState {
  final UnitType? unitType;
  final ApplicantType? applicantType;

  final String? selectedGovernorate;
  final String? selectedDistrict;
  final String? selectedNeighborhood;
  final String? selectedStreet;
  final String? selectedBuildingNumber;

  final bool isDistrictOther;
  final bool isNeighborhoodOther;
  final bool isStreetOther;
  final bool isBuildingNumberOther;
  final String? districtOtherText;
  final String? neighborhoodOtherText;
  final String? streetOtherText;

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
  }) {
    return UnitLocationState(
      isDistrictOther: isDistrictOther ?? this.isDistrictOther,
      isNeighborhoodOther: isNeighborhoodOther ?? this.isNeighborhoodOther,
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
    );
  }
}
