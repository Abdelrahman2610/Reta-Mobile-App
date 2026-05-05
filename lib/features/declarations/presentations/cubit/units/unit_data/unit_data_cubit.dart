import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reta/core/helpers/extensions/unit_type.dart';
import 'package:reta/core/network/api_constants.dart';
import 'package:reta/features/declarations/data/models/declaration_model.dart';
import 'package:reta/features/declarations/data/models/map_location_result.dart';
import 'package:uuid/uuid.dart';

import '../../../../../../core/helpers/app_enum.dart';
import '../../../../../../core/helpers/extensions/applicant_type.dart';
import '../../../../../../core/network/api_result.dart';
import '../../../../../../core/network/dio_client.dart';
import '../../../../../../core/services/declaration_service.dart';
import '../../../../../../core/services/upload_service.dart';
import '../../../../data/models/additional_document.dart';
import '../../../../data/models/declarations_lookups.dart';
import '../../../../data/models/facility_building_info.dart';
import '../../../../data/models/hotel_building_info.dart';
import '../../../../data/models/hotel_sub_unit.dart';
import '../../../../data/models/industrial_building.dart';
import '../../../../data/models/petro_building.dart';
import '../../../../data/models/production_building.dart';
import '../../../../data/models/vacant_land_item.dart';
import '../../../pages/select_types_of_properties_page.dart';
import '../../applicant_cubit.dart';
import '../../declaration/declaration_cubit.dart';
import '../../declaration_lookups_cubit.dart';
import '../location/unit_location_cubit.dart';
import 'unit_data_state.dart';

const String kYes = 'نعم';
const String kNo = 'لا';

class UnitDataCubit extends Cubit<UnitDataState> {
  UnitDataCubit({
    required this.lookups,
    required this.declarationId,
    required this.applicantType,
    this.unitData,
    this.applicantData,
    this.propertyTypeIdValue,
    required this.unitType,
    this.ministryBurden,
    required this.buildingNumber,
  }) : super(UnitDataState(vacantLandItems: [VacantLandItem()])) {
    fetchBuildingFloorNumber(buildingNumber);
    initUnitData();
    ensureSingleExempt();
  }

  final int? propertyTypeIdValue;
  final DeclarationLookupsModel lookups;
  final int declarationId;
  final ApplicantType applicantType;
  final Map<String, dynamic>? unitData;
  final Map<String, dynamic>? applicantData;
  final UnitType unitType;
  final int buildingNumber;

  final formKey = GlobalKey<FormState>();
  final _uuid = const Uuid();

  // ─────────────────────────────────────────
  // Shared Controllers -
  // ─────────────────────────────────────────
  final floorNumberOtherController = TextEditingController();
  final floorNumberController = TextEditingController();
  final unitNumberOtherController = TextEditingController();
  final unitNumberController = TextEditingController();
  final unitCodeController = TextEditingController();
  final marketValueController = TextEditingController();
  final lawNumberController = TextEditingController();
  final lawYearController = TextEditingController();
  final areaController = TextEditingController();

  // ─────────────────────────────────────────
  // Controllers - تركيبات ثابتة
  // ─────────────────────────────────────────
  final installationOwnerController =
      TextEditingController(); // اسم مالك التركيب
  final contractStartDateController =
      TextEditingController(); // تاريخ بداية التعاقد
  final contractEndDateController =
      TextEditingController(); // تاريخ نهاية التعاقد
  final annualRentalValueController =
      TextEditingController(); // القيمة الإيجارية السنوية
  final otherInstallationTypeController =
      TextEditingController(); // نوع التركيب الآخر

  // ─────────────────────────────────────────
  // Controllers - أراضي فضاء مستغلة
  // ─────────────────────────────────────────
  final totalLandAreaController = TextEditingController(); // مساحة الأرض الكلية
  final exploitedAreaController = TextEditingController(); // المساحة المستغلة
  final otherExploitationTypeController =
      TextEditingController(); // نوع الاستغلال الآخر

  // ─────────────────────────────────────────
  // Controllers - منشآت مشتركة
  // ─────────────────────────────────────────
  final facilityNameController = TextEditingController(); // اسم المنشأة
  final facilityRoomCountController = TextEditingController(); // عدد الغرف
  final facilityCodeController = TextEditingController(); // كود حساب المنشأة
  final activityTypeController = TextEditingController(); // نوع النشاط
  final facilityMarketValueController =
      TextEditingController(); // القيمة السوقية للمنشأة
  final totalBuildingAreaController = TextEditingController();

  // ─────────────────────────────────────────
  // Controllers - منشآت فندقية
  // ─────────────────────────────────────────
  final operatingLicenseDateController =
      TextEditingController(); // تاريخ تراخيص التشغيل

  // ─────────────────────────────────────────
  // Controllers - منشآت صناعية / إنتاجية
  // ─────────────────────────────────────────
  final totalLandAreaFacilityController = TextEditingController();
  final exploitedLandAreaController = TextEditingController();
  final landMarketValueController = TextEditingController();
  final bool? ministryBurden;

  // ─────────────────────────────────────────
  // Controllers - منشآت بترولية
  // ─────────────────────────────────────────
  final usageTypeController = TextEditingController(); // نوع الاستخدام
  final totalLandArea = TextEditingController();
  final totalLandUtilized = TextEditingController();
  final bookValueController = TextEditingController(); // التكلفة الدفترية للأرض
  final petroleumFacilityNameController =
      TextEditingController(); // اسم المنشأة

  // ─────────────────────────────────────────
  // Controllers - منشآت الإنتاجية
  // ─────────────────────────────────────────
  final productionUsageTypeController = TextEditingController(); // نوع النشاط
  final productionFacilityNameController =
      TextEditingController(); // اسم المنشأة

  // ─────────────────────────────────────────
  // Dynamic Lists
  // ─────────────────────────────────────────
  final List<AdditionalDocument> additionalDocuments = [];
  final List<ServiceFacilityBuildingInfo> facilityBuildings = [
    ServiceFacilityBuildingInfo(id: '1'),
  ];
  final List<HotelBuildingInfo> hotelBuildings = [HotelBuildingInfo(id: '1')];
  final List<IndustrialBuilding> industrialBuildings = [IndustrialBuilding()];
  final List<PetroBuilding> petroBuildings = [PetroBuilding()];
  final List<ProductionBuilding> productionBuildings = [ProductionBuilding()];

  bool canSubmitSingleExempt = true;

  Future<void> ensureSingleExempt() async {
    if (unitType == UnitType.residential) {
      final result = await safeApiCall(() async {
        final response = await DioClient.instance.dio.get(
          ApiConstants.ensureSingleExempt(declarationId),
        );
        if (response.data != '') {
          final status = response.data['status'];
          return status;
        } else {
          return true;
        }
      });

      switch (result) {
        case ApiSuccess(:final data):
          // canSubmitSingleExempt = true;
          canSubmitSingleExempt = data;
          emit(state.copyWith(isLoading: false));
        case ApiError(:final message):
          canSubmitSingleExempt = false;
          emit(state.copyWith(isLoading: false));
      }
    }
  }

  // ─────────────────────────────────────────
  // Real and Mock Data
  // ─────────────────────────────────────────
  void initUnitData() {
    if (unitData == null) return;

    _initBaseUnitData();

    switch (unitType) {
      case UnitType.residential:
        _initResidentialData();
        break;
      case UnitType.commercial:
      case UnitType.administrative:
      case UnitType.serviceUnit:
        _initCommercialData();
        break;
      case UnitType.fixedInstallations:
        _initFixedInstallationsData();
        break;
      case UnitType.vacantLand:
        _initVacantLandData();
        break;
      case UnitType.serviceFacility:
        _initFacilityData();
        break;
      case UnitType.productionFacility:
        _initProductionData();
        break;
      case UnitType.industrialFacility:
        _initIndustrialData();
        break;
      case UnitType.hotelFacility:
        _initHotelData();
        break;
      case UnitType.petroleumFacility:
        _initPetroleumData();
        break;
      case UnitType.minesAndQuarries:
        break;
    }
  }

  Future<void> _initBaseUnitData() async {
    // await fetchBuildingFloorNumber(buildingNumber);

    int floorId = int.parse(unitData?['real_estate_floor_id'] ?? '0');
    String floorText = lookups.realEstateFloors
        .firstWhere(
          (a) => a.id == floorId,
          orElse: () => DeclarationLookup(id: -1, name: kOther),
        )
        .name;

    final floorOther = unitData!['real_estate_floor_other_text'];
    floorNumberOtherController.text = floorOther ?? '';
    bool isFloorOther = floorOther != null;
    if (unitType == UnitType.hotelFacility) {
      isFloorOther =
          unitData!['real_estate_floor_id'] == -1 ||
          (floorText != kOther && !floorNumbers.contains(floorText));
    }

    unitNumberOtherController.text = unitData!['unit_number'] ?? '';
    await fetchBuildingUnitNumber(buildingNumber, floorId);
    final unitId = int.parse(unitData!['unit_id']?.toString() ?? '-1');
    final unitOther = unitData!['unit_other'];
    final isUnitOther = unitOther != null;

    unitCodeController.text = unitData!['account_code'] ?? '';

    areaController.text = unitData!['area']?.toString() ?? '';

    marketValueController.text = unitData!['market_value']?.toString() ?? '';

    final retaContact = unitData!['reta_contact_about_unit'];

    final ownershipDeedMap = unitData!.containsKey('ownership_deed')
        ? unitData!['ownership_deed']
        : unitData!.containsKey('land_ownership_legal_document')
        ? unitData!['land_ownership_legal_document']
        : unitData!['facility_ownership_deed'];
    final ownershipDeed = ownershipDeedMap;

    String selectedFloorNumberOther = lookups.realEstateFloors.first.name;

    if (isFloorOther) {
      selectedFloorNumberOther = lookups.realEstateFloors
          .firstWhere(
            (real) =>
                real.id ==
                (floorOther.runtimeType == String
                    ? int.parse(floorOther)
                    : floorOther),
            orElse: () => DeclarationLookup(id: 0, name: ''),
          )
          .name;
      emit(state.copyWith(selectedFloorNumberOther: selectedFloorNumberOther));
    }

    final unitNumber = state.buildingUnitList
        .firstWhere(
          (element) => element.id == unitId,
          orElse: () => DeclarationLookup(id: -1, name: 'أخرى'),
        )
        .name;
    final leaseContract = unitData!['lease_contract'];
    additionalDocuments.clear();
    unitData!['supporting_documents'].forEach(
      (element) =>
          additionalDocuments.add(AdditionalDocument.fromJson(element)),
    );

    emit(
      state.copyWith(
        additionalDocuments: additionalDocuments,
        selectedFloorNumber: isFloorOther ? 'أخرى' : floorText,
        isFloorNumberOther: isFloorOther,
        selectedUnitNumber: isUnitOther ? 'أخرى' : unitNumber,
        isUnitNumberOther: isUnitOther,
        contactedTaxAuthority: retaContact == 1 ? true : false,
        hasAdditionalDocuments:
            unitData!['submit_other_supporting_documents'] == 1,
        ownershipDeedFilePath: ownershipDeed?['url'],
        ownershipDeedOriginalName: ownershipDeed?['original_file_name'],
        ownershipDeedFullUrl: ownershipDeed?['full_url'],
        leaseContractFullUrl: leaseContract != null
            ? leaseContract['full_url']
            : null,
      ),
    );

    // controllers
    // if (isFloorOther) floorNumberOtherController.text = floorOther ?? '';
    // if (isUnitOther) unitNumberOtherController.text = unitOther ?? '';
  }

  void _initResidentialData() {
    final unitTypeText = unitData!['unit_type_text'];

    final attachmentIds = List<int>.from(unitData!['attachments'] ?? []);
    final selectedAmenityNames = attachmentIds
        .map((id) {
          return lookups.unitAttachments
              .firstWhere(
                (a) => a.id == id,
                orElse: () => DeclarationLookup(id: 0, name: ''),
              )
              .name;
        })
        .where((name) => name.isNotEmpty)
        .toList();

    final accountCode = (unitData!['account_code'] ?? '').toString();
    unitCodeController.text = accountCode;
    final contactTaxAuthority = unitData!['reta_contact_about_unit'] == 1
        ? true
        : false;
    marketValueController.text = (unitData!['market_value'] ?? '').toString();
    areaController.text = (unitData!['area'] ?? '').toString();

    emit(
      state.copyWith(
        isExempt: unitData!['exempted_as_residence'],
        selectedUnitSubType: unitTypeText,
        selectedAmenities: selectedAmenityNames,
        contactedTaxAuthority: contactTaxAuthority,
      ),
    );
  }

  void _initCommercialData() {
    activityTypeController.text = unitData!['activity_type'] ?? '';

    final leaseContract = unitData!['lease_contract'];
    final permitPhoto = unitData!['license_photo'];
    final exemptionReason = lookups.exemptionReasons
        .firstWhere(
          (t) => t.id == unitData!['exemption_reason'],
          orElse: () => DeclarationLookup(id: -1, name: ''),
        )
        .name;
    ;

    emit(
      state.copyWith(
        isExempt: unitData!['exempted'],
        selectedExemptionReason: exemptionReason,
      ),
    );

    if (leaseContract != null) {
      emit(
        state.copyWith(
          leaseContractFilePath: leaseContract['url'],
          leaseContractOriginalName: leaseContract['original_file_name'],
          leaseContractFullUrl: leaseContract['full_url'],
        ),
      );
    }

    if (permitPhoto != null) {
      emit(
        state.copyWith(
          permitPhotoFilePath: permitPhoto['url'],
          permitPhotoOriginalName: permitPhoto['original_file_name'],
          permitPhotoFullUrl: permitPhoto['full_url'],
        ),
      );
    }
  }

  void _initFixedInstallationsData() {
    final installationId = unitData!['installation_type_id'];
    final installationType = lookups.installationTypes.firstWhere(
      (t) =>
          t.id ==
          ((installationId.runtimeType == String)
              ? int.parse(installationId)
              : installationId),
      orElse: () => DeclarationLookup(id: 0, name: ''),
    );
    installationOwnerController.text =
        unitData!['installation_owner_name'] ?? '';
    contractStartDateController.text = unitData!['contract_start'] ?? '';
    contractEndDateController.text = unitData!['contract_end'] ?? '';
    annualRentalValueController.text =
        unitData!['annual_rental_value']?.toString() ?? '';
    otherInstallationTypeController.text =
        unitData!['installation_type_other'] ?? '';

    fixedInstallationNumberController.text =
        unitData!['fixed_installation_number'] ?? '';

    bool isTaxpayerOwner = unitData!['is_taxpayer_owner_of_installation'] == 1
        ? true
        : false;

    emit(
      state.copyWith(
        isTaxpayerOwner: isTaxpayerOwner,
        selectedInstallationType: installationType.name.isNotEmpty
            ? installationType.name
            : null,
      ),
    );
  }

  void _initVacantLandData() {
    totalLandAreaController.text =
        unitData!['total_land_area']?.toString() ?? '';

    final vacantLandsData = unitData!['vacantLands'] as List? ?? [];

    if (vacantLandsData.isNotEmpty) {
      // dispose الـ default item
      for (final item in state.vacantLandItems) {
        item.dispose();
      }

      final items = vacantLandsData.map((vl) {
        final item = VacantLandItem();

        item.usedLandAreaController.text =
            vl['used_land_area']?.toString() ?? '';
        item.accountCodeController.text = vl['account_code']?.toString() ?? '';
        item.marketValueController.text = vl['market_value']?.toString() ?? '';
        item.retaContactAboutUnit = vl['reta_contact_about_unit'] == 1;

        // نوع الاستغلال من الـ lookups
        final exploitationTypeId = vl['exploitation_type_id'];
        final exploitationType = lookups.exploitationTypes.firstWhere(
          (t) => t.id == exploitationTypeId,
          orElse: () => DeclarationLookup(id: -1, name: ''),
        );
        item.selectedExploitationType = exploitationType.name.isNotEmpty
            ? exploitationType.name
            : null;

        item.otherExploitationTypeController.text =
            vl['exploitation_type_other'] ?? '';

        return item;
      }).toList();

      emit(state.copyWith(vacantLandItems: items));
    }

    final ownershipDocMap =
        unitData!.containsKey('land_ownership_legal_document')
        ? unitData!['land_ownership_legal_document']
        : unitData!['ownership_deed'];
    final ownershipDoc = ownershipDocMap;
    final leaseAgreement = unitData!['land_lease_agreement'];

    emit(
      state.copyWith(
        ownershipDeedFilePath: ownershipDoc?['url'],
        ownershipDeedOriginalName: ownershipDoc?['original_file_name'],
        ownershipDeedFullUrl: ownershipDoc?['full_url'],

        leaseContractFilePath: leaseAgreement?['url'],
        leaseContractOriginalName: leaseAgreement?['original_file_name'],
        leaseContractFullUrl: leaseAgreement?['full_url'],

        hasAdditionalDocuments:
            unitData!['submit_other_supporting_documents'] == 1,
      ),
    );
  }

  void _initFacilityData() {
    facilityNameController.text = unitData!['facility_name'] ?? '';
    activityTypeController.text = unitData!['activity_type'] ?? '';
    totalLandAreaFacilityController.text =
        unitData!['total_land_area']?.toString() ?? '';
    unitCodeController.text = unitData!['account_code'] ?? '';
    marketValueController.text = unitData!['market_value']?.toString() ?? '';
    lawNumberController.text = unitData!['law_number'] ?? '';
    lawYearController.text = unitData!['law_year']?.toString() ?? '';

    // final facilityTypeId = unitData!['facility_type_id'];
    // String? facilityTypeName;
    // if (facilityTypeId != null) {
    //   final found = lookups.serviceFacilityTypes.firstWhere(
    //     (t) => t.id == facilityTypeId,
    //     orElse: () => DeclarationLookup(id: -1, name: ''),
    //   );
    //   facilityTypeName = found.id == -1 ? null : found.name;
    // }

    final buildingsData = unitData!['buildings'] as List? ?? [];
    if (buildingsData.isNotEmpty) {
      for (final b in facilityBuildings) {
        b.dispose();
      }
      facilityBuildings.clear();
      for (final b in buildingsData) {
        final bMap = b as Map<String, dynamic>;
        final building = ServiceFacilityBuildingInfo(
          id: _uuid.v4(),
          mapLocationResult: MapLocationResult.fromMap(bMap),
          isNearestProperty: bMap['is_nearest_property'] == 1,
        );
        building.floorsCount = bMap['floors_count'] ?? 1;
        building.areaController.text = bMap['building_area']?.toString() ?? '';
        building.knownBuildingNumber.text =
            bMap['known_build_num']?.toString() ?? '';
        facilityBuildings.add(building);
      }
    }

    final exemptionReasonId = unitData!['exemption_reason'];
    final exemptionReasonName = exemptionReasonId != null
        ? lookups.exemptionReasons
              .firstWhere(
                (e) => e.id == exemptionReasonId,
                orElse: () => DeclarationLookup(id: -1, name: ''),
              )
              .name
        : null;

    // ---------------------------- Files ----------------------------
    final ownershipDeed = unitData!['facility_ownership_deed'];
    final leaseContracts = unitData!['facility_lease_contracts'];
    final buildingPermits = unitData!['building_permits'];
    final operatingLicenses = unitData!['operating_licenses'];

    _updateTotalBuildingArea();
    emit(
      state.copyWith(
        buildingsCount: facilityBuildings.length,
        isExempt: unitData!['exempted'] ?? false,
        selectedExemptionReason: exemptionReasonName,
        // selectedFacilityActivity: facilityTypeName,
        contactedTaxAuthority: unitData!['reta_contact_about_unit'] == 1,
        hasAdditionalDocuments:
            unitData!['submit_other_supporting_documents'] == 1,

        ownershipDeedFilePath: ownershipDeed?['url'],
        ownershipDeedOriginalName: ownershipDeed?['original_file_name'],
        ownershipDeedFullUrl: ownershipDeed?['full_url'],

        leaseContractFilePath: leaseContracts?['url'],
        leaseContractOriginalName: leaseContracts?['original_file_name'],
        leaseContractFullUrl: leaseContracts?['full_url'],

        constructionLicenseFilePath: buildingPermits?['url'],
        constructionLicenseOriginalName: buildingPermits?['original_file_name'],
        constructionLicenseFullUrl: buildingPermits?['full_url'],

        operatingLicenseFilePath: operatingLicenses?['url'],
        operatingLicenseOriginalName: operatingLicenses?['original_file_name'],
        operatingLicenseFullUrl: operatingLicenses?['full_url'],
      ),
    );
  }

  void _initProductionData() {
    productionFacilityNameController.text = unitData!["facility_name"] ?? "";
    productionUsageTypeController.text = unitData!["activity_type"] ?? "";
    totalLandArea.text = unitData!["total_land_area"]?.toString() ?? "";
    totalLandUtilized.text = unitData!["used_land_area"]?.toString() ?? "";
    bookValueController.text = unitData!["market_value"]?.toString() ?? "";
    unitCodeController.text = unitData!["account_code"] ?? "";

    final burdenActivityId = unitData!["burden_activity_id"];
    String? burdenActivityText;
    if (burdenActivityId != null) {
      final found = lookups.productionBurdenActivityTypes.firstWhere(
        (b) => b.id == int.tryParse(burdenActivityId.toString()),
        orElse: () => DeclarationLookup(id: -1, name: ""),
      );
      burdenActivityText = found.id == -1 ? null : found.name;
    }

    final buildingsData = unitData!["buildings"] as List? ?? [];
    if (buildingsData.isNotEmpty) {
      for (final b in productionBuildings) {
        b.dispose();
      }
      productionBuildings.clear();
      for (final b in buildingsData) {
        final building = ProductionBuilding();
        building.initFromMap(b as Map<String, dynamic>, lookups.buildingTypes);
        productionBuildings.add(building);
      }
    }

    final constructionLicense = unitData!["construction_license"];
    final operationLicense = unitData!["operation_license"];
    final allocationContract = unitData!["allocation_contract"];

    emit(
      state.copyWith(
        productionBuildingsCount: productionBuildings.length,
        isExempt:
            unitData!["ministry_burden"] == true ||
            unitData!["ministry_burden"] == 1,
        selectedBurdenActivity: burdenActivityText,
        contactedTaxAuthority: unitData!["reta_contact_about_unit"] == 1,
        hasAdditionalDocuments:
            unitData!["submit_other_supporting_documents"] == 1,
        constructionLicenseFilePath: constructionLicense?["url"],
        constructionLicenseOriginalName:
            constructionLicense?["original_file_name"],
        constructionLicenseFullUrl: constructionLicense?["full_url"],
        operationLicenseFilePath: operationLicense?["url"],
        operationLicenseOriginalName: operationLicense?["original_file_name"],
        operationLicenseFullUrl: operationLicense?["full_url"],
        allocationContractFilePath: allocationContract?["url"],
        allocationContractOriginalName:
            allocationContract?["original_file_name"],
        allocationContractFullUrl: allocationContract?["full_url"],
      ),
    );
  }

  void _initHotelData() {
    facilityNameController.text = unitData!['trade_name'] ?? '';
    operatingLicenseDateController.text = unitData!['license_date'] ?? '';

    final viewTypeId = unitData!['view_type_id'];
    String? viewText;
    if (viewTypeId != null) {
      final found = lookups.hotelViewTypes.firstWhere(
        (v) => v.id == int.parse(viewTypeId),
        orElse: () => DeclarationLookup(id: -1, name: ''),
      );
      viewText = found.id == -1 ? null : found.name;
    }

    final starRatingId = unitData!['star_rating_id'];
    String? starText;
    if (starRatingId != null) {
      final found = lookups.starRatings.firstWhere(
        (s) => s.id == int.parse(starRatingId),
        orElse: () => DeclarationLookup(id: -1, name: ''),
      );
      starText = found.id == -1 ? null : found.name;
    }

    final constructionLicense = unitData!['copy_of_the_construction_permits'];
    final operatingLicense = unitData!['copy_of_the_operating_licenses'];
    final starCertificate = unitData!['certificate_of_stardom_level'];

    facilityRoomCountController.text =
        unitData!['rooms_count']?.toString() ?? '';
    emit(
      state.copyWith(
        selectedHotelView: viewText,
        selectedStarRating: starText,
        buildingsCount:
            int.tryParse(unitData!['buildings_count']?.toString() ?? '') ?? 1,
        hasSubUnits: unitData!['has_sub_units'] == 1,
        constructionLicenseFilePath: constructionLicense?['url'],
        constructionLicenseOriginalName:
            constructionLicense?['original_file_name'],
        constructionLicenseFullUrl: constructionLicense?['full_url'],
        constructionLicenseFileId: constructionLicense?['field_name'],

        operatingLicenseFilePath: operatingLicense?['url'],
        operatingLicenseOriginalName: operatingLicense?['original_file_name'],
        operatingLicenseFullUrl: operatingLicense?['full_url'],

        starCertificateFilePath: starCertificate?['url'],
        starCertificateOriginalName: starCertificate?['original_file_name'],
        starCertificateFullUrl: starCertificate?['full_url'],

        contactedTaxAuthority: unitData!['reta_contact_about_unit'] == 1,
        hasAdditionalDocuments:
            unitData!['submit_other_supporting_documents'] == 1,
      ),
    );

    List<HotelSubUnit> hotelSubUnits = [];
    final buildingsData = unitData!['buildings'] as List? ?? [];
    if (buildingsData.isNotEmpty) {
      for (final b in hotelBuildings) {
        b.dispose();
      }

      hotelBuildings.clear();
      for (int i = 0; i < buildingsData.length; i++) {
        final bData = buildingsData[i] as Map<String, dynamic>;
        final building = HotelBuildingInfo(
          id: bData['id'].toString(),
          mapLocationResult: MapLocationResult.fromMap(bData),
          isNearestProperty: bData['is_nearest_property'] == 1,
        );
        building.knownBuildingNumber.text =
            bData['known_build_num']?.toString() ?? '';
        building.floorsCount =
            int.tryParse(bData['floors_number']?.toString() ?? '') ?? 1;
        building.roomsCount =
            int.tryParse(bData['rooms_number']?.toString() ?? '') ?? 1;
        hotelBuildings.add(building);
      }

      final subUnitsData = unitData!['hotelUnits'] as List? ?? [];
      for (final u in subUnitsData) {
        // final unit = HotelSubUnit();
        // unit.initFromMap(u as Map<String, dynamic>, lookups.realEstateFloors);
        final unit = HotelSubUnit.fromMap(
          u as Map<String, dynamic>,
          lookups.realEstateFloors,
        );
        // building.hotelUnits.add(unit);
        hotelSubUnits.add(unit);
      }

      emit(
        state.copyWith(
          hotelSubUnits: hotelSubUnits,
          buildingsCount: hotelBuildings.length,
          hotelSubUnitsUpdateCount: state.hotelSubUnitsUpdateCount + 1,
        ),
      );
    } else {
      final subUnitsData = unitData!['hotelUnits'] as List? ?? [];
      if (subUnitsData.isNotEmpty && hotelBuildings.isNotEmpty) {
        for (final u in subUnitsData) {
          // final unit = HotelSubUnit();
          // unit.fromMap(u as Map<String, dynamic>, lookups.realEstateFloors);
          final unit = HotelSubUnit.fromMap(
            u as Map<String, dynamic>,
            lookups.realEstateFloors,
          );
          // hotelBuildings.first.hotelUnits.add(unit);
          hotelSubUnits.add(unit);
        }
        emit(
          state.copyWith(
            hotelSubUnits: hotelSubUnits,
            hotelSubUnitsUpdateCount: state.hotelSubUnitsUpdateCount + 1,
          ),
        );
      }
    }
  }

  void _initIndustrialData() {
    facilityNameController.text = unitData!['facility_name'] ?? '';
    activityTypeController.text = unitData!['activity_type'] ?? '';
    totalLandAreaFacilityController.text =
        unitData!['total_land_area']?.toString() ?? '';
    exploitedLandAreaController.text =
        unitData!['used_land_area']?.toString() ?? '';
    landMarketValueController.text =
        unitData!['market_value']?.toString() ?? '';
    unitCodeController.text = unitData!['account_code'] ?? '';

    // burden_activity_id → display text
    String? burdenActivityText;
    final burdenActivityId = unitData!['burden_activity_id'];
    if (burdenActivityId != null) {
      final found = lookups.burdenActivityTypes.firstWhere(
        (b) => b.id == int.parse(burdenActivityId),
        orElse: () => DeclarationLookup(id: -1, name: ''),
      );
      burdenActivityText = found.id == -1 ? null : found.name;
    }

    // buildings
    final buildingsData = unitData!['buildings'] as List? ?? [];
    if (buildingsData.isNotEmpty) {
      for (final b in industrialBuildings) {
        b.dispose();
      }
      industrialBuildings.clear();
      for (final b in buildingsData) {
        final building = IndustrialBuilding();
        building.initFromMap(b as Map<String, dynamic>, lookups.buildingTypes);
        industrialBuildings.add(building);
      }
    }

    // files
    final constructionLicense = unitData!['construction_license'];
    final operationLicense = unitData!['operation_license'];
    final allocationContract = unitData!['allocation_contract'];
    final ministryBurdenVal = unitData!['ministry_burden'];

    emit(
      state.copyWith(
        ministryBurden: ministryBurdenVal == true || ministryBurdenVal == 1,
        selectedBurdenActivity: burdenActivityText,
        contactedTaxAuthority: unitData!['reta_contact_about_unit'] == 1,
        hasAdditionalDocuments:
            unitData!['submit_other_supporting_documents'] == 1,
        industrialBuildingsCount: industrialBuildings.length,
        constructionLicenseFilePath: constructionLicense?['url'],
        constructionLicenseUrl: constructionLicense?['url'],
        constructionLicenseOriginalName:
            constructionLicense?['original_file_name'],
        constructionLicenseFullUrl: constructionLicense?['full_url'],
        constructionLicenseFileId: constructionLicense?['field_name'],

        operatingLicenseFilePath: operationLicense?['url'],
        operatingLicenseOriginalName: operationLicense?['original_file_name'],
        operatingLicenseFullUrl: operationLicense?['full_url'],

        allocationContractFilePath: allocationContract?['url'],
        allocationContractOriginalName:
            allocationContract?['original_file_name'],
        allocationContractFullUrl: allocationContract?['full_url'],
      ),
    );
  }

  void _initPetroleumData() {
    petroleumFacilityNameController.text = unitData!['facility_name'] ?? '';
    usageTypeController.text = unitData!['usage_type'] ?? '';
    totalLandArea.text = unitData!['total_land_area']?.toString() ?? '';
    totalLandUtilized.text = unitData!['used_land_area']?.toString() ?? '';
    bookValueController.text = unitData!['land_book_value']?.toString() ?? '';
    unitCodeController.text = unitData!['account_code'] ?? '';

    final buildingsData = unitData!['buildings'] as List? ?? [];
    if (buildingsData.isNotEmpty) {
      for (final b in petroBuildings) {
        b.dispose();
      }
      petroBuildings.clear();
      for (final b in buildingsData) {
        final building = PetroBuilding();
        building.initFromMap(b as Map<String, dynamic>, lookups.buildingTypes);
        petroBuildings.add(building);
      }
    }

    final constructionLicense = unitData!['construction_license'];
    final openingBudget = unitData!['opening_budget'];
    final allBookValue = unitData!['all_book_value'];

    emit(
      state.copyWith(
        petroBuildingsCount: petroBuildings.length,
        contactedTaxAuthority: unitData!['reta_contact_about_unit'] == 1,
        hasAdditionalDocuments:
            unitData!['submit_other_supporting_documents'] == 1,
        constructionLicenseFilePath: constructionLicense?['url'],
        constructionLicenseOriginalName:
            constructionLicense?['original_file_name'],
        constructionLicenseFullUrl: constructionLicense?['full_url'],
        openingBudgetFilePath: openingBudget?['url'],
        openingBudgetOriginalName: openingBudget?['original_file_name'],
        openingBudgetFullUrl: openingBudget?['full_url'],
        allBookBValueFilePath: allBookValue?['url'],
        allBookBValueOriginalName: allBookValue?['original_file_name'],
        allBookBValueFullUrl: allBookValue?['full_url'],
      ),
    );
  }

  List<String> get residentialUnitTypes =>
      lookups.residentialUnitTypes.map((e) => e.name).toList();

  List<String> get amenities =>
      lookups.unitAttachments.map((e) => e.name).toList();

  List<String> get floorNumbers => [
    ...lookups.realEstateFloors.map((e) => e.name),
    'أخرى',
  ];

  Future<void> fetchBuildingFloorNumber(int? buildingNumber) async {
    await Future.delayed(const Duration(milliseconds: 100));
    emit(state.copyWith(isFloorLoading: true));
    final result = await safeApiCall(() async {
      final response = await DioClient.instance.dio.get(
        '${ApiConstants.realEstateFloors}?realEstateId=$buildingNumber',
      );
      final list = response.data['data'] as List;
      return list.map((e) => DeclarationLookup.fromJson(e)).toList();
    });

    switch (result) {
      case ApiSuccess(:final data):
        if (unitData != null) {
          final currentFloor = unitData!['real_estate_floor_text'];
          final floorExists =
              currentFloor == null || data.any((f) => f.name == currentFloor);
          emit(
            state.copyWith(
              buildingFloorList: data,
              isFloorLoading: false,
              selectedFloorNumber: floorExists ? currentFloor : null,
            ),
          );
        } else {
          emit(state.copyWith(buildingFloorList: data, isFloorLoading: false));
        }
      case ApiError(:final message):
        emit(state.copyWith(isFloorLoading: false));
    }
  }

  List<DeclarationLookup> removeDuplicates(List<DeclarationLookup> items) {
    final seenNames = <String>{};

    return items.where((item) {
      return seenNames.add(item.name); // add returns false if already exists
    }).toList();
  }

  Future<void> fetchBuildingUnitNumber(
    dynamic buildingNumber,
    dynamic floorId, {
    bool loading = true,
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));
    if (loading) {
      emit(state.copyWith(isFloorLoading: true));
    }

    final result = await safeApiCall(() async {
      final response = await DioClient.instance.dio.get(
        ApiConstants.unitsByRealEstate(buildingNumber, floorId),
      );
      final list = response.data['data'] as List;
      return removeDuplicates(
        list.map((e) => DeclarationLookup.fromJson(e)).toList(),
      );
    });

    switch (result) {
      case ApiSuccess(:final data):
        String? currentUnit = state.selectedUnitNumber;
        if (unitData != null) {
          currentUnit = unitData!['unit_unit_num'];
        }

        final unitExists =
            currentUnit == null || data.any((f) => f.name == currentUnit);
        emit(
          state.copyWith(
            buildingUnitList: data,
            isFloorLoading: false,
            selectedUnitNumber: unitExists ? currentUnit : null,
            isUnitNumberOther: !unitExists,
          ),
        );
      case ApiError(:final message):
        emit(state.copyWith(isFloorLoading: false));
    }
  }

  List<String> get exemptionReasons =>
      lookups.exemptionReasons.map((e) => e.name).toList();

  List<String> get installationTypes =>
      lookups.installationTypes.map((e) => e.name).toList();

  final List<String> yesNoOptions = [kYes, kNo];

  final List<String> buildingTypes = [
    'منشآت معدنية',
    'منشآت خرسانية',
    'مباني خدمات',
    'مباني إدارية',
  ];

  final List<String> industrialActivities = [
    'صناعة الغزل والنسيج',
    'الصناعات الهندسية',
    'الصناعات المعدنية',
    'الصناعات المعدية',
    'الخشب والأثاث',
    'صناعة السيارات',
    'صناعة الورق والطباعة',
    'صناعة الأسمنت',
    'صناعة الجديد',
    'صناعة السيراميك',
    'الصناعات الدوائية',
    'الصناعات الطبية',
    'الصناعات الكيماوية',
    'الصناعات الغذائية',
    'الإنتاج النباتي والحيواني',
  ];

  final List<String> productionActivities = [
    'مزارع الإنتاج الداخني',
    'مزارع الإنتاج الحيواني',
  ];

  TextEditingController knownBuildNumController = TextEditingController();

  TextEditingController fixedInstallationNumberController =
      TextEditingController();

  // ─────────────────────────────────────────
  // Shared Actions
  // ─────────────────────────────────────────

  void selectUnitSubType(String? value) {
    emit(state.copyWith(selectedUnitSubType: value));
  }

  void toggleAmenity(String amenity) {
    final current = List<String>.from(state.selectedAmenities ?? []);
    if (current.contains(amenity)) {
      current.remove(amenity);
    } else {
      current.add(amenity);
    }
    emit(state.copyWith(selectedAmenities: current));
  }

  Future<void> selectFloorNumber(String? value) async {
    final isOther = value == 'أخرى';
    emit(
      state.copyWith(
        selectedFloorNumber: value,
        isFloorNumberOther: isOther,
        selectedUnitNumber: null,
        isUnitNumberOther: false,
      ),
    );
    if (!isOther) floorNumberOtherController.clear();

    int floorId = _getFloorOtherId();
    fetchBuildingUnitNumber(buildingNumber, floorId);
  }

  Future<void> selectFloorNumberOther(String? value) async {
    emit(
      state.copyWith(
        selectedFloorNumber: value,
        selectedFloorNumberOther: value,
        isFloorNumberOther: value == kOther,
        selectedUnitNumber: null,
        isUnitNumberOther: false,
      ),
    );
    // await fetchBuildingUnitNumber(
    //   buildingNumber
    // );
  }

  void selectUnitNumber(String? value) {
    final isOther = value == 'أخرى';
    emit(state.copyWith(selectedUnitNumber: value, isUnitNumberOther: isOther));
    if (!isOther) unitNumberOtherController.clear();
  }

  void setContactedTaxAuthority(bool? value) {
    emit(state.copyWith(contactedTaxAuthority: value));
  }

  void toggleExempt(bool value) {
    emit(state.copyWith(isExempt: value));
  }

  void selectExemptionReason(String? value) {
    emit(state.copyWith(selectedExemptionReason: value));
  }

  void toggleHasAdditionalDocuments(bool value) {
    emit(state.copyWith(hasAdditionalDocuments: value));
  }

  // ─────────────────────────────────────────
  // Actions - تركيبات ثابتة
  // ─────────────────────────────────────────

  void setIsTaxpayerOwner(bool? value, BuildContext context) {
    if (value ?? false) {
      if (unitData == null) {
        final applicantCubit = context.read<ApplicantCubit>();
        if (applicantCubit.taxpayerTypes == 'طبيعي') {
          installationOwnerController.text =
              '${applicantCubit.taxpayerFirstNameController.text.trim()} ${applicantCubit.taxpayerLastNameController.text.trim()}';
        } else {
          installationOwnerController.text = applicantCubit
              .taxpayerNameController
              .text
              .trim();
        }
      }
    }
    emit(state.copyWith(isTaxpayerOwner: value));
  }

  void selectInstallationType(String? value) {
    emit(state.copyWith(selectedInstallationType: value));
  }

  // ─────────────────────────────────────────
  // Actions - أراضي فضاء مستغلة
  // ─────────────────────────────────────────

  void selectExploitationType(String? value) {
    emit(state.copyWith(selectedExploitationType: value));
  }

  void addVacantLandItem() {
    if (state.vacantLandItems.length >= 10) return;
    final items = [...state.vacantLandItems, VacantLandItem()];
    emit(state.copyWith(vacantLandItems: items));
  }

  void removeVacantLandItem(String id) {
    if (state.vacantLandItems.length <= 1) return;
    final item = state.vacantLandItems.firstWhere((i) => i.id == id);
    item.dispose();
    final items = state.vacantLandItems.where((i) => i.id != id).toList();
    emit(state.copyWith(vacantLandItems: items));
  }

  void selectVacantLandItemExploitationType(String id, String? value) {
    final items = state.vacantLandItems.map((item) {
      if (item.id == id) item.selectedExploitationType = value;
      return item;
    }).toList();
    emit(state.copyWith(vacantLandItems: items));
  }

  void setVacantLandItemRetaContact(String id, bool value) {
    final items = state.vacantLandItems.map((item) {
      if (item.id == id) item.retaContactAboutUnit = value;
      return item;
    }).toList();
    emit(state.copyWith(vacantLandItems: items));
  }

  // ─────────────────────────────────────────
  // Actions - منشآت
  // ─────────────────────────────────────────

  void incrementFacilityBuildings() {
    final newBuilding = ServiceFacilityBuildingInfo(id: _uuid.v4());

    facilityBuildings.add(newBuilding);
    emit(state.copyWith(buildingsCount: facilityBuildings.length));
  }

  void decrementFacilityBuildings(int index) {
    if (facilityBuildings.length > 1) {
      final building = facilityBuildings[index];
      facilityBuildings.removeAt(index);
      _updateTotalBuildingArea();
      emit(state.copyWith(buildingsCount: facilityBuildings.length));
      WidgetsBinding.instance.addPostFrameCallback((_) => building.dispose());
    }
  }

  void updateBuildingArea() => _updateTotalBuildingArea();

  void incrementHotelBuildings() {
    hotelBuildings.add(HotelBuildingInfo(id: _uuid.v4()));
    emit(state.copyWith(buildingsCount: hotelBuildings.length));
  }

  Future<void> decrementHotelBuildings(int index) async {
    if (hotelBuildings.length <= 1) return;
    final building = hotelBuildings[index];
    if (unitData == null) {
      hotelBuildings.removeAt(index);
      emit(state.copyWith(buildingsCount: hotelBuildings.length));
      WidgetsBinding.instance.addPostFrameCallback((_) => building.dispose());
      return;
    }
    try {
      emit(state.copyWith(isLoading: true));
      final unitId = unitData!['id'];
      final result = await safeApiCall(() async {
        await DioClient.instance.dio.delete(
          '${ApiConstants.baseUrl}/declaration-system/declarations/$declarationId/units/hotel/$unitId/hotel_building/${building.id}',
        );
      });
      emit(state.copyWith(isLoading: false));
      switch (result) {
        case ApiSuccess():
          hotelBuildings.removeAt(index);
          emit(state.copyWith(buildingsCount: hotelBuildings.length));
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => building.dispose(),
          );
        case ApiError(:final message):
          emit(state.copyWith(errorMessage: message));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  void _updateTotalBuildingArea() {
    final total = facilityBuildings.fold<double>(
      0,
      (sum, b) => sum + (double.tryParse(b.areaController.text) ?? 0),
    );
    totalBuildingAreaController.text = total > 0
        ? total.toStringAsFixed(2)
        : '';
  }

  void selectServiceFacilityType(String? value) {
    emit(state.copyWith(selectedFacilityActivity: value));
  }

  void selectHotelView(String? value) {
    emit(state.copyWith(selectedHotelView: value));
  }

  void toggleMinistryBurden() {
    emit(state.copyWith(ministryBurden: !(state.ministryBurden ?? false)));
    if (!(state.ministryBurden ?? false)) {
      emit(state.copyWith(selectedBurdenActivity: null));
    }
  }

  void selectBurdenActivity(String? value) {
    emit(state.copyWith(selectedBurdenActivity: value));
  }

  void selectedMineQuarryFacilityTypes(String? value) {
    emit(state.copyWith(selectedMineQuarryFacilityTypesValue: value));
  }

  void selectedMineQuarryMaterials(String? value) {
    emit(state.copyWith(selectedMineQuarryMaterialsValue: value));
  }

  void addIndustrialBuilding() {
    industrialBuildings.add(IndustrialBuilding());
    emit(state.copyWith(industrialBuildingsCount: industrialBuildings.length));
  }

  void removeIndustrialBuilding(int index) {
    if (industrialBuildings.length <= 1) return;
    final building = industrialBuildings[index];
    industrialBuildings.removeAt(index);
    emit(state.copyWith(industrialBuildingsCount: industrialBuildings.length));
    WidgetsBinding.instance.addPostFrameCallback((_) => building.dispose());
  }

  Future<bool> saveIndustrialBuilding(
    int index,
    MapLocationResult? mapLocationResult,
  ) async {
    if (unitData == null) return true;
    final building = industrialBuildings[index];
    if (index == 0) building.mapLocationResult = mapLocationResult;
    final unitId = unitData!['id'];
    final buildingPayload = building.toPayload(lookups.buildingTypes);
    if (!building.isServerRecord) buildingPayload.remove('id');
    try {
      emit(state.copyWith(isLoading: true));
      final result = await safeApiCall(() async {
        return await DioClient.instance.dio.post(
          '${ApiConstants.baseUrl}/declaration-system/declarations/$declarationId/units/industrial/$unitId',
          data: {
            'buildings_count': industrialBuildings.length + 1,
            'building': buildingPayload,
          },
        );
      });
      emit(state.copyWith(isLoading: false));
      switch (result) {
        case ApiSuccess(:final data):
          if (!building.isServerRecord) {
            final body = data.data;
            final returnedId =
                (body?['unit']?['buildings'] as List?)?.last?['id'];
            // (body?['unit']?['Hamada'] as List?)?.last?['id'];
            if (returnedId != null) {
              building.id = returnedId.toString();
            }
            building.isServerRecord = true;
          }
          return true;
        case ApiError(:final message):
          emit(state.copyWith(errorMessage: message));
          return false;
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
      return false;
    }
  }

  Future<void> deleteIndustrialBuilding(int index) async {
    if (industrialBuildings.length <= 1) return;
    final building = industrialBuildings[index];
    if (!building.isServerRecord || unitData == null) {
      industrialBuildings.removeAt(index);
      emit(
        state.copyWith(industrialBuildingsCount: industrialBuildings.length),
      );
      WidgetsBinding.instance.addPostFrameCallback((_) => building.dispose());
      return;
    }
    try {
      emit(state.copyWith(isLoading: true));
      final unitId = unitData!['id'];
      final result = await safeApiCall(() async {
        await DioClient.instance.dio.delete(
          '${ApiConstants.baseUrl}/declaration-system/declarations/$declarationId/units/industrial/$unitId/${building.id}',
        );
      });
      emit(state.copyWith(isLoading: false));
      switch (result) {
        case ApiSuccess():
          industrialBuildings.removeAt(index);
          emit(
            state.copyWith(
              industrialBuildingsCount: industrialBuildings.length,
            ),
          );
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => building.dispose(),
          );
        case ApiError(:final message):
          emit(state.copyWith(errorMessage: message));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  void addPetroBuilding() {
    petroBuildings.add(PetroBuilding());
    emit(state.copyWith(petroBuildingsCount: petroBuildings.length));
  }

  void addProductionBuilding() {
    ProductionBuilding productionBuilding = ProductionBuilding(id: Uuid().v4());
    productionBuildings.add(productionBuilding);
    emit(state.copyWith(productionBuildingsCount: productionBuildings.length));
  }

  void removePetroBuilding(int index) {
    if (petroBuildings.length <= 1) return;
    final building = petroBuildings[index];
    petroBuildings.removeAt(index);
    emit(state.copyWith(petroBuildingsCount: petroBuildings.length));
    WidgetsBinding.instance.addPostFrameCallback((_) => building.dispose());
  }

  Future<bool> savePetroleumBuilding(
    int index,
    MapLocationResult? mapLocationResult,
  ) async {
    if (unitData == null) return true;
    final building = petroBuildings[index];
    if (index == 0) building.mapLocationResult = mapLocationResult;
    final unitId = unitData!['id'];
    final buildingPayload = building.toPayload(lookups.buildingTypes);
    if (!building.isServerRecord) buildingPayload.remove('id');
    try {
      emit(state.copyWith(isLoading: true));
      final result = await safeApiCall(() async {
        return await DioClient.instance.dio.post(
          '${ApiConstants.baseUrl}/declaration-system/declarations/$declarationId/units/petroleum/$unitId',
          data: {
            'buildings_count': petroBuildings.length + 1,
            'building': buildingPayload,
          },
        );
      });
      emit(state.copyWith(isLoading: false));
      switch (result) {
        case ApiSuccess(:final data):
          if (!building.isServerRecord) {
            final body = data.data;
            final returnedId =
                body?['data']?['id'] ?? body?['data']?['building']?['id'];
            if (returnedId != null) building.id = returnedId.toString();
            building.isServerRecord = true;
          }
          return true;
        case ApiError(:final message):
          emit(state.copyWith(errorMessage: message));
          return false;
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
      return false;
    }
  }

  Future<void> deletePetroleumBuilding(int index) async {
    if (petroBuildings.length <= 1) return;
    final building = petroBuildings[index];
    if (!building.isServerRecord || unitData == null) {
      petroBuildings.removeAt(index);
      emit(state.copyWith(petroBuildingsCount: petroBuildings.length));
      WidgetsBinding.instance.addPostFrameCallback((_) => building.dispose());
      return;
    }
    try {
      emit(state.copyWith(isLoading: true));
      final unitId = unitData!['id'];
      final result = await safeApiCall(() async {
        await DioClient.instance.dio.delete(
          '${ApiConstants.baseUrl}/declaration-system/declarations/$declarationId/units/petroleum/$unitId/${building.id}',
        );
      });
      emit(state.copyWith(isLoading: false));
      switch (result) {
        case ApiSuccess():
          petroBuildings.removeAt(index);
          emit(state.copyWith(petroBuildingsCount: petroBuildings.length));
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => building.dispose(),
          );
        case ApiError(:final message):
          emit(state.copyWith(errorMessage: message));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  void removeProductionBuilding(int index) {
    if (productionBuildings.length <= 1) return;
    final building = productionBuildings[index];
    productionBuildings.removeAt(index);
    emit(state.copyWith(productionBuildingsCount: productionBuildings.length));
    WidgetsBinding.instance.addPostFrameCallback((_) => building.dispose());
  }

  Future<bool> saveProductionBuilding(
    int index,
    MapLocationResult? mapLocationResult,
  ) async {
    if (unitData == null) return true;
    final building = productionBuildings[index];
    if (index == 0) building.mapLocationResult = mapLocationResult;
    final unitId = unitData!["id"];
    final buildingPayload = building.toPayload(lookups.buildingTypes);
    if (!building.isServerRecord) buildingPayload.remove("id");
    try {
      emit(state.copyWith(isLoading: true));
      final result = await safeApiCall(() async {
        return await DioClient.instance.dio.post(
          "${ApiConstants.baseUrl}/declaration-system/declarations/$declarationId/units/production/$unitId",
          data: {
            "buildings_count": productionBuildings.length + 1,
            "building": buildingPayload,
          },
        );
      });

      emit(state.copyWith(isLoading: false));
      switch (result) {
        case ApiSuccess(:final data):
          if (!building.isServerRecord) {
            final body = data.data;
            final returnedId =
                (body?["unit"]?["buildings"] as List?)?.last?["id"];
            if (returnedId != null) {
              building.id = returnedId.toString();
            }
            building.isServerRecord = true;
          }
          return true;
        case ApiError(:final message):
          emit(state.copyWith(errorMessage: message));
          return false;
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
      return false;
    }
  }

  Future<void> deleteProductionBuilding(int index) async {
    if (productionBuildings.length <= 1) return;
    final building = productionBuildings[index];
    if (!building.isServerRecord || unitData == null) {
      productionBuildings.removeAt(index);
      emit(
        state.copyWith(productionBuildingsCount: productionBuildings.length),
      );
      WidgetsBinding.instance.addPostFrameCallback((_) => building.dispose());
      return;
    }
    try {
      emit(state.copyWith(isLoading: true));
      final unitId = unitData!["id"];
      final result = await safeApiCall(() async {
        await DioClient.instance.dio.delete(
          "${ApiConstants.baseUrl}/declaration-system/declarations/$declarationId/units/production/$unitId/${building.id}",
        );
      });
      emit(state.copyWith(isLoading: false));
      switch (result) {
        case ApiSuccess():
          productionBuildings.removeAt(index);
          emit(
            state.copyWith(
              productionBuildingsCount: productionBuildings.length,
            ),
          );
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => building.dispose(),
          );
        case ApiError(:final message):
          emit(state.copyWith(errorMessage: message));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> setAllocationContractFile(String path) async {
    emit(state.copyWith(isLoading: true));
    final result = await UploadService.instance.uploadFile(
      filePath: path,
      label: 'allocation_contract',
    );
    _handleUploadResult(
      result,
      onSuccess: (data) => emit(
        state.copyWith(
          isLoading: false,
          allocationContractFilePath: data.path,
          allocationContractOriginalName: data.originalFileName,
          allocationContractFullUrl: data.fullUrl,
        ),
      ),
    );
  }

  void removeAllocationContractFile() => emit(
    state.copyWith(
      allocationContractFilePath: null,
      allocationContractFullUrl: null,
    ),
  );

  void selectStarRating(String? value) {
    emit(state.copyWith(selectedStarRating: value));
  }

  void setHasSubUnits(bool? value) {
    // if (state.hotelSubUnitsUpdateCount == 0) {
    //   addHotelSubUnit();
    // }
    emit(state.copyWith(hasSubUnits: value));
  }

  void addHotelSubUnit() {
    final updated = [...state.hotelSubUnits, HotelSubUnit()];
    emit(
      state.copyWith(
        hotelSubUnits: updated,
        hotelSubUnitsUpdateCount: state.hotelSubUnitsUpdateCount + 1,
      ),
    );
  }

  void confirmAddHotelSubUnit(HotelSubUnit unit) {
    final updated = [...state.hotelSubUnits, unit];
    emit(
      state.copyWith(
        hotelSubUnits: updated,
        hotelSubUnitsUpdateCount: state.hotelSubUnitsUpdateCount + 1,
      ),
    );
  }

  Future<void> removeHotelSubUnit(String id) async {
    final unit = state.hotelSubUnits.firstWhere((u) => u.id == id);
    unit.dispose();
    final updated = state.hotelSubUnits.where((u) => u.id != id).toList();

    await deleteBuilding('hotel', 'hotel_unit', id);

    // لو الليست فضت — ارجع hasSubUnits لـ false
    emit(
      state.copyWith(
        hotelSubUnits: updated,
        hasSubUnits: updated.isEmpty ? false : state.hasSubUnits,
        hotelSubUnitsUpdateCount: state.hotelSubUnitsUpdateCount + 1,
      ),
    );
  }

  void triggerHotelSubUnitRebuild() {
    emit(
      state.copyWith(
        hotelSubUnitsUpdateCount: state.hotelSubUnitsUpdateCount + 1,
      ),
    );
  }

  void addHotelSubUnitToBuilding(int buildingIndex) {
    hotelBuildings[buildingIndex].addSubUnit();
    emit(
      state.copyWith(
        hotelSubUnitsUpdateCount: state.hotelSubUnitsUpdateCount + 1,
      ),
    );
  }

  Future<void> removeHotelSubUnitFromBuilding(
    int buildingIndex,
    String unitId,
  ) async {
    hotelBuildings[buildingIndex].removeSubUnit(unitId);

    emit(
      state.copyWith(
        hotelSubUnitsUpdateCount: state.hotelSubUnitsUpdateCount + 1,
      ),
    );
  }

  // ─────────────────────────────────────────
  // Actions - Additional Documents
  // ─────────────────────────────────────────

  void addAdditionalDocument() {
    if (additionalDocuments.length < 5) {
      additionalDocuments.add(AdditionalDocument(id: _uuid.v4()));
      emit(
        state.copyWith(
          hasAdditionalDocuments: state.hasAdditionalDocuments,
          additionalDocuments: additionalDocuments,
          additionalUpdateCount: (state.additionalUpdateCount + 1),
        ),
      );
    }
  }

  void removeAdditionalDocument(String id) {
    final doc = additionalDocuments.firstWhere((d) => d.id == id);
    doc.dispose();
    additionalDocuments.removeWhere((d) => d.id == id);
    emit(
      state.copyWith(
        hasAdditionalDocuments: state.hasAdditionalDocuments,
        additionalDocuments: additionalDocuments,
        additionalUpdateCount: (state.additionalUpdateCount + 1),
      ),
    );
  }

  Future<void> setAdditionalDocumentFile(String id, String filePath) async {
    emit(state.copyWith(isLoading: true));

    if (filePath != '') {
      final result = await UploadService.instance.uploadFile(
        filePath: filePath,
        label: 'supporting_documents',
      );

      _handleUploadResult(
        result,
        onSuccess: (data) {
          final index = additionalDocuments.indexWhere((doc) => doc.id == id);
          additionalDocuments[index].filePath = data.path;
          additionalDocuments[index].originalFileName = data.originalFileName;
          additionalDocuments[index].fullUrl = data.fullUrl;
          emit(
            state.copyWith(
              isLoading: false,
              additionalUpdateCount: state.additionalUpdateCount + 1,
            ),
          );
        },
      );
    } else {
      final index = additionalDocuments.indexWhere((doc) => doc.id == id);
      additionalDocuments[index].filePath = null;
      additionalDocuments[index].originalFileName = null;
      additionalDocuments[index].fullUrl = null;
      emit(
        state.copyWith(
          isLoading: false,
          additionalUpdateCount: state.additionalUpdateCount + 1,
        ),
      );
    }
  }

  // ─────────────────────────────────────────
  // File Actions
  // ─────────────────────────────────────────

  Future<String?> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'pdf', 'jfif', 'png'],
    );
    if (result != null && result.files.isNotEmpty) {
      return result.files.single.path;
    }
    return null;
  }

  void changePrivateResidence() {
    if (canSubmitSingleExempt || state.isExempt) {
      canSubmitSingleExempt = true;
      emit(state.copyWith(isExempt: !state.isExempt));
    }
  }

  Future<void> setOwnershipDeedFile(String path) async {
    emit(state.copyWith(isLoading: true));
    final result = await UploadService.instance.uploadFile(
      filePath: path,
      label: ApiConstants.ownershipDeedLabel,
    );
    _handleUploadResult(
      result,
      onSuccess: (data) => emit(
        state.copyWith(
          isLoading: false,
          ownershipDeedFilePath: data.path,
          ownershipDeedOriginalName: data.originalFileName,
          ownershipDeedFullUrl: data.fullUrl,
        ),
      ),
    );
  }

  Future<void> setLeaseContractFile(String path) async {
    emit(state.copyWith(isLoading: true));
    final result = await UploadService.instance.uploadFile(
      filePath: path,
      label: ApiConstants.leaseContractLabel,
    );
    _handleUploadResult(
      result,
      onSuccess: (data) => emit(
        state.copyWith(
          isLoading: false,
          leaseContractFilePath: data.path,
          leaseContractOriginalName: data.originalFileName,
          leaseContractFullUrl: data.fullUrl,
        ),
      ),
    );
  }

  Future<void> setPermitPhotoFile(String path) async {
    emit(state.copyWith(isLoading: true));
    final result = await UploadService.instance.uploadFile(
      filePath: path,
      label: ApiConstants.permitPhotoLabel,
    );
    _handleUploadResult(
      result,
      onSuccess: (data) => emit(
        state.copyWith(
          isLoading: false,
          permitPhotoFilePath: data.path,
          permitPhotoOriginalName: data.originalFileName,
          permitPhotoFullUrl: data.fullUrl,
        ),
      ),
    );
  }

  Future<void> setConstructionLicenseFile(String path) async {
    emit(state.copyWith(isLoading: true));
    final result = await UploadService.instance.uploadFile(
      filePath: path,
      label: ApiConstants.constructionLicenseLabel,
    );
    _handleUploadResult(
      result,
      onSuccess: (data) => emit(
        state.copyWith(
          isLoading: false,
          constructionLicenseFilePath: data.path,
          constructionLicenseOriginalName: data.originalFileName,
          constructionLicenseFullUrl: data.fullUrl,
          constructionLicenseFileId: data.fileId,
          constructionLicenseUrl: data.path,
        ),
      ),
    );
  }

  Future<void> setOpeningBudgetFile(String path) async {
    emit(state.copyWith(isLoading: true));
    final result = await UploadService.instance.uploadFile(
      filePath: path,
      label: "opening_budget",
    );
    _handleUploadResult(
      result,
      onSuccess: (data) => emit(
        state.copyWith(
          isLoading: false,
          openingBudgetFilePath: data.path,
          openingBudgetOriginalName: data.originalFileName,
          openingBudgetFullUrl: data.fullUrl,
        ),
      ),
    );
  }

  Future<void> setOperationLicenseFile(String path) async {
    emit(state.copyWith(isLoading: true));
    final result = await UploadService.instance.uploadFile(
      filePath: path,
      label: "operation_license",
    );
    _handleUploadResult(
      result,
      onSuccess: (data) => emit(
        state.copyWith(
          isLoading: false,
          operationLicenseFilePath: data.path,
          operationLicenseOriginalName: data.originalFileName,
          operationLicenseFullUrl: data.fullUrl,
        ),
      ),
    );
  }

  Future<void> setAllBookBValueFile(String path) async {
    emit(state.copyWith(isLoading: true));
    final result = await UploadService.instance.uploadFile(
      filePath: path,
      label: "all_book_value",
    );
    _handleUploadResult(
      result,
      onSuccess: (data) => emit(
        state.copyWith(
          isLoading: false,
          allBookBValueFilePath: data.path,
          allBookBValueOriginalName: data.originalFileName,
          allBookBValueFullUrl: data.fullUrl,
        ),
      ),
    );
  }

  Future<void> setOperatingLicenseFile(String path) async {
    emit(state.copyWith(isLoading: true));
    final result = await UploadService.instance.uploadFile(
      filePath: path,
      label: ApiConstants.operatingLicenseLabel,
    );
    _handleUploadResult(
      result,
      onSuccess: (data) => emit(
        state.copyWith(
          isLoading: false,
          operatingLicenseFilePath: data.path,
          operatingLicenseOriginalName: data.originalFileName,
          operatingLicenseFullUrl: data.fullUrl,
        ),
      ),
    );
  }

  Future<void> setStarCertificateFile(String path) async {
    emit(state.copyWith(isLoading: true));
    final result = await UploadService.instance.uploadFile(
      filePath: path,
      label: ApiConstants.starCertificateLabel,
    );
    _handleUploadResult(
      result,
      onSuccess: (data) => emit(
        state.copyWith(
          isLoading: false,
          starCertificateFilePath: data.path,
          starCertificateOriginalName: data.originalFileName,
          starCertificateFullUrl: data.fullUrl,
        ),
      ),
    );
  }

  void removeOwnershipDeedFile() => emit(
    state.copyWith(ownershipDeedFilePath: null, ownershipDeedFullUrl: null),
  );

  void removeLeaseContractFile() => emit(
    state.copyWith(leaseContractFilePath: null, leaseContractFullUrl: null),
  );

  void removePermitPhotoFile() =>
      emit(state.copyWith(permitPhotoFilePath: null, permitPhotoFullUrl: null));

  void removeConstructionLicenseFile() {
    emit(
      state.copyWith(
        constructionLicenseFilePath: null,
        constructionLicenseFullUrl: null,
        constructionLicenseUrl: null,
        constructionLicenseFileId: null,
      ),
    );
  }

  void removeOperatingLicenseFile() => emit(
    state.copyWith(
      operatingLicenseFilePath: null,
      operatingLicenseFullUrl: null,
    ),
  );

  void removeStarCertificateFile() => emit(
    state.copyWith(starCertificateFilePath: null, starCertificateFullUrl: null),
  );

  void removeAllAssetsBalanceSheetFile() => emit(
    state.copyWith(
      allAssetsBalanceSheetFilePath: null,
      allAssetsBalanceSheetFullUrl: null,
    ),
  );

  void removeAllBookBValueFile() => emit(
    state.copyWith(allBookBValueFilePath: null, allBookBValueFullUrl: null),
  );

  void removeOpeningBudgetFile() => emit(
    state.copyWith(openingBudgetFilePath: null, openingBudgetFullUrl: null),
  );

  void removeOperationLicenseFile() => emit(
    state.copyWith(
      operationLicenseFilePath: null,
      operationLicenseFullUrl: null,
    ),
  );

  // ── Helper مشترك ─────────────────────────────────
  void _handleUploadResult(
    ApiResult<UploadedFileModel> result, {
    required void Function(UploadedFileModel data) onSuccess,
  }) {
    if (result is ApiSuccess<UploadedFileModel>) {
      onSuccess(result.data);
    } else if (result is ApiError<UploadedFileModel>) {
      emit(state.copyWith(isLoading: false, errorMessage: result.message));
    }
  }

  // ─────────────────────────────────────────
  // Validation & Submit
  // ─────────────────────────────────────────

  bool validate() {
    final isFormValid = formKey.currentState?.validate() ?? false;
    if (!isFormValid) return false;

    // ── كود حساب الوحدة ───────────────────────────────────────────
    final unitCode = unitCodeController.text.trim();
    if (unitCode.isNotEmpty &&
        unitCode.length != 14 &&
        (state.contactedTaxAuthority ?? false)) {
      emit(
        state.copyWith(errorMessage: 'كود حساب الوحدة يجب أن يكون 14 رقماً'),
      );
      return false;
    }

    // ── validation خاص بكل نوع ───────────────────────────────────
    switch (unitType) {
      case UnitType.fixedInstallations:
        return _validateFixedInstallations();

      case UnitType.hotelFacility:
        return _validateHotelFacility();

      case UnitType.industrialFacility:
      case UnitType.productionFacility:
        return _validateIndustrialFacility();

      case UnitType.serviceFacility:
        return _validateFacility();

      case UnitType.vacantLand:
        return _validateAdditionalDocs();

      case UnitType.petroleumFacility:
      case UnitType.minesAndQuarries:
        return _validateAdditionalDocs();

      default:
        return _validateDefault();
    }
  }

  bool _validateFixedInstallations() {
    if (!state.hasAdditionalDocuments) return true;

    if (additionalDocuments.isEmpty) {
      emit(
        state.copyWith(errorMessage: 'يرجى إضافة مستند داعم واحد على الأقل'),
      );
      return false;
    }

    for (final doc in additionalDocuments) {
      if (doc.nameController.text.trim().isEmpty) {
        emit(state.copyWith(errorMessage: 'يرجى إدخال اسم المستند الداعم'));
        return false;
      }
      if (doc.filePath == null) {
        emit(state.copyWith(errorMessage: 'يرجى رفع ملف المستند الداعم'));
        return false;
      }
    }

    return true;
  }

  bool _validateIndustrialFacility() {
    if ((state.ministryBurden ?? false) &&
        state.selectedBurdenActivity == null) {
      emit(
        state.copyWith(errorMessage: 'يرجى اختيار النشاط المستفاد من التحمل'),
      );
      return false;
    }
    return _validateAdditionalDocs();
  }

  bool _validateDefault() {
    return _validateAdditionalDocs();
  }

  // ── منشآت عادية (خدمية / صناعية / إنتاجية) ──────────────────────
  bool _validateFacility() {
    return _validateAdditionalDocs();
  }

  // ── منشأة فندقية — مفيش سند تمليك، في ملفات تانية ───────────────
  bool _validateHotelFacility() {
    if (state.hasSubUnits == true) {
      // final totalSubUnits = hotelBuildings.fold(
      //   0,
      //   (sum, b) => sum + b.hotelUnits.length,
      // );
      // if (totalSubUnits == 0) {
      //   emit(
      //     state.copyWith(
      //       errorMessage: 'يرجى إضافة وحدة تابعة واحدة على الأقل',
      //     ),
      //   );
      //   return false;
      // }
    }
    return _validateAdditionalDocs();
  }

  bool _validateAdditionalDocs() {
    if (!state.hasAdditionalDocuments) return true;

    if (additionalDocuments.isEmpty) {
      emit(
        state.copyWith(errorMessage: 'يرجى إضافة مستند داعم واحد على الأقل'),
      );
      return false;
    }

    for (final doc in additionalDocuments) {
      if (doc.nameController.text.trim().isEmpty) {
        emit(state.copyWith(errorMessage: 'يرجى إدخال اسم المستند الداعم'));
        return false;
      }
      if (doc.filePath == null) {
        emit(state.copyWith(errorMessage: 'يرجى رفع ملف المستند الداعم'));
        return false;
      }
    }

    return true;
  }

  Future<void> _syncBuildingsIfNeeded(UnitType unitType) async {
    if (unitData == null) return; // تعديل بس مش إضافة جديدة

    switch (unitType) {
      case UnitType.industrialFacility:
        final oldBuildings = unitData!['buildings'] as List? ?? [];
        final newBuildings = industrialBuildings.map((b) {
          final buildingTypeId = lookups.buildingTypes
              .firstWhere(
                (t) => t.name == b.buildingType,
                orElse: () => DeclarationLookup(id: -1, name: ''),
              )
              .id;
          return {
            'building_type_id': buildingTypeId == -1 ? null : buildingTypeId,
            'floors_count': b.floorsCount,
            'total_area': double.tryParse(b.totalArea.text.trim()),
            'construction_date': b.constructionDate.text.trim(),
            'market_value': b.marketValue.text.trim().isEmpty
                ? null
                : double.tryParse(b.marketValue.text.trim()),
          };
        }).toList();
        await _syncBuildings(
          unitPath: 'industrial',
          oldBuildings: oldBuildings,
          newBuildings: newBuildings,
        );

      case UnitType.petroleumFacility:
        final oldBuildings = unitData!['buildings'] as List? ?? [];
        final newBuildings = petroBuildings
            .map(
              (b) => {
                'building_type_text': b.buildingType.text.trim(),
                'total_area': double.tryParse(b.totalArea.text.trim()),
                'construction_date': b.buildingDate.text.trim(),
                'book_value':
                    double.tryParse(b.bookCostBuilding.text.trim()) ?? 0,
              },
            )
            .toList();
        await _syncBuildings(
          unitPath: 'petroleum',
          oldBuildings: oldBuildings,
          newBuildings: newBuildings,
        );

      case UnitType.productionFacility:
        final oldBuildings = unitData!['buildings'] as List? ?? [];
        final newBuildings = productionBuildings
            .map(
              (b) => {
                'floors_count': b.floorsCount,
                'total_area': double.tryParse(b.totalArea.text.trim()) ?? 0,
                'market_value': double.tryParse(b.marketValue.text.trim()),
              },
            )
            .toList();
        await _syncBuildings(
          unitPath: 'production',
          oldBuildings: oldBuildings,
          newBuildings: newBuildings,
        );

      default:
        return;
    }
  }

  Future<void> onSaveDataTapped(
    BuildContext context,
    UnitType unitType,
    MapLocationResult? mapLocationResult,
  ) async {
    // if (unitType == UnitType.industrialFacility ||
    //     unitType == UnitType.petroleumFacility ||
    //     unitType == UnitType.productionFacility) {
    //   await _syncBuildingsIfNeeded(unitType);
    // }

    final declarationCubit = context.read<DeclarationCubit>();
    int declarationId = await submit(
      context,
      unitType,
      mapLocationResult: mapLocationResult,
    );
    if (context.mounted && state.successMessage != null) {
      await declarationCubit.fetchList();
      await Future.delayed(const Duration(milliseconds: 100));
      DeclarationModel declarationModel =
          declarationCubit.declarationList?.firstWhere(
            (declaration) => declaration.id == declarationId,
            orElse: () => DeclarationModel(),
          ) ??
          DeclarationModel();

      if (context.mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.canPop(context);
        await Future.delayed(const Duration(milliseconds: 200));
        declarationCubit.onDeclarationCardTapped(declarationModel);
      }
    }
  }

  Future<void> onSaveAndAddOther(
    BuildContext context,
    UnitType unitType,
    MapLocationResult? mapLocationResult,
  ) async {
    final lookupsCubit = context.read<DeclarationLookupsCubit>();
    ApplicantCubit applicantCubit;
    try {
      applicantCubit = context.read<ApplicantCubit>();
    } catch (_) {
      applicantCubit = ApplicantCubit(
        applicantType: applicantType,
        declarationId: declarationId,
        isEditMode: false,
      );
    }
    final isEdit = unitData != null;

    Map<String, dynamic> applicantPayload = isEdit
        ? {"declaration_type_id": 1, "applicant_role_id": applicantType.id}
        : context.read<ApplicantCubit>().buildPayload(
            context,
            isEdit: declarationId != -1,
          );

    if (isEdit && applicantData != null) {
      applicantPayload = applicantData!;
    }

    final propertyTypeId = lookups.propertyTypes
        .firstWhere(
          (p) => p.name == unitType.label,
          orElse: () => DeclarationLookup(id: 1, name: ''),
        )
        .id;
    final locationCubit = context.read<UnitLocationCubit>();

    final payload = {
      ...applicantPayload,
      'unit': {
        if (isEdit) "id": unitData?['id'],
        'property_type_id': propertyTypeId,
        ...locationCubit.buildLocationPayload(),
        ..._buildUnitPayload(unitType, lookups, mapLocationResult),
      },
    };

    int _declarationId = await submit(
      context,
      unitType,
      payload: payload,
      mapLocationResult: mapLocationResult,
    );
    if (context.mounted && state.successMessage != null) {
      final locationCubit = context.read<UnitLocationCubit>();
      Map<String, dynamic> locationData = {
        "buildingProfile": locationCubit.mapData,
      };

      await Future.delayed(const Duration(milliseconds: 100));
      if (!context.mounted) return;
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              if (applicantCubit != null)
                BlocProvider.value(value: applicantCubit),
              BlocProvider.value(value: lookupsCubit),
            ],
            child: SelectTypesOfPropertiesPage(
              applicantType: applicantType,
              declarationId: _declarationId,
              locationData: locationData,
              unitData: null,
              applicantPayload: applicantPayload,
            ),
          ),
        ),
      );
    }
  }

  Future<int> submit(
    BuildContext context,
    UnitType unitType, {
    Map<String, dynamic>? payload,
    MapLocationResult? mapLocationResult,
  }) async {
    final locationCubit = context.read<UnitLocationCubit>();
    final lookups = context.read<DeclarationLookupsCubit>().lookups!;

    try {
      emit(state.copyWith(isLoading: true));
      final propertyTypeId = lookups.propertyTypes
          .firstWhere(
            (p) => p.name == unitType.label,
            orElse: () => DeclarationLookup(id: 1, name: ''),
          )
          .id;

      final isEdit = unitData != null;
      final bool isEditDeclaration = declarationId != -1;
      if (payload == null) {
        Map<String, dynamic> applicantPayload = isEdit
            ? {"declaration_type_id": 1, "applicant_role_id": applicantType.id}
            : context.read<ApplicantCubit>().buildPayload(
                context,
                isEdit: isEditDeclaration,
              );

        if (isEdit || applicantData != null) {
          applicantPayload = applicantData!;
        }
        payload = {
          ...applicantPayload,
          'unit': {
            if (isEdit) "id": unitData?['id'],
            'property_type_id': propertyTypeId,
            ...locationCubit.buildLocationPayload(),
            ..._buildUnitPayload(unitType, lookups, mapLocationResult),
          },
        };
      }

      final result = isEdit
          ? await DeclarationService.instance.updateDeclaration(
              payload,
              declarationId: declarationId,
              unitId: unitData!['id'],
            )
          : await DeclarationService.instance.createDeclaration(
              payload,
              declarationId: declarationId,
            );

      switch (result) {
        case ApiSuccess(:final data):
          emit(
            state.copyWith(
              isLoading: false,
              successMessage: isEdit
                  ? 'تم تعديل الإقرار بنجاح'
                  : 'تم حفظ الإقرار بنجاح',
            ),
          );
          return data['data']['id'];
        case ApiError(:final message):
          emit(state.copyWith(isLoading: false, errorMessage: message));
          return -1;
      }
    } catch (error) {
      emit(state.copyWith(isLoading: false));
      return -1;
    }
  }

  Map<String, dynamic> _buildUnitPayload(
    UnitType unitType,
    DeclarationLookupsModel lookups,
    MapLocationResult? mapLocationResult,
  ) {
    switch (unitType) {
      case UnitType.residential:
        return buildResidentialPayload(lookups);
      case UnitType.commercial:
        activityTypeController.text = 'تجاري';
        return buildCommercialPayload(lookups, 'تجاري');
      case UnitType.administrative:
        activityTypeController.text = 'إداري';
        return buildCommercialPayload(lookups, 'إداري');
      case UnitType.serviceUnit:
        activityTypeController.text = 'خدمي';
        return buildCommercialPayload(lookups, 'خدمي');
      case UnitType.fixedInstallations:
        return buildFixedInstallationsPayload();
      case UnitType.vacantLand:
        return buildVacantLandPayload();
      case UnitType.serviceFacility:
        return buildFacilityPayload(lookups, mapLocationResult);
      case UnitType.productionFacility:
        return buildProductionPayload(lookups, mapLocationResult);
      case UnitType.industrialFacility:
        return buildIndustrialPayload(
          lookups,
          industrialBuildings,
          mapLocationResult,
        );
      case UnitType.hotelFacility:
        return buildHotelPayload(lookups);
      case UnitType.petroleumFacility:
        return buildPetroleumPayload(mapLocationResult);
      case UnitType.minesAndQuarries:
        return buildMinesPayload();
    }
  }

  Map<String, dynamic> buildResidentialPayload(
    DeclarationLookupsModel lookups,
  ) {
    // الملحقات
    final attachmentIds = (state.selectedAmenities ?? [])
        .map((amenityName) {
          return lookups.unitAttachments
              .firstWhere(
                (a) => a.name == amenityName,
                orElse: () => DeclarationLookup(id: 0, name: ''),
              )
              .id;
        })
        .where((id) => id != 0)
        .toList();

    int unitTypeId = lookups.residentialUnitTypes
        .firstWhere(
          (type) => type.name == state.selectedUnitSubType,
          orElse: () => DeclarationLookup(id: 0, name: ''),
        )
        .id;

    return {
      ..._buildBaseUnitPayload(),
      //TODO: Update this value
      "unit_number": "1",
      'usage_type': 'سكني',
      'unit_type_id': unitTypeId,
      'area': double.tryParse(areaController.text.trim()) ?? 0,
      'attachments': attachmentIds,
      'exempted_as_private_residence': state.isExempt,
      'exempted_as_residence': state.isExempt,
      if (state.ownershipDeedFilePath != null)
        'ownership_deed': {
          'path': state.ownershipDeedFilePath,
          'original_file_name': state.ownershipDeedOriginalName,
          'full_url': state.ownershipDeedFullUrl,
        },
      if (state.leaseContractFilePath != null)
        'lease_contract': {
          'path': state.leaseContractFilePath,
          'original_file_name': state.leaseContractOriginalName,
          'full_url': state.leaseContractFullUrl,
        },
      ..._buildSupportingDocsPayload(),
    };
  }

  // وحدة تجارية / إدارية / خدمية
  Map<String, dynamic> buildCommercialPayload(
    DeclarationLookupsModel lookups,
    String unitType,
  ) {
    final unitTypeId = lookups.commercialUnitTypes
        .firstWhere(
          (t) => t.name == unitType,
          orElse: () => DeclarationLookup(id: -1, name: ''),
        )
        .id;

    final exemptionReasonId = lookups.exemptionReasons
        .firstWhere(
          (t) => t.name == state.selectedExemptionReason,
          orElse: () => DeclarationLookup(id: -1, name: ''),
        )
        .id;

    return {
      ..._buildBaseUnitPayload(),
      'usage_type': 'غير سكني',
      'unit_type_id': unitTypeId,
      'area': double.tryParse(areaController.text.trim()) ?? 0,
      'activity_type': activityTypeController.text.trim(),
      'exempted': state.isExempt,
      if (unitType == UnitType.serviceUnit.name)
        'exemption_reason': exemptionReasonId,
      if (state.ownershipDeedFilePath != null)
        'ownership_deed': {
          'path': state.ownershipDeedFilePath,
          'original_file_name': state.ownershipDeedOriginalName,
          'full_url': state.ownershipDeedFullUrl,
        },
      if (state.leaseContractFilePath != null)
        'lease_contract': {
          'path': state.leaseContractFilePath,
          'original_file_name': state.leaseContractOriginalName,
          'full_url': state.leaseContractFullUrl,
        },
      if (state.permitPhotoFilePath != null)
        'license_photo': {
          'path': state.permitPhotoFilePath,
          'original_file_name': state.permitPhotoOriginalName,
          'full_url': state.permitPhotoFullUrl,
        },

      ..._buildSupportingDocsPayload(),
    };
  }

  // تركيبات ثابتة
  Map<String, dynamic> buildFixedInstallationsPayload() {
    final installationTypeId = lookups.installationTypes
        .firstWhere(
          (t) => t.name == state.selectedInstallationType,
          orElse: () => DeclarationLookup(id: -1, name: ''),
        )
        .id;

    final String otherInstallation = otherInstallationTypeController.text
        .trim();
    final String annualRentalValue = annualRentalValueController.text.trim();

    return {
      ..._buildBaseUnitPayload(),
      'installation_type_id': installationTypeId,
      // if (otherInstallation != '')
      'installation_type_other': otherInstallation != ''
          ? otherInstallation
          : null,
      'is_taxpayer_owner_of_installation': (state.isTaxpayerOwner ?? false)
          ? 1
          : 2,
      'installation_owner_name': installationOwnerController.text.trim(),
      'contract_start': contractStartDateController.text.trim(),
      'contract_end': contractEndDateController.text.trim(),
      if (annualRentalValue != '')
        'annual_rent_value': annualRentalValue != '' ? annualRentalValue : null,
      if (state.ownershipDeedFilePath != null)
        'ownership_deed': {
          'path': state.ownershipDeedFilePath,
          'original_file_name': state.ownershipDeedOriginalName,
          'full_url': state.ownershipDeedFullUrl,
        },
      ..._buildSupportingDocsPayload(),
    };
  }

  // أراضي فضاء مستغلة
  Map<String, dynamic> buildVacantLandPayload() {
    return {
      'total_land_area': totalLandAreaController.text.trim(),
      "submit_other_supporting_documents": state.hasAdditionalDocuments ? 1 : 2,
      'vacantLands': state.vacantLandItems
          .map((item) => item.toPayload(lookups.exploitationTypes))
          .toList(),
      if (state.ownershipDeedFilePath != null)
        'land_ownership_legal_document': {
          'path': state.ownershipDeedFilePath,
          'original_file_name': state.ownershipDeedOriginalName,
          'full_url': state.ownershipDeedFullUrl,
        },
      if (state.leaseContractFilePath != null)
        'land_lease_agreement': {
          'path': state.leaseContractFilePath,
          'original_file_name': state.leaseContractOriginalName,
          'full_url': state.leaseContractFullUrl,
        },
      ..._buildSupportingDocsPayload(),
    };
  }

  Map<String, dynamic> buildIndustrialPayload(
    DeclarationLookupsModel lookups,
    List<IndustrialBuilding> buildings,
    MapLocationResult? mapLocationResult,
  ) {
    final burdenActivityId = state.selectedBurdenActivity == null
        ? null
        : lookups.burdenActivityTypes
              .firstWhere(
                (b) => b.name == state.selectedBurdenActivity,
                orElse: () => DeclarationLookup(id: -1, name: ''),
              )
              .id;

    return {
      ..._buildBaseUnitPayload(),
      'facility_name': facilityNameController.text.trim(),
      'activity_type': activityTypeController.text.trim(),
      'total_land_area': double.tryParse(
        totalLandAreaFacilityController.text.trim(),
      ),
      'used_land_area': double.tryParse(
        exploitedLandAreaController.text.trim(),
      ),
      'market_value': landMarketValueController.text.trim().isEmpty
          ? null
          : double.tryParse(landMarketValueController.text.trim()),
      'ministry_burden': state.ministryBurden ?? false,
      if (state.ministryBurden == true &&
          burdenActivityId != null &&
          burdenActivityId != -1)
        'burden_activity_id': burdenActivityId,
      if (unitData == null) 'buildings_count': buildings.length,
      if (unitData == null)
        'buildings': buildings.map((b) {
          final buildingTypeId = b.buildingType == null
              ? null
              : lookups.buildingTypes
                    .firstWhere(
                      (t) => t.name == b.buildingType,
                      orElse: () => DeclarationLookup(id: -1, name: ''),
                    )
                    .id;
          return {
            if (unitData != null) 'id': b.id,
            ...?(b.mapLocationResult ?? mapLocationResult)?.toMap(),
            'known_build_num': b.knownBuildingNumber.text.trim(),
            'is_nearest_property': b.isNearestProperty == true ? 1 : 2,
            'building_type_id': buildingTypeId == -1 ? null : buildingTypeId,
            'floors_count': b.floorsCount,
            'total_area': double.tryParse(b.totalArea.text.trim()),
            'construction_date': b.constructionDate.text.trim(),
            'market_value': b.marketValue.text.trim().isEmpty
                ? null
                : double.tryParse(b.marketValue.text.trim()),
          };
        }).toList(),
      if (state.constructionLicenseFilePath != null)
        'construction_license': {
          'path': state.constructionLicenseFilePath,
          'original_file_name': state.constructionLicenseOriginalName,
          'full_url': state.constructionLicenseFullUrl,
        },
      if (state.operatingLicenseFilePath != null)
        'operation_license': {
          'path': state.operatingLicenseFilePath,
          'original_file_name': state.operatingLicenseOriginalName,
          'full_url': state.operatingLicenseFullUrl,
        },
      if (state.allocationContractFilePath != null)
        'allocation_contract': {
          'path': state.allocationContractFilePath,
          'original_file_name': state.allocationContractOriginalName,
          'full_url': state.allocationContractFullUrl,
        },
      ..._buildSupportingDocsPayload(),
    };
  }

  // منشآت فندقية
  Map<String, dynamic> buildHotelPayload(DeclarationLookupsModel lookups) {
    final viewTypeId = lookups.hotelViewTypes
        .firstWhere(
          (v) => v.name == state.selectedHotelView,
          orElse: () => DeclarationLookup(id: -1, name: ''),
        )
        .id;

    // star_rating_id من display text
    final starRatingId = lookups.starRatings
        .firstWhere(
          (s) => s.name == state.selectedStarRating,
          orElse: () => DeclarationLookup(id: -1, name: ''),
        )
        .id;

    final totalRooms = hotelBuildings.fold(0, (sum, b) => sum + b.roomsCount);

    return {
      ..._buildBaseUnitPayload(),
      'trade_name': facilityNameController.text.trim(),
      'view_type_id': viewTypeId,
      'license_date': operatingLicenseDateController.text.trim(),
      'buildings_count': hotelBuildings.length,
      'rooms_count': totalRooms,
      'star_rating_id': starRatingId,
      'has_sub_units': state.hasSubUnits == true ? 1 : 2,
      'hotelUnits': state.hotelSubUnits
          .map((u) => u.toPayload(lookups.realEstateFloors))
          .toList(),
      'buildings': hotelBuildings.asMap().entries.map((entry) {
        final buildingNum = '${entry.value.mapLocationResult?.streetNumber}';
        final b = entry.value;
        final units = state.hotelSubUnits
            .where((u) => u.buildingNumber.text == buildingNum)
            .map((u) => u.toPayload(lookups.realEstateFloors))
            .toList();

        return {
          ...?b.mapLocationResult?.toMap(),
          if (unitData != null) 'id': b.id,
          'known_build_num': b.knownBuildingNumber.text.trim(),
          'is_nearest_property': b.isNearestProperty == true ? 1 : 0,
          'floors_number': b.floorsCount,
          'rooms_number': b.roomsCount,
          'hotelUnits': units,
        };
      }).toList(),
      if (state.constructionLicenseFilePath != null)
        'copy_of_the_construction_permits': {
          'path': state.constructionLicenseFilePath,
          'original_file_name': state.constructionLicenseOriginalName,
          'full_url': state.constructionLicenseFullUrl,
        },
      if (state.operatingLicenseFilePath != null)
        'copy_of_the_operating_licenses': {
          'path': state.operatingLicenseFilePath,
          'original_file_name': state.operatingLicenseOriginalName,
          'full_url': state.operatingLicenseFullUrl,
        },
      if (state.starCertificateFilePath != null)
        'certificate_of_stardom_level': {
          'path': state.starCertificateFilePath,
          'original_file_name': state.starCertificateOriginalName,
          'full_url': state.starCertificateFullUrl,
        },
      ..._buildSupportingDocsPayload(),
    };
  }

  // منشآت صناعية
  Map<String, dynamic> buildFacilityPayload(
    DeclarationLookupsModel lookups,
    MapLocationResult? mapLocationResult,
  ) {
    final totalBuildingArea = facilityBuildings.fold<double>(
      0,
      (sum, b) => sum + (double.tryParse(b.areaController.text) ?? 0),
    );

    final exemptionReasonId = lookups.exemptionReasons
        .firstWhere(
          (t) => t.name == state.selectedExemptionReason,
          orElse: () => DeclarationLookup(id: -1, name: ''),
        )
        .id;

    // final facilityTypeId = lookups.serviceFacilityTypes
    //     .firstWhere(
    //       (t) => t.name == state.selectedFacilityActivity,
    //       orElse: () => DeclarationLookup(id: -1, name: ''),
    //     )
    //     .id;

    return {
      ..._buildBaseUnitPayload(),
      'facility_name': facilityNameController.text.trim(),
      // 'facility_type_id': facilityTypeId == -1 ? null : facilityTypeId,
      'activity_type': activityTypeController.text.trim(),
      'total_land_area': totalLandAreaFacilityController.text.trim(),
      'total_building_area': totalBuildingArea,
      'buildings_count': facilityBuildings.length,
      'buildings': facilityBuildings.asMap().entries.map((entry) {
        final index = entry.key;
        final b = entry.value;

        return {
          if (unitData != null) 'id': b.id,
          'floors_count': b.floorsCount,
          'building_area': double.tryParse(b.areaController.text.trim()) ?? 0,

          ...?((index == 0
                  ? (b.mapLocationResult ?? mapLocationResult)
                  : b.mapLocationResult)
              ?.toMap()),

          'known_build_num': b.knownBuildingNumber.text.trim(),
          'is_nearest_property': b.isNearestProperty == true ? 1 : 2,
        };
      }).toList(),
      'exempted': state.isExempt,
      if (state.isExempt) 'exemption_reason': exemptionReasonId,
      if (state.isExempt && lawNumberController.text.isNotEmpty)
        'law_number': lawNumberController.text.trim(),
      if (state.isExempt && lawYearController.text.isNotEmpty)
        'law_year': int.tryParse(lawYearController.text.trim()),
      if (state.ownershipDeedFilePath != null)
        'facility_ownership_deed': {
          'path': state.ownershipDeedFilePath,
          'original_file_name': state.ownershipDeedOriginalName,
          'full_url': state.ownershipDeedFullUrl,
        },
      if (state.leaseContractFilePath != null)
        'facility_lease_contracts': {
          'path': state.leaseContractFilePath,
          'original_file_name': state.leaseContractOriginalName,
          'full_url': state.leaseContractFullUrl,
        },
      if (state.constructionLicenseFilePath != null)
        'building_permits': {
          'path': state.constructionLicenseFilePath,
          'original_file_name': state.constructionLicenseOriginalName,
          'full_url': state.constructionLicenseFullUrl,
        },
      if (state.operatingLicenseFilePath != null)
        'operating_licenses': {
          'path': state.operatingLicenseFilePath,
          'original_file_name': state.operatingLicenseOriginalName,
          'full_url': state.operatingLicenseFullUrl,
        },
      ..._buildSupportingDocsPayload(),
    };
  }

  // منشآت إنتاجية
  Map<String, dynamic> buildProductionPayload(
    DeclarationLookupsModel lookups,
    MapLocationResult? mapLocationResult,
  ) {
    final burdenActivityId = state.selectedBurdenActivity == null
        ? null
        : lookups.productionBurdenActivityTypes
              .firstWhere(
                (b) => b.name == state.selectedBurdenActivity,
                orElse: () => DeclarationLookup(id: -1, name: ''),
              )
              .id;
    return {
      ..._buildBaseUnitPayload(),
      'facility_name': productionFacilityNameController.text.trim(),
      'activity_type': productionUsageTypeController.text.trim(),
      'total_land_area': totalLandArea.text.trim(),
      'used_land_area': totalLandUtilized.text.trim(),
      'market_value': bookValueController.text.trim(),
      "ministry_burden": state.isExempt,
      "burden_activity_id": state.isExempt == true ? burdenActivityId : null,
      if (unitData == null) 'buildings_count': productionBuildings.length,
      if (unitData == null)
        'buildings': productionBuildings
            .map(
              (b) => {
                ...?(b.mapLocationResult ?? mapLocationResult)?.toMap(),
                'known_build_num': b.knownBuildingNumber.text.trim(),
                'is_nearest_property': b.isNearestProperty == true ? 1 : 0,
                'floors_count': b.floorsCount,
                'total_area': double.tryParse(b.totalArea.text.trim()) ?? 0,
                'market_value': double.tryParse(b.marketValue.text.trim()),
              },
            )
            .toList(),
      if (state.allocationContractFilePath != null)
        'allocation_contract': {
          'path': state.allocationContractFilePath,
          'original_file_name': state.allocationContractOriginalName,
          'full_url': state.allocationContractFullUrl,
        },
      if (state.constructionLicenseFilePath != null)
        'construction_license': {
          'path': state.constructionLicenseFilePath,
          'full_url': state.constructionLicenseFullUrl,
        },
      if (state.operationLicenseFilePath != null)
        'operation_license': {
          'path': state.operationLicenseFilePath,
          'original_file_name': state.operationLicenseOriginalName,
          'full_url': state.operationLicenseFullUrl,
        },
      ..._buildSupportingDocsPayload(),
    };
  }

  // منشآت بترولية
  Map<String, dynamic> buildPetroleumPayload(
    MapLocationResult? mapLocationResult,
  ) {
    return {
      ..._buildBaseUnitPayload(),
      'facility_name': petroleumFacilityNameController.text.trim(),
      'usage_type': usageTypeController.text.trim(),
      'total_land_area': totalLandArea.text.trim(),
      'used_land_area': totalLandUtilized.text.trim(),
      if (bookValueController.text.isNotEmpty)
        'land_book_value': bookValueController.text.trim(),
      if (unitData == null) 'buildings_count': petroBuildings.length,
      if (state.constructionLicenseFilePath != null)
        'construction_license': {
          'path': state.constructionLicenseFilePath,
          'original_file_name': state.constructionLicenseOriginalName,
          'full_url': state.constructionLicenseFullUrl,
        },
      if (state.openingBudgetFilePath != null)
        'opening_budget': {
          'path': state.openingBudgetFilePath,
          'original_file_name': state.openingBudgetOriginalName,
          'full_url': state.openingBudgetFullUrl,
        },
      if (state.allBookBValueFilePath != null)
        'all_book_value': {
          'path': state.allBookBValueFilePath,
          'original_file_name': state.allBookBValueOriginalName,
          'full_url': state.allBookBValueFullUrl,
        },
      if (unitData == null)
        'buildings': petroBuildings.map((b) {
          final payload = b.toPayload(lookups.buildingTypes);
          payload.remove('id');
          return payload;
        }).toList(),
      ..._buildSupportingDocsPayload(),
    };
  }

  // مناجم ومحاجر
  Map<String, dynamic> buildMinesPayload() {
    final selectedMineQuarryFacilityTypesID =
        state.selectedMineQuarryFacilityTypesValue == null
        ? null
        : lookups.mineQuarryFacilityTypesValue
              .firstWhere(
                (b) => b.name == state.selectedMineQuarryFacilityTypesValue,
                orElse: () => DeclarationLookup(id: -1, name: ''),
              )
              .id;

    final selectedMineQuarryMaterialsID =
        state.selectedMineQuarryMaterialsValue == null
        ? null
        : lookups.mineQuarryMaterialsValue
              .firstWhere(
                (b) => b.name == state.selectedMineQuarryMaterialsValue,
                orElse: () => DeclarationLookup(id: -1, name: ''),
              )
              .id;

    return {
      ..._buildBaseUnitPayload(),
      'facility_type_id': selectedMineQuarryFacilityTypesID,
      'extracted_material_id': selectedMineQuarryMaterialsID,
      'licensed_area': totalLandUtilized.text.trim(),
      'contract_start': contractStartDateController.text.trim(),
      'contract_end': contractEndDateController.text.trim(),
      'annual_rent_value': bookValueController.text.trim(),
      if (state.allocationContractFilePath != null)
        'deed_of_exploitation': {
          'path': state.allocationContractFilePath,
          'original_file_name': state.allocationContractOriginalName,
          'full_url': state.allocationContractFullUrl,
        },
      ..._buildSupportingDocsPayload(docKey: "mine_supporting_documents"),
    };
  }

  Map<String, dynamic> _buildBaseUnitPayload({bool hideUnit = false}) {
    final floorId = state.isFloorNumberOther ? -1 : _getFloorOtherId();
    final unitID = state.isUnitNumberOther ? -1 : _getUnitID();
    return {
      'real_estate_floor_id': floorId,
      if (state.isFloorNumberOther)
        'real_estate_floor_other': floorNumberOtherController.text.trim(),
      if (!hideUnit) 'unit_id': unitID,
      // if (state.isUnitNumberOther)
      if (!hideUnit) 'unit_number': unitNumberOtherController.text.trim(),
      'reta_contact_about_unit': state.contactedTaxAuthority == true ? 1 : 2,
      'account_code': state.contactedTaxAuthority == true
          ? unitCodeController.text.trim().isEmpty
                ? null
                : unitCodeController.text.trim()
          : null,
      if (marketValueController.text.trim() != '')
        'market_value': double.tryParse(marketValueController.text.trim()),
      'submit_other_supporting_documents': state.hasAdditionalDocuments ? 1 : 2,
    };
  }

  Map<String, dynamic> _buildSupportingDocsPayload({String? docKey}) {
    if (additionalDocuments.isEmpty) return {};
    final docs = additionalDocuments
        .where((d) => d.nameController.text.isNotEmpty && d.filePath != null)
        .map(
          (d) => {
            'name': d.nameController.text.trim(),
            'path': d.filePath,
            'original_file_name':
                d.originalFileName ?? d.nameController.text.trim(),
            'full_url': d.fullUrl,
          },
        )
        .toList();
    if (docs.isEmpty) return {};
    return {docKey ?? 'supporting_documents': docs};
  }

  int _getFloorId({String? floorName}) {
    int floorId = lookups.realEstateFloors
        .firstWhere(
          (a) => a.name == (floorName ?? state.selectedFloorNumber),
          orElse: () => DeclarationLookup(id: 0, name: ''),
        )
        .id;
    return floorId;
  }

  int _getFloorOtherId() {
    int floorId = lookups.realEstateFloors
        .firstWhere(
          (a) => a.name == state.selectedFloorNumber,
          orElse: () => DeclarationLookup(id: 0, name: ''),
        )
        .id;
    return floorId;
  }

  int _getUnitID() {
    int unitId = state.buildingUnitList
        .firstWhere(
          (a) => a.name == state.selectedUnitNumber,
          orElse: () => DeclarationLookup(id: 0, name: ''),
        )
        .id;
    return unitId;
  }

  void onCancelButtonTapped(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  Future<void> _syncBuildings({
    required String unitPath, // 'industrial' | 'petroleum' | 'production'
    required List<dynamic> oldBuildings,
    required List<Map<String, dynamic>> newBuildings,
  }) async {
    final unitId = unitData!['id'];

    final tempOld = oldBuildings;
    for (int index = 0; index < tempOld.length; index++) {
      final b = tempOld[index];
      final buildingId = b['id'];
      final result = await safeApiCall(() async {
        await DioClient.instance.dio.delete(
          '${ApiConstants.baseUrl}/declaration-system/declarations/$declarationId/units/$unitPath/$unitId/$buildingId',
        );
      });

      switch (result) {
        case ApiSuccess(:final data):
          oldBuildings.removeAt(index);
        case ApiError(:final message):
      }
    }

    for (final b in newBuildings) {
      String totalLand = '0';
      if (unitPath == 'industrial') {
        totalLand = exploitedLandAreaController.text.trim();
      } else if (unitPath == 'petroleum') {
        totalLand = totalLandArea.text.trim();
      } else if (unitPath == 'production') {
        totalLand = totalLandArea.text.trim();
      }

      await safeApiCall(() async {
        await DioClient.instance.dio.post(
          '${ApiConstants.baseUrl}/declaration-system/declarations/$declarationId/units/$unitPath/$unitId',
          data: {
            "buildings_count": newBuildings.length + 1,
            "total_land_area": totalLand,
            "building": b,
          },
        );
      });
    }

    for (final b in oldBuildings) {
      final buildingId = b['id'];
      await safeApiCall(() async {
        await DioClient.instance.dio.delete(
          '${ApiConstants.baseUrl}/declaration-system/declarations/$declarationId/units/$unitPath/$unitId/$buildingId',
        );
      });
    }
  }

  Future<void> deleteBuilding(
    String unitPath,
    String suffix,
    String buildingId,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      final unitId = unitData!['id'];

      final result = await safeApiCall(() async {
        await DioClient.instance.dio.delete(
          '${ApiConstants.baseUrl}/declaration-system/declarations/$declarationId/units/$unitPath/$unitId/$suffix/$buildingId',
        );
      });

      emit(state.copyWith(isLoading: false));
      switch (result) {
        case ApiSuccess(:final data):
        case ApiError(:final message):
      }
    } catch (error) {
      emit(state.copyWith(isLoading: false, errorMessage: error.toString()));
    }
  }

  // ─────────────────────────────────────────
  // Dispose
  // ─────────────────────────────────────────

  @override
  Future<void> close() {
    floorNumberOtherController.dispose();
    floorNumberController.dispose();
    unitNumberOtherController.dispose();
    unitNumberController.dispose();
    unitCodeController.dispose();
    marketValueController.dispose();
    lawNumberController.dispose();
    lawYearController.dispose();
    areaController.dispose();
    installationOwnerController.dispose();
    contractStartDateController.dispose();
    contractEndDateController.dispose();
    annualRentalValueController.dispose();
    otherInstallationTypeController.dispose();
    totalLandAreaController.dispose();
    exploitedAreaController.dispose();
    otherExploitationTypeController.dispose();
    facilityNameController.dispose();
    facilityCodeController.dispose();
    activityTypeController.dispose();
    facilityMarketValueController.dispose();
    operatingLicenseDateController.dispose();
    totalLandAreaFacilityController.dispose();
    exploitedLandAreaController.dispose();
    landMarketValueController.dispose();
    usageTypeController.dispose();
    bookValueController.dispose();
    for (final doc in additionalDocuments) {
      doc.dispose();
    }
    for (final building in facilityBuildings) {
      building.dispose();
    }
    for (final b in hotelBuildings) {
      b.dispose();
    }
    for (final b in industrialBuildings) {
      b.dispose();
    }
    for (final b in petroBuildings) {
      b.dispose();
    }
    for (final b in productionBuildings) {
      b.dispose();
    }
    return super.close();
  }

  void clearError() => emit(state.copyWith(errorMessage: null));
}
