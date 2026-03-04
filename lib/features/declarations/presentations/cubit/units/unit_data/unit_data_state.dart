import 'package:reta/features/declarations/data/models/additional_document.dart';

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
  final String? leaseContractFilePath; // عقد الإيجار
  final String? leaseContractOriginalName;
  final String? permitPhotoFilePath; // صورة الرخصة/الترخيص
  final String? permitPhotoOriginalName;
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
  final String? operatingLicenseFilePath;
  final String? operatingLicenseOriginalName;
  final String? starCertificateFilePath;
  final String? starCertificateOriginalName;
  final String? constructionPermitFilePath;
  final String? constructionPermitOriginalName;
  final String? allAssetsBalanceSheetFilePath;
  final String? allAssetsBalanceSheetOriginalName;

  // ── loading / error ──────────────────────
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;
  final bool navigateAfterSave;
  final List<VacantLandItem> vacantLandItems;

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
    this.leaseContractFilePath,
    this.leaseContractOriginalName,
    this.permitPhotoFilePath,
    this.permitPhotoOriginalName,
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
    this.operatingLicenseFilePath,
    this.operatingLicenseOriginalName,
    this.starCertificateFilePath,
    this.starCertificateOriginalName,
    this.constructionPermitFilePath,
    this.constructionPermitOriginalName,
    this.allAssetsBalanceSheetFilePath,
    this.allAssetsBalanceSheetOriginalName,
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
    this.selectedUnitSubType,
    this.selectedAmenities,
    this.navigateAfterSave = false,
    this.vacantLandItems = const [],
  });

  static const _undefined = Object();

  UnitDataState copyWith({
    String? selectedFloorNumber,
    bool? isFloorNumberOther,
    String? selectedUnitNumber,
    bool? isUnitNumberOther,
    bool? contactedTaxAuthority,
    bool? isExempt,
    String? selectedExemptionReason,
    bool? hasAdditionalDocuments,
    List<AdditionalDocument>? additionalDocuments,
    int? additionalUpdateCount,
    Object? ownershipDeedFilePath = _undefined,
    Object? ownershipDeedOriginalName = _undefined,
    Object? leaseContractFilePath = _undefined,
    Object? leaseContractOriginalName = _undefined,
    Object? permitPhotoFilePath = _undefined,
    Object? permitPhotoOriginalName = _undefined,
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
    Object? operatingLicenseFilePath = _undefined,
    Object? operatingLicenseOriginalName = _undefined,
    Object? starCertificateFilePath = _undefined,
    Object? starCertificateOriginalName = _undefined,
    Object? constructionPermitFilePath = _undefined,
    Object? constructionPermitOriginalName = _undefined,
    Object? allAssetsBalanceSheetFilePath = _undefined,
    Object? allAssetsBalanceSheetOriginalName = _undefined,
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
    String? selectedUnitSubType,
    List<String>? selectedAmenities,
    bool? navigateAfterSave,
    List<VacantLandItem>? vacantLandItems,
  }) {
    return UnitDataState(
      selectedFloorNumber: selectedFloorNumber ?? this.selectedFloorNumber,
      isFloorNumberOther: isFloorNumberOther ?? this.isFloorNumberOther,
      selectedUnitNumber: selectedUnitNumber ?? this.selectedUnitNumber,
      isUnitNumberOther: isUnitNumberOther ?? this.isUnitNumberOther,
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
      leaseContractFilePath: leaseContractFilePath == _undefined
          ? this.leaseContractFilePath
          : leaseContractFilePath as String?,
      leaseContractOriginalName: leaseContractOriginalName == _undefined
          ? this.leaseContractOriginalName
          : leaseContractOriginalName as String?,
      permitPhotoFilePath: permitPhotoFilePath == _undefined
          ? this.permitPhotoFilePath
          : permitPhotoFilePath as String?,
      permitPhotoOriginalName: permitPhotoOriginalName == _undefined
          ? this.permitPhotoOriginalName
          : permitPhotoOriginalName as String?,
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
      operatingLicenseFilePath: operatingLicenseFilePath == _undefined
          ? this.operatingLicenseFilePath
          : operatingLicenseFilePath as String?,
      operatingLicenseOriginalName: operatingLicenseOriginalName == _undefined
          ? this.operatingLicenseOriginalName
          : operatingLicenseOriginalName as String?,
      starCertificateFilePath: starCertificateFilePath == _undefined
          ? this.starCertificateFilePath
          : starCertificateFilePath as String?,
      starCertificateOriginalName: starCertificateOriginalName == _undefined
          ? this.starCertificateOriginalName
          : starCertificateOriginalName as String?,
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
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      successMessage: successMessage,
      selectedAmenities: selectedAmenities ?? this.selectedAmenities,
      selectedUnitSubType: selectedUnitSubType ?? this.selectedUnitSubType,
      navigateAfterSave: navigateAfterSave ?? this.navigateAfterSave,
      vacantLandItems: vacantLandItems ?? this.vacantLandItems,
    );
  }
}
