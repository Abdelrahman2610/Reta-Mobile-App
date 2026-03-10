import 'package:reta/features/declarations/data/models/additional_document.dart';

import '../../../../data/models/declarations_lookups.dart';
import '../../../../data/models/hotel_sub_unit.dart';
import '../../../../data/models/vacant_land_item.dart';

class UnitDataState {
  final String? selectedFloorNumber;
  final bool isFloorNumberOther;
  final String? selectedUnitNumber;
  final bool isUnitNumberOther;
  final bool? contactedTaxAuthority;
  final bool isExempt; // هل الوحدة معفاة؟
  final String? selectedExemptionReason; // سبب الإعفاء
  final bool hasAdditionalDocuments;
  final int additionalUpdateCount;
  final List<AdditionalDocument>? additionalDocuments;
  final String? ownershipDeedFilePath; // سند التمليك
  final String? ownershipDeedOriginalName;
  final String? ownershipDeedFullUrl;
  final String? leaseContractFilePath; // عقد الإيجار
  final String? leaseContractOriginalName;
  final String? leaseContractFullUrl;
  final String? permitPhotoFilePath; // صورة الرخصة/الترخيص
  final String? permitPhotoOriginalName;
  final String? permitPhotoFullUrl;
  final String? selectedUnitSubType; // نوع الوحدة (شقة، فيلا...)
  final List<String>? selectedAmenities; // ملحق بالوحدة
  ///------------------------ وحدة خدمية فقط -----------------------------
  final bool? isServiceUnitExempt;
  final String? selectedServiceExemptionReason;

  ///------------------------ تركيبات ثابتة فقط -----------------------------
  final bool? isTaxpayerOwner; // هل المكلف هو مالك التركيب؟
  final String? selectedInstallationType; // نوع التركيبة

  ///------------------------ أراضي فضاء مستغلة -----------------------------
  final String? selectedExploitationType; // نوع الاستغلال

  ///------------------------ منشآت (مشتركة) -----------------------------
  final int buildingsCount; // عدد المباني
  final String? selectedFacilityActivity; // نوع النشاط

  ///------------------------ منشآت فندقية -----------------------------
  final String? selectedHotelView; // الإطلالة
  final String? selectedStarRating; // مستوى النجومية
  final bool? hasSubUnits; // هل توجد وحدات تابعة؟

  // ── file paths ───────────────────────────
  final String? constructionLicenseFilePath;
  final String? constructionLicenseOriginalName;
  final String? constructionLicenseFullUrl;
  final String? operatingLicenseFilePath;
  final String? operatingLicenseOriginalName;
  final String? operatingLicenseFullUrl;
  final String? starCertificateFilePath;
  final String? starCertificateOriginalName;
  final String? starCertificateFullUrl;
  final String? constructionPermitFilePath;
  final String? constructionPermitOriginalName;
  final String? allAssetsBalanceSheetFilePath;
  final String? allAssetsBalanceSheetOriginalName;
  final String? allAssetsBalanceSheetFullUrl;
  final String? openingBudgetFilePath;
  final String? openingBudgetOriginalName;
  final String? openingBudgetFullUrl;
  final String? allBookBValueFilePath;
  final String? allBookBValueOriginalName;
  final String? allBookBValueFullUrl;
  final String? operationLicenseFilePath;
  final String? operationLicenseOriginalName;
  final String? operationLicenseFullUrl;

  // ── loading / error ──────────────────────
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;
  final bool navigateAfterSave;

  final List<VacantLandItem> vacantLandItems;
  final List<HotelSubUnit> hotelSubUnits;
  final int hotelSubUnitsUpdateCount;
  final int roomsCount;
  final bool? ministryBurden;
  final String? selectedBurdenActivity;
  final String? selectedMineQuarryFacilityTypesValue;
  final String? selectedMineQuarryMaterialsValue;
  final String? allocationContractFilePath;
  final String? allocationContractOriginalName;
  final String? allocationContractFullUrl;
  final int industrialBuildingsCount;
  final int petroBuildingsCount;
  final int productionBuildingsCount;
  final List<DeclarationLookup> buildingFloorList;
  final List<DeclarationLookup> buildingUnitList;
  final bool isFloorLoading;

  const UnitDataState({
    this.selectedFloorNumber,
    this.isFloorNumberOther = false,
    this.selectedUnitNumber,
    this.isUnitNumberOther = false,
    this.contactedTaxAuthority,
    this.isExempt = false,
    this.selectedExemptionReason,
    this.hasAdditionalDocuments = false,
    this.additionalUpdateCount = 0,
    this.additionalDocuments,
    this.ownershipDeedFilePath,
    this.ownershipDeedOriginalName,
    this.ownershipDeedFullUrl,
    this.leaseContractFilePath,
    this.leaseContractOriginalName,
    this.leaseContractFullUrl,
    this.permitPhotoFilePath,
    this.permitPhotoOriginalName,
    this.permitPhotoFullUrl,
    this.isServiceUnitExempt,
    this.selectedServiceExemptionReason,
    this.isTaxpayerOwner,
    this.selectedInstallationType,
    this.selectedExploitationType,
    this.buildingsCount = 1,
    this.selectedFacilityActivity,
    this.selectedHotelView,
    this.selectedStarRating,
    this.hasSubUnits,
    this.constructionLicenseFilePath,
    this.constructionLicenseOriginalName,
    this.constructionLicenseFullUrl,
    this.operatingLicenseFilePath,
    this.operatingLicenseOriginalName,
    this.operatingLicenseFullUrl,
    this.starCertificateFilePath,
    this.starCertificateOriginalName,
    this.starCertificateFullUrl,
    this.constructionPermitFilePath,
    this.constructionPermitOriginalName,
    this.allAssetsBalanceSheetFilePath,
    this.allAssetsBalanceSheetOriginalName,
    this.allAssetsBalanceSheetFullUrl,
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
    this.selectedUnitSubType,
    this.selectedAmenities,
    this.navigateAfterSave = false,
    this.vacantLandItems = const [],
    this.hotelSubUnits = const [],
    this.hotelSubUnitsUpdateCount = 0,
    this.roomsCount = 1,
    this.ministryBurden,
    this.selectedBurdenActivity,
    this.allocationContractFilePath,
    this.allocationContractOriginalName,
    this.allocationContractFullUrl,
    this.openingBudgetFilePath,
    this.openingBudgetOriginalName,
    this.openingBudgetFullUrl,
    this.allBookBValueFilePath,
    this.allBookBValueOriginalName,
    this.allBookBValueFullUrl,
    this.operationLicenseFilePath,
    this.selectedMineQuarryFacilityTypesValue,
    this.selectedMineQuarryMaterialsValue,
    this.operationLicenseOriginalName,
    this.operationLicenseFullUrl,
    this.industrialBuildingsCount = 1,
    this.petroBuildingsCount = 1,
    this.productionBuildingsCount = 1,
    this.buildingFloorList = const [],
    this.buildingUnitList = const [],
    this.isFloorLoading = false,
  });

  static const _undefined = Object();

  UnitDataState copyWith({
    Object? selectedFloorNumber = _undefined,
    bool? isFloorNumberOther,
    Object? selectedUnitNumber = _undefined,
    Object? isUnitNumberOther = _undefined,
    bool? contactedTaxAuthority,
    bool? isExempt,
    String? selectedExemptionReason,
    bool? hasAdditionalDocuments,
    List<AdditionalDocument>? additionalDocuments,
    int? additionalUpdateCount,
    Object? ownershipDeedFilePath = _undefined,
    Object? ownershipDeedOriginalName = _undefined,
    Object? ownershipDeedFullUrl = _undefined,
    Object? leaseContractFilePath = _undefined,
    Object? leaseContractOriginalName = _undefined,
    Object? leaseContractFullUrl = _undefined,
    Object? permitPhotoFilePath = _undefined,
    Object? permitPhotoOriginalName = _undefined,
    Object? permitPhotoFullUrl = _undefined,
    bool? isServiceUnitExempt,
    String? selectedServiceExemptionReason,
    bool? isTaxpayerOwner,
    String? selectedInstallationType,
    String? selectedExploitationType,
    int? buildingsCount,
    String? selectedFacilityActivity,
    String? selectedHotelView,
    String? selectedStarRating,
    bool? hasSubUnits,
    Object? constructionLicenseFilePath = _undefined,
    Object? constructionLicenseOriginalName = _undefined,
    Object? constructionLicenseFullUrl = _undefined,
    Object? operatingLicenseFilePath = _undefined,
    Object? operatingLicenseOriginalName = _undefined,
    Object? operatingLicenseFullUrl = _undefined,
    Object? starCertificateFilePath = _undefined,
    Object? starCertificateOriginalName = _undefined,
    Object? starCertificateFullUrl = _undefined,
    Object? constructionPermitFilePath = _undefined,
    Object? constructionPermitOriginalName = _undefined,
    Object? allAssetsBalanceSheetFilePath = _undefined,
    Object? allAssetsBalanceSheetOriginalName = _undefined,
    Object? allAssetsBalanceSheetFullUrl = _undefined,
    Object? openingBudgetFilePath = _undefined,
    Object? openingBudgetOriginalName = _undefined,
    Object? openingBudgetFullUrl = _undefined,
    Object? allBookBValueFilePath = _undefined,
    Object? allBookBValueOriginalName = _undefined,
    Object? allBookBValueFullUrl = _undefined,
    Object? operationLicenseFilePath = _undefined,
    Object? operationLicenseOriginalName = _undefined,
    Object? operationLicenseFullUrl = _undefined,
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
    String? selectedUnitSubType,
    List<String>? selectedAmenities,
    bool? navigateAfterSave,
    List<VacantLandItem>? vacantLandItems,
    List<HotelSubUnit>? hotelSubUnits,
    int? hotelSubUnitsUpdateCount,
    int? roomsCount,
    bool? ministryBurden,
    String? selectedBurdenActivity,
    Object? allocationContractFilePath = _undefined,
    Object? allocationContractOriginalName = _undefined,
    Object? allocationContractFullUrl = _undefined,
    int? industrialBuildingsCount,
    int? petroBuildingsCount,
    int? productionBuildingsCount,
    String? selectedMineQuarryFacilityTypesValue,
    String? selectedMineQuarryMaterialsValue,
    List<DeclarationLookup>? buildingFloorList,
    List<DeclarationLookup>? buildingUnitList,
    bool? isFloorLoading,
  }) {
    return UnitDataState(
      selectedFloorNumber: selectedFloorNumber == _undefined
          ? this.selectedFloorNumber
          : selectedFloorNumber as String?,
      isFloorNumberOther: isFloorNumberOther ?? this.isFloorNumberOther,
      selectedUnitNumber: selectedUnitNumber == _undefined
          ? this.selectedUnitNumber
          : selectedUnitNumber as String?,
      isUnitNumberOther: isUnitNumberOther == _undefined
          ? this.isUnitNumberOther
          : isUnitNumberOther as bool? ?? false,
      contactedTaxAuthority:
          contactedTaxAuthority ?? this.contactedTaxAuthority,
      isExempt: isExempt ?? this.isExempt,
      selectedExemptionReason:
          selectedExemptionReason ?? this.selectedExemptionReason,
      hasAdditionalDocuments:
          hasAdditionalDocuments ?? this.hasAdditionalDocuments,
      additionalUpdateCount:
          additionalUpdateCount ?? this.additionalUpdateCount,
      additionalDocuments: additionalDocuments ?? this.additionalDocuments,
      ownershipDeedFilePath: ownershipDeedFilePath == _undefined
          ? this.ownershipDeedFilePath
          : ownershipDeedFilePath as String?,
      ownershipDeedOriginalName: ownershipDeedOriginalName == _undefined
          ? this.ownershipDeedOriginalName
          : ownershipDeedOriginalName as String?,
      ownershipDeedFullUrl: ownershipDeedFullUrl == _undefined
          ? this.ownershipDeedFullUrl
          : ownershipDeedFullUrl as String?,
      leaseContractFilePath: leaseContractFilePath == _undefined
          ? this.leaseContractFilePath
          : leaseContractFilePath as String?,
      leaseContractOriginalName: leaseContractOriginalName == _undefined
          ? this.leaseContractOriginalName
          : leaseContractOriginalName as String?,
      leaseContractFullUrl: leaseContractFullUrl == _undefined
          ? this.leaseContractFullUrl
          : leaseContractFullUrl as String?,
      permitPhotoFilePath: permitPhotoFilePath == _undefined
          ? this.permitPhotoFilePath
          : permitPhotoFilePath as String?,
      permitPhotoOriginalName: permitPhotoOriginalName == _undefined
          ? this.permitPhotoOriginalName
          : permitPhotoOriginalName as String?,
      permitPhotoFullUrl: permitPhotoFullUrl == _undefined
          ? this.permitPhotoFullUrl
          : permitPhotoFullUrl as String?,
      operationLicenseOriginalName: operationLicenseOriginalName == _undefined
          ? this.operationLicenseOriginalName
          : operationLicenseOriginalName as String?,
      operationLicenseFullUrl: operationLicenseFullUrl == _undefined
          ? this.operationLicenseFullUrl
          : operationLicenseFullUrl as String?,
      operationLicenseFilePath: operationLicenseFilePath == _undefined
          ? this.operationLicenseFilePath
          : operationLicenseFilePath as String?,
      isServiceUnitExempt: isServiceUnitExempt ?? this.isServiceUnitExempt,
      selectedServiceExemptionReason:
          selectedServiceExemptionReason ?? this.selectedServiceExemptionReason,
      isTaxpayerOwner: isTaxpayerOwner ?? this.isTaxpayerOwner,
      selectedInstallationType:
          selectedInstallationType ?? this.selectedInstallationType,
      selectedExploitationType:
          selectedExploitationType ?? this.selectedExploitationType,
      buildingsCount: buildingsCount ?? this.buildingsCount,
      selectedFacilityActivity:
          selectedFacilityActivity ?? this.selectedFacilityActivity,
      selectedHotelView: selectedHotelView ?? this.selectedHotelView,
      selectedStarRating: selectedStarRating ?? this.selectedStarRating,
      hasSubUnits: hasSubUnits ?? this.hasSubUnits,
      constructionLicenseFilePath: constructionLicenseFilePath == _undefined
          ? this.constructionLicenseFilePath
          : constructionLicenseFilePath as String?,
      constructionLicenseOriginalName:
          constructionLicenseOriginalName == _undefined
          ? this.constructionLicenseOriginalName
          : constructionLicenseOriginalName as String?,
      constructionLicenseFullUrl: constructionLicenseFullUrl == _undefined
          ? this.constructionLicenseFullUrl
          : constructionLicenseFullUrl as String?,
      operatingLicenseFilePath: operatingLicenseFilePath == _undefined
          ? this.operatingLicenseFilePath
          : operatingLicenseFilePath as String?,
      operatingLicenseOriginalName: operatingLicenseOriginalName == _undefined
          ? this.operatingLicenseOriginalName
          : operatingLicenseOriginalName as String?,
      operatingLicenseFullUrl: operatingLicenseFullUrl == _undefined
          ? this.operatingLicenseFullUrl
          : operatingLicenseFullUrl as String?,
      starCertificateFilePath: starCertificateFilePath == _undefined
          ? this.starCertificateFilePath
          : starCertificateFilePath as String?,
      starCertificateOriginalName: starCertificateOriginalName == _undefined
          ? this.starCertificateOriginalName
          : starCertificateOriginalName as String?,
      starCertificateFullUrl: starCertificateFullUrl == _undefined
          ? this.starCertificateFullUrl
          : starCertificateFullUrl as String?,
      constructionPermitFilePath: constructionPermitFilePath == _undefined
          ? this.constructionPermitFilePath
          : constructionPermitFilePath as String?,
      constructionPermitOriginalName:
          constructionPermitOriginalName == _undefined
          ? this.constructionPermitOriginalName
          : constructionPermitOriginalName as String?,
      allAssetsBalanceSheetFilePath: allAssetsBalanceSheetFilePath == _undefined
          ? this.allAssetsBalanceSheetFilePath
          : allAssetsBalanceSheetFilePath as String?,
      allAssetsBalanceSheetOriginalName:
          allAssetsBalanceSheetOriginalName == _undefined
          ? this.allAssetsBalanceSheetOriginalName
          : allAssetsBalanceSheetOriginalName as String?,
      allAssetsBalanceSheetFullUrl: allAssetsBalanceSheetFullUrl == _undefined
          ? this.allAssetsBalanceSheetFullUrl
          : allAssetsBalanceSheetFullUrl as String?,
      openingBudgetFilePath: openingBudgetFilePath == _undefined
          ? this.openingBudgetFilePath
          : openingBudgetFilePath as String?,
      openingBudgetOriginalName: openingBudgetOriginalName == _undefined
          ? this.openingBudgetOriginalName
          : openingBudgetOriginalName as String?,
      openingBudgetFullUrl: openingBudgetFullUrl == _undefined
          ? this.openingBudgetFullUrl
          : openingBudgetFullUrl as String?,
      allBookBValueOriginalName: allBookBValueOriginalName == _undefined
          ? this.allBookBValueOriginalName
          : allBookBValueOriginalName as String?,
      allBookBValueFullUrl: allBookBValueFullUrl == _undefined
          ? this.allBookBValueFullUrl
          : allBookBValueFullUrl as String?,
      allBookBValueFilePath: allBookBValueFilePath == _undefined
          ? this.allBookBValueFilePath
          : allBookBValueFilePath as String?,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      successMessage: successMessage,
      selectedAmenities: selectedAmenities ?? this.selectedAmenities,
      selectedUnitSubType: selectedUnitSubType ?? this.selectedUnitSubType,
      navigateAfterSave: navigateAfterSave ?? this.navigateAfterSave,
      vacantLandItems: vacantLandItems ?? this.vacantLandItems,
      hotelSubUnits: hotelSubUnits ?? this.hotelSubUnits,
      hotelSubUnitsUpdateCount:
          hotelSubUnitsUpdateCount ?? this.hotelSubUnitsUpdateCount,
      roomsCount: roomsCount ?? this.roomsCount,
      ministryBurden: ministryBurden ?? this.ministryBurden,
      selectedBurdenActivity:
          selectedBurdenActivity ?? this.selectedBurdenActivity,
      allocationContractFilePath: allocationContractFilePath == _undefined
          ? this.allocationContractFilePath
          : allocationContractFilePath as String?,
      allocationContractOriginalName:
          allocationContractOriginalName == _undefined
          ? this.allocationContractOriginalName
          : allocationContractOriginalName as String?,
      allocationContractFullUrl: allocationContractFullUrl == _undefined
          ? this.allocationContractFullUrl
          : allocationContractFullUrl as String?,
      industrialBuildingsCount:
          industrialBuildingsCount ?? this.industrialBuildingsCount,
      petroBuildingsCount: petroBuildingsCount ?? this.petroBuildingsCount,
      selectedMineQuarryFacilityTypesValue:
          selectedMineQuarryFacilityTypesValue ??
          this.selectedMineQuarryFacilityTypesValue,
      selectedMineQuarryMaterialsValue:
          selectedMineQuarryMaterialsValue ??
          this.selectedMineQuarryMaterialsValue,
      productionBuildingsCount:
          productionBuildingsCount ?? this.productionBuildingsCount,
      buildingFloorList: buildingFloorList ?? this.buildingFloorList,
      buildingUnitList: buildingUnitList ?? this.buildingUnitList,
      isFloorLoading: isFloorLoading ?? this.isFloorLoading,
    );
  }
}
