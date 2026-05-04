import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reta/core/helpers/app_enum.dart';
import 'package:reta/core/network/api_constants.dart';
import 'package:reta/features/declarations/presentations/cubit/declaration/declaration_cubit.dart';
import 'package:reta/features/declarations/presentations/cubit/units/location/unit_location_states.dart';
import 'package:reta/features/declarations/presentations/pages/units/unit_data.dart';

import '../../../../../../core/network/api_result.dart';
import '../../../../../../core/network/dio_client.dart';
import '../../../../data/models/declarations_lookups.dart';
import '../../../../data/models/district_details.dart';
import '../../../../data/models/map_location_result.dart';
import '../../../../data/models/street_model.dart';
import '../../applicant_cubit.dart';
import '../../declaration_lookups_cubit.dart';
import '../unit_data/unit_data_cubit.dart';

const String kOther = 'أخرى';

class UnitLocationCubit extends Cubit<UnitLocationState> {
  UnitLocationCubit({
    required this.unitType,
    required this.applicantType,
    required this.declarationId,
    this.locationData,
    this.otherName,
    this.unitData,
    this.applicantData,
  }) : super(const UnitLocationState()) {
    fetchGovernorates();
  }

  final String? otherName;
  final UnitType unitType;
  final ApplicantType applicantType;
  final int declarationId;
  final Map<String, dynamic>? locationData;
  final Map<String, dynamic>? unitData;
  final Map<String, dynamic>? applicantData;
  String unitId = '-1';

  /// ------------------ New parameters --------------------------
  final knownBuildNumController = TextEditingController();
  final addressAdditionalInfoController = TextEditingController();
  bool isNearestProperty = false;
  MapLocationResult? mapData;

  final formKey = GlobalKey<FormState>();

  /// ------------------ Other text controllers -------------------
  final districtOtherController = TextEditingController();
  final neighborhoodOtherController = TextEditingController();
  final streetOtherController = TextEditingController();
  final buildingNumberOtherController = TextEditingController();
  final neighborhoodNameController = TextEditingController();

  /// ----------------------- Fetch Data -----------------------------
  Future<void> _restoreLocationData(
    List<DeclarationLookup> governorates,
  ) async {
    mapData = locationData?['buildingProfile'] ?? {};
    emit(
      state.copyWith(
        selectedGovernorate: locationData!['governorate'],
        // selectedGovernorateId: governorate.id,
        selectedDistrict: locationData!['district'],
        // selectedDistrictId: district?.id,
        selectedNeighborhood: locationData!['neighborhood'],
        isNeighborhoodOther: locationData!['is_other_village'] ?? false,
        selectedStreet: locationData!['street'],
        isStreetOther: locationData!['is_other_region'] ?? false,
        selectedBuildingNumber: locationData!['buildingNumber'],
        isBuildingNumberOther: locationData!['is_other_real_state'] ?? false,
      ),
    );

    // controllers
    neighborhoodOtherController.text = locationData!['village_other'] ?? '';
    streetOtherController.text = locationData!['region_other'] ?? '';
    buildingNumberOtherController.text =
        locationData!['real_estate_other'] ?? '';
  }

  Future<void> _initFromUnitData(List<DeclarationLookup> governorates) async {
    emit(state.copyWith(isInitializing: true));
    if (unitData != null) {
      mapData = MapLocationResult.fromMap(unitData!);
      bool isUrban = unitData!['new_urban_communities_authority'] == 1;
      isNearestProperty = unitData!['is_nearest_property'] == 1;
      knownBuildNumController.text = unitData?['known_build_num'] ?? '';
      addressAdditionalInfoController.text =
          unitData?['address_additional_info'] ?? '';

      unitId = unitData!['id'].toString();
      mapData = unitData?['buildingProfile'];

      emit(
        state.copyWith(
          isInitializing: false,
          isUrban: isUrban,
          isNearestProperty: isNearestProperty,
          // selectedGovernorate: governorate.name,
          // selectedGovernorateId: governorate.id,
          // selectedDistrict: district?.name,
          // selectedDistrictId: district?.id,
          // selectedNeighborhood: village?.name,
          // isNeighborhoodOther: unitData!['village_other'] != null,
          // selectedStreet: street?.name,
          // isStreetOther: unitData!['region_other'] != null,
          // selectedBuildingNumberId: realEstateId,
          // selectedBuildingNumber: building?.name,
          isBuildingNumberOther: unitData!['real_estate_other'] != null,
        ),
      );

      // controllers
      neighborhoodOtherController.text = unitData!['village_other'] ?? '';
      streetOtherController.text = unitData!['region_other'] ?? '';
      buildingNumberOtherController.text = unitData!['real_estate_other'] ?? '';
    }
  }

  Future<void> fetchGovernorates() async {
    emit(state.copyWith(isLoadingGovernorates: true));

    final result = await safeApiCall(() async {
      final response = await DioClient.instance.dio.get(
        ApiConstants.governorates,
      );
      final list = response.data['data'] as List;
      return list.map((e) => DeclarationLookup.fromJson(e)).toList();
    });

    switch (result) {
      case ApiSuccess(:final data):
        emit(
          state.copyWith(governoratesList: data, isLoadingGovernorates: false),
        );
        if (locationData != null) await _restoreLocationData(data);
        if (unitData != null) await _initFromUnitData(data);
      case ApiError(:final message):
        List<DeclarationLookup> governorates = [];
        governorates.add(DeclarationLookup(id: 1, name: 'القاهرة'));
        governorates.add(DeclarationLookup(id: 2, name: 'الإسكندرية'));
        governorates.add(DeclarationLookup(id: 3, name: 'الجيزة'));
        governorates.add(DeclarationLookup(id: 4, name: 'الشرقية'));
        governorates.add(DeclarationLookup(id: 5, name: 'الدقهلية'));
        governorates.add(DeclarationLookup(id: 6, name: 'البحيرة'));
        governorates.add(DeclarationLookup(id: 7, name: 'المنيا'));
        governorates.add(DeclarationLookup(id: 8, name: 'أسيوط'));
        governorates.add(DeclarationLookup(id: 9, name: 'سوهاج'));
        emit(
          state.copyWith(
            governoratesList: governorates,
            isLoadingGovernorates: false,
          ),
        );
    }
  }

  Future<void> fetchDistricts(int governorateId) async {
    emit(state.copyWith(isLoadingDistricts: true));

    final result = await safeApiCall(() async {
      final response = await DioClient.instance.dio.get(
        ApiConstants.districtsByGovernorate(governorateId),
      );
      final list = response.data['data'] as List;
      return list.map((e) => DeclarationLookup.fromJson(e)).toList();
    });

    switch (result) {
      case ApiSuccess(:final data):
        emit(state.copyWith(districtsList: data, isLoadingDistricts: false));
      case ApiError(:final message):
        emit(state.copyWith(isLoadingDistricts: false));
    }
  }

  Future<void> fetchVillagesAndStreets(int? districtId) async {
    emit(state.copyWith(isLoadingVillages: true));

    final result = await safeApiCall(() async {
      final response = await DioClient.instance.dio.get(
        ApiConstants.villagesByDistrict(districtId ?? 0),
      );
      return DistrictDetailsModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    });

    switch (result) {
      case ApiSuccess(:final data):
        emit(
          state.copyWith(
            villagesList: data.villages,
            allStreetsList: data.streets,
            isLoadingVillages: false,
          ),
        );
      case ApiError(:final message):
        emit(state.copyWith(isLoadingVillages: false));
    }
  }

  Future<void> fetchBuildingNumber(int? streetId) async {
    emit(state.copyWith(isLoadingVillages: true));

    final result = await safeApiCall(() async {
      final response = await DioClient.instance.dio.get(
        ApiConstants.realEstatesByRegion(streetId ?? 0),
      );
      final list = response.data['data'] as List;
      return list.map((e) => DeclarationLookup.fromJson(e)).toList();
    });

    switch (result) {
      case ApiSuccess(:final data):
        emit(state.copyWith(buildingList: data, isLoadingVillages: false));
      case ApiError(:final message):
        emit(state.copyWith(isLoadingVillages: false));
    }
  }

  void onDistrictOtherChanged(String value) {
    emit(state.copyWith(districtOtherText: value));
  }

  void onNeighborhoodOtherChanged(String value) {
    emit(state.copyWith(neighborhoodOtherText: value));
  }

  void onStreetOtherChanged(String value) {
    emit(state.copyWith(streetOtherText: value));
  }

  ///---------------------------- Actions ----------------------------

  Future<void> selectGovernorate(String? value, int? governorateId) async {
    final selected = state.governoratesList.firstWhere(
      (g) => g.name == value,
      orElse: () => DeclarationLookup(id: 0, name: ''),
    );
    emit(
      UnitLocationState(
        selectedGovernorate: value,
        governoratesList: state.governoratesList,
        selectedGovernorateId: selected.id,
      ),
    );
    if (governorateId != null) await fetchDistricts(governorateId);
  }

  void selectDistrict(String? value) {
    final isOther = value == kOther;

    final selected = state.districtsList?.firstWhere(
      (d) => d.name == value,
      orElse: () => DeclarationLookup(id: 0, name: ''),
    );

    emit(
      state.copyWith(
        selectedDistrict: value,
        selectedDistrictId: selected?.id,
        isDistrictOther: isOther,
        selectedNeighborhood: 'null',
        selectedStreet: 'null',
        selectedBuildingNumber: 'null',
        isNeighborhoodOther: false,
        isStreetOther: false,
        isBuildingNumberOther: false,
      ),
    );
    if (!isOther) districtOtherController.clear();
    if (!isOther && selected?.id != 0) fetchVillagesAndStreets(selected?.id);
  }

  void selectNeighborhood(String? value) {
    final isOther =
        value == kOther ||
        state.villagesList
                ?.firstWhere(
                  (v) => v.name == value,
                  orElse: () => DeclarationLookup(id: 0, name: ''),
                )
                .id ==
            -1;

    final selectedVillage = state.villagesList?.firstWhere(
      (v) => v.name == value,
      orElse: () => DeclarationLookup(id: 0, name: ''),
    );

    final filteredStreets = state.allStreetsList
        ?.where((s) => s.villageId == selectedVillage?.id)
        .toList();

    List<StreetModel> streetsWithOther = isOther
        ? [StreetModel(id: -1, villageId: -1, name: kOther)]
        : [
            ...filteredStreets ?? [],
            StreetModel(id: -1, villageId: -1, name: kOther),
          ];

    emit(
      state.copyWith(
        selectedNeighborhood: value,
        isNeighborhoodOther: isOther,
        selectedVillageId: selectedVillage?.id,
        selectedStreet: 'null',
        selectedBuildingNumber: 'null',
        isStreetOther: false,
        isBuildingNumberOther: false,
        streetsList: streetsWithOther,
      ),
    );
    if (!isOther) neighborhoodOtherController.clear();
  }

  void selectStreet(String? value) {
    final selected = state.streetsList?.firstWhere(
      (g) => g.name == value,
      orElse: () => StreetModel(id: 0, name: '', villageId: 0),
    );

    final isOther = value == kOther || selected?.id == -1;

    emit(
      state.copyWith(
        selectedStreet: value,
        selectedStreetId: selected?.id,
        isStreetOther: isOther,
        selectedBuildingNumber: 'null',
        isBuildingNumberOther: false,
      ),
    );
    if (!isOther) streetOtherController.clear();
    fetchBuildingNumber(selected?.id);
  }

  void selectBuildingNumber(String? value) {
    final selected = state.buildingList?.firstWhere(
      (g) => g.name == value,
      orElse: () => DeclarationLookup(id: 0, name: ''),
    );

    final isOther = value == kOther || selected?.id == -1;

    emit(
      state.copyWith(
        selectedBuildingNumberId: selected?.id,
        selectedBuildingNumber: value,
        isBuildingNumberOther: isOther,
      ),
    );
    if (!isOther) buildingNumberOtherController.clear();
  }

  /// ---------------------------- Build Payload ----------------------------

  Map<String, dynamic> buildLocationPayloadOld() {
    return {
      'governorate_id': state.selectedGovernorateId,
      'district_id': state.selectedDistrictId,

      // الشياخة
      'village_id': state.selectedVillageId,
      if (state.isNeighborhoodOther)
        'village_other': neighborhoodOtherController.text.trim(),

      // الشارع
      'region_id': state.selectedStreetId,
      if (state.isStreetOther)
        'region_other': streetOtherController.text.trim(),

      // رقم العقار
      'real_estate_id': state.selectedBuildingNumberId,
      if (state.isBuildingNumberOther)
        'real_estate_other': buildingNumberOtherController.text.trim(),
    };
  }

  Map<String, dynamic> buildLocationPayloadNew() {
    Map<String, dynamic>? mapData = this.mapData?.toMap();
    return {
      if (mapData != null) ...{
        'search_using': 1,
        'new_urban_communities_authority': state.isUrban ? 1 : 0,
        'is_nearest_property': isNearestProperty ? 1 : 0,
        'known_build_num': knownBuildNumController.text.trim(),
        'address_additional_info': addressAdditionalInfoController.text.trim(),
        'gg_governorate_id': mapData['gg_governorate_id'],
        'gg_police_station_id': mapData['gg_police_station_id'],
        'gg_street_id': mapData['gg_street_id'],
        'gg_city_id': mapData['gg_city_id'],
        'gg_district_id': mapData['gg_district_id'],
        'gg_mogawra_id': mapData['gg_mogawra_id'],
        'buildingProfile': mapData['buildingProfile'],
      },
    };
  }

  Map<String, dynamic> buildLocationPayload() {
    return buildLocationPayloadNew();
  }

  bool validate() => formKey.currentState?.validate() ?? false;

  void onNextButtonTapped(
    BuildContext context,
    ApplicantType applicantType,
    String? otherName,
  ) {
    final applicantCubit = unitData != null
        ? null
        : context.read<ApplicantCubit>();
    final declarationCubit = context.read<DeclarationCubit>();
    final lookupsCubit = context.read<DeclarationLookupsCubit>();

    int id =
        state.buildingList
            ?.firstWhere(
              (buildingNumber) =>
                  buildingNumber.name == state.selectedBuildingNumber,
            )
            .id ??
        -1;
    final unitDataCubit = UnitDataCubit(
      lookups: lookupsCubit.lookups!,
      declarationId: declarationId,
      applicantType: applicantType,
      unitData: unitData,
      unitType: unitType,
      applicantData: applicantData,
      buildingNumber: id,
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: this),
            BlocProvider.value(value: unitDataCubit),
            if (applicantCubit != null)
              BlocProvider.value(value: applicantCubit),
            BlocProvider.value(value: declarationCubit),
            BlocProvider.value(value: lookupsCubit),
          ],
          child: UnitData(
            applicantType: applicantType,
            unitType: unitType,
            otherName: otherName,
            applicantPayload: applicantData,
            mapLocationResult: mapData,
            isUrban: state.isUrban,
            locationData: locationData,
          ),
        ),
      ),
    );
  }

  @override
  Future<void> close() {
    districtOtherController.dispose();
    neighborhoodOtherController.dispose();
    streetOtherController.dispose();
    buildingNumberOtherController.dispose();
    neighborhoodNameController.dispose();
    return super.close();
  }

  void onIsNearestPropertyTapped() {
    emit(state.copyWith(isNearestProperty: !state.isNearestProperty));
  }

  void onIsUrbanTapped() {
    emit(state.copyWith(isUrban: !state.isUrban));
  }

  void setMapData(MapLocationResult? mapData) {
    this.mapData = mapData;
  }
}
