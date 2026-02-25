import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reta/features/declarations/presentations/cubit/units/unit_location_states.dart';

const String kOther = 'أخرى';

class UnitLocationCubit extends Cubit<UnitLocationState> {
  UnitLocationCubit() : super(const UnitLocationState());

  final formKey = GlobalKey<FormState>();

  /// ------------------ Other text controllers -------------------
  final districtOtherController = TextEditingController();
  final neighborhoodOtherController = TextEditingController();
  final streetOtherController = TextEditingController();
  final buildingNumberOtherController = TextEditingController();
  final neighborhoodNameController = TextEditingController();

  /// ----------------------- Mock Data -----------------------------

  final List<String> governorates = [
    'القاهرة',
    'الجيزة',
    'الإسكندرية',
    'الدقهلية',
    'دمياط',
  ];

  List<String> getDistricts(String? governorate) {
    if (governorate == null) return [];
    if (governorate == kOther) return [kOther];
    const mock = {
      'القاهرة': [
        'مأمورية وسط القاهرة',
        'مأمورية شرق القاهرة',
        'مأمورية غرب القاهرة',
      ],
      'الجيزة': ['مأمورية الجيزة', 'مأمورية أكتوبر'],
      'الإسكندرية': ['مأمورية شرق الإسكندرية', 'مأمورية وسط الإسكندرية'],
      'الدقهلية': ['مأمورية المنصورة', 'مأمورية طلخا'],
      'دمياط': ['مأمورية دمياط', 'مأمورية رأس البر'],
    };
    return [...(mock[governorate] ?? []), kOther];
  }

  List<String> getNeighborhoods(String? district) {
    if (district == null) return [];
    if (district == kOther) return [kOther];
    const mock = {
      'مأمورية وسط القاهرة': [
        'شياخة الأزهر',
        'شياخة الدرب الأحمر',
        'شياخة الموسكي',
      ],
      'مأمورية شرق القاهرة': ['شياخة النزهة', 'شياخة مصر الجديدة'],
      'مأمورية غرب القاهرة': ['شياخة إمبابة', 'شياخة بولاق'],
      'مأمورية الجيزة': ['شياخة الدقي', 'شياخة المهندسين'],
      'مأمورية أكتوبر': ['شياخة أكتوبر الأولى', 'شياخة أكتوبر الثانية'],
    };

    return [...(mock[district] ?? []), kOther];
  }

  List<String> getStreets(String? neighborhood) {
    if (neighborhood == null) return [];
    if (neighborhood == kOther) return [kOther];
    const mock = {
      'شياخة الأزهر': ['شارع الأزهر', 'شارع الجيش'],
      'شياخة الدرب الأحمر': ['شارع الدرب الأحمر', 'شارع الخليفة'],
      'شياخة الموسكي': ['شارع الموسكي', 'شارع الغورية'],
      'شياخة النزهة': ['شارع النزهة', 'شارع الطيران'],
      'شياخة مصر الجديدة': ['شارع الحجاز', 'شارع الميرغني'],
    };
    return [...(mock[neighborhood] ?? []), kOther];
  }

  List<String> getBuildingNumbers(String? street) {
    if (street == null) return [];
    if (street == kOther) return [kOther];
    return ['1', '2', '3', '4', '5', '10', '15', '20', kOther];
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

  void selectGovernorate(String? value) {
    emit(UnitLocationState(selectedGovernorate: value));
  }

  void selectDistrict(String? value) {
    final isOther = value == kOther;
    emit(
      state.copyWith(
        selectedDistrict: value,
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
  }

  void selectNeighborhood(String? value) {
    final isOther = value == kOther;
    emit(
      state.copyWith(
        selectedNeighborhood: value,
        isNeighborhoodOther: isOther,
        selectedStreet: 'null',
        selectedBuildingNumber: 'null',
        isStreetOther: false,
        isBuildingNumberOther: false,
      ),
    );
    if (!isOther) neighborhoodOtherController.clear();
  }

  void selectStreet(String? value) {
    final isOther = value == kOther;
    emit(
      state.copyWith(
        selectedStreet: value,
        isStreetOther: isOther,
        selectedBuildingNumber: 'null',
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

  bool validate() => formKey.currentState?.validate() ?? false;

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
