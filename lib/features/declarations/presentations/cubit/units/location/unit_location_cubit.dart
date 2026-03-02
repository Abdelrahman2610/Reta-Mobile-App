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
  }) : super(const UnitLocationState()) {
    fetchGovernorates();
  }

  final UnitType unitType;
  final ApplicantType applicantType;
  final int declarationId;
  final Map<String, dynamic>? locationData;

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
    final governorate = governorates.firstWhere(
      (g) => g.name == locationData!['governorate'],
      orElse: () => DeclarationLookup(id: 0, name: ''),
    );

    if (governorate.id == 0) return;

    await fetchDistricts(governorate.id);

    final district = state.districtsList?.firstWhere(
      (d) => d.name == locationData!['district'],
      orElse: () => DeclarationLookup(id: 0, name: ''),
    );

    if (district != null && district.id != 0) {
      await fetchVillagesAndStreets(district.id);
    }

    selectNeighborhood(locationData!['neighborhood']);
    selectStreet(locationData!['street']);

    emit(
      state.copyWith(
        selectedGovernorate: locationData!['governorate'],
        selectedGovernorateId: governorate.id,
        selectedDistrict: locationData!['district'],
        selectedDistrictId: district?.id,
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
        governorates.add(DeclarationLookup(id: 10, name: 'أخرى'));
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

  List<String> getBuildingNumbers(String? street) {
    if (street == null) return [];
    if (street == kOther) return [kOther];
    return [...List.generate(100, (i) => '${i + 1}'), kOther];
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
        selectedStreet: null,
        selectedBuildingNumber: null,
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
        selectedBuildingNumber: null,
        isBuildingNumberOther: false,
      ),
    );
    if (!isOther) streetOtherController.clear();
  }

  void selectBuildingNumber(String? value) {
    final isOther = value == kOther;
    emit(
      state.copyWith(
        selectedBuildingNumber: value,
        isBuildingNumberOther: isOther,
      ),
    );
    if (!isOther) buildingNumberOtherController.clear();
  }

  /// ---------------------------- Build Payload ----------------------------

  Map<String, dynamic> buildPayload() {
    return {
      'governorate': state.selectedGovernorate,
      'district': state.isDistrictOther
          ? districtOtherController.text.trim()
          : state.selectedDistrict,
      'neighborhood': state.isNeighborhoodOther
          ? neighborhoodOtherController.text.trim()
          : state.selectedNeighborhood,
      'neighborhoodName': neighborhoodNameController.text.trim(),
      'street': state.isStreetOther
          ? streetOtherController.text.trim()
          : state.selectedStreet,
      'buildingNumber': state.isBuildingNumberOther
          ? buildingNumberOtherController.text.trim()
          : state.selectedBuildingNumber,
    };
  }

  Map<String, dynamic> buildLocationPayload() {
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
      'real_estate_id': state.selectedBuildingNumber,
      if (state.isBuildingNumberOther)
        'real_estate_other': buildingNumberOtherController.text.trim(),
    };
  }

  bool validate() => formKey.currentState?.validate() ?? false;

  void onNextButtonTapped(BuildContext context, ApplicantType applicantType) {
    final applicantCubit = context.read<ApplicantCubit>();
    final declarationCubit = context.read<DeclarationCubit>();
    final lookupsCubit = context.read<DeclarationLookupsCubit>();
    final unitDataCubit = UnitDataCubit(
      lookups: lookupsCubit.lookups!,
      declarationId: declarationId,
      applicantType: applicantType,
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: this),
            BlocProvider.value(value: unitDataCubit),
            BlocProvider.value(value: applicantCubit),
            BlocProvider.value(value: declarationCubit),
            BlocProvider.value(value: lookupsCubit),
          ],
          child: UnitData(applicantType: applicantType, unitType: unitType),
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
}
