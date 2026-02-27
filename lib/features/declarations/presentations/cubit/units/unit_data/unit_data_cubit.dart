import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reta/core/network/api_constants.dart';
import 'package:uuid/uuid.dart';

import '../../../../../../core/helpers/app_enum.dart';
import '../../../../../../core/helpers/extensions/unit_type.dart';
import '../../../../../../core/network/api_result.dart';
import '../../../../../../core/services/declaration_service.dart';
import '../../../../../../core/services/upload_service.dart';
import '../../../../data/models/additional_document.dart';
import '../../../../data/models/building_info.dart';
import '../../../../data/models/declarations_lookups.dart';
import '../../applicant_cubit.dart';
import '../../declaration_lookups_cubit.dart';
import '../location/unit_location_cubit.dart';
import 'unit_data_state.dart';

const String kYes = 'نعم';
const String kNo = 'لا';

class UnitDataCubit extends Cubit<UnitDataState> {
  UnitDataCubit({required this.lookups, required this.declarationId})
    : super(const UnitDataState());

  final DeclarationLookupsModel lookups;
  final int declarationId;

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
  final facilityCodeController = TextEditingController(); // كود حساب المنشأة
  final activityTypeController = TextEditingController(); // نوع النشاط
  final facilityMarketValueController =
      TextEditingController(); // القيمة السوقية للمنشأة

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

  // ─────────────────────────────────────────
  // Controllers - منشآت بترولية
  // ─────────────────────────────────────────
  final usageTypeController = TextEditingController(); // نوع الاستخدام
  final bookValueController = TextEditingController(); // التكلفة الدفترية للأرض

  // ─────────────────────────────────────────
  // Dynamic Lists
  // ─────────────────────────────────────────
  final List<AdditionalDocument> additionalDocuments = [];
  final List<BuildingInfo> buildings = [];

  // ─────────────────────────────────────────
  // Real and Mock Data
  // ─────────────────────────────────────────
  List<String> get residentialUnitTypes =>
      lookups.residentialUnitTypes.map((e) => e.name).toList();

  List<String> get amenities =>
      lookups.unitAttachments.map((e) => e.name).toList();

  List<String> get floorNumbers => [
    ...lookups.realEstateFloors.map((e) => e.name),
    'أخرى',
  ];

  List<String> get exemptionReasons =>
      lookups.exemptionReasons.map((e) => e.name).toList();

  List<String> get installationTypes =>
      lookups.installationTypes.map((e) => e.name).toList();
  final List<String> unitNumbers = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '10',
    '15',
    '20',
    'أخرى',
  ];
  final List<String> yesNoOptions = [kYes, kNo];

  final List<String> exploitationTypes = [
    'تشوينات',
    'جراج',
    'ساحة انتظار',
    'شبكات محمول',
    'ماكينة صراف آلي',
    'لوحة إعلانات',
    'أخرى',
  ];

  final List<String> starRatings = [
    'نجمة واحدة',
    'نجمتان',
    'ثلاث نجوم',
    'أربع نجوم',
    'خمس نجوم',
    'ست نجوم',
    'سبع نجوم',
  ];

  final List<String> hotelViews = ['مطل على النيل', 'مطل على البحر', 'غير مطل'];

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

  // ─────────────────────────────────────────
  // Actions - مشتركة
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

  void selectFloorNumber(String? value) {
    final isOther = value == 'أخرى';
    emit(
      state.copyWith(selectedFloorNumber: value, isFloorNumberOther: isOther),
    );
    if (!isOther) floorNumberOtherController.clear();
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

  void setIsTaxpayerOwner(bool? value) {
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

  // ─────────────────────────────────────────
  // Actions - منشآت
  // ─────────────────────────────────────────

  void incrementBuildings() {
    final newBuilding = BuildingInfo(id: _uuid.v4());
    buildings.add(newBuilding);
    emit(state.copyWith(buildingsCount: buildings.length));
  }

  void decrementBuildings() {
    if (buildings.length > 1) {
      buildings.last.dispose();
      buildings.removeLast();
      emit(state.copyWith(buildingsCount: buildings.length));
    }
  }

  void selectHotelView(String? value) {
    emit(state.copyWith(selectedHotelView: value));
  }

  void selectStarRating(String? value) {
    emit(state.copyWith(selectedStarRating: value));
  }

  void setHasSubUnits(bool? value) {
    emit(state.copyWith(hasSubUnits: value));
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

  void setAdditionalDocumentFile(String id, String path) {
    final index = additionalDocuments.indexWhere((doc) => doc.id == id);
    additionalDocuments[index].filePath = path;
    emit(
      state.copyWith(
        hasAdditionalDocuments: state.hasAdditionalDocuments,
        additionalDocuments: additionalDocuments,
        additionalUpdateCount: (state.additionalUpdateCount + 1),
      ),
    );
  }

  // ─────────────────────────────────────────
  // File Actions
  // ─────────────────────────────────────────

  Future<String?> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'pdf'],
    );
    if (result != null && result.files.isNotEmpty) {
      return result.files.single.path;
    }
    return null;
  }

  void changePrivateResidence() =>
      emit(state.copyWith(isExempt: !state.isExempt));

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
        ),
      ),
    );
  }

  Future<void> setConstructionPermitFile(String path) async {
    emit(state.copyWith(isLoading: true));
    final result = await UploadService.instance.uploadFile(
      filePath: path,
      label: 'construction_permit',
    );
    _handleUploadResult(
      result,
      onSuccess: (data) => emit(
        state.copyWith(
          isLoading: false,
          constructionPermitFilePath: data.path,
          constructionPermitOriginalName: data.originalFileName,
        ),
      ),
    );
  }

  Future<void> setAllAssetsBalanceSheetFile(String path) async {
    emit(state.copyWith(isLoading: true));
    final result = await UploadService.instance.uploadFile(
      filePath: path,
      label: 'balance_sheet',
    );
    _handleUploadResult(
      result,
      onSuccess: (data) => emit(
        state.copyWith(
          isLoading: false,
          allAssetsBalanceSheetFilePath: data.path,
          allAssetsBalanceSheetOriginalName: data.originalFileName,
        ),
      ),
    );
  }

  void removeOwnershipDeedFile() =>
      emit(state.copyWith(ownershipDeedFilePath: null));
  void removeLeaseContractFile() =>
      emit(state.copyWith(leaseContractFilePath: null));
  void removePermitPhotoFile() =>
      emit(state.copyWith(ownershipDeedFilePath: null));
  void removeConstructionLicenseFile() =>
      emit(state.copyWith(leaseContractFilePath: null));
  void removeOperatingLicenseFile() =>
      emit(state.copyWith(ownershipDeedFilePath: null));
  void removeStarCertificateFile() =>
      emit(state.copyWith(leaseContractFilePath: null));
  void removeConstructionPermitFile() =>
      emit(state.copyWith(ownershipDeedFilePath: null));
  void removeAllAssetsBalanceSheetFile() =>
      emit(state.copyWith(leaseContractFilePath: null));

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

    // ── كود حساب الوحدة (14 رقم لو موجود) ──────────
    final unitCode = unitCodeController.text.trim();
    if (unitCode.isNotEmpty && unitCode.length != 14) {
      emit(
        state.copyWith(errorMessage: 'كود حساب الوحدة يجب أن يكون 14 رقماً'),
      );
      return false;
    }

    // ── سند تمليك الوحدة (required) ──────────────────
    if (state.ownershipDeedFilePath == null) {
      emit(state.copyWith(errorMessage: 'يرجى رفع سند تمليك الوحدة'));
      return false;
    }

    // ── المستندات الداعمة لو اختار نعم ───────────────
    if (state.hasAdditionalDocuments) {
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
    }

    return true;
  }

  Map<String, dynamic> buildPayload(UnitType unitType) {
    final base = {
      'unitType': unitType.label,
      'privateResidence': state.isExempt,
      'floorNumber': state.isFloorNumberOther
          ? floorNumberOtherController.text.trim()
          : state.selectedFloorNumber,
      'floorNumberText': floorNumberController.text.trim(),
      'unitNumber': state.isUnitNumberOther
          ? unitNumberOtherController.text.trim()
          : state.selectedUnitNumber,
      'unitNumberText': unitNumberController.text.trim(),
      'contactedTaxAuthority': state.contactedTaxAuthority,
      'unitCode': unitCodeController.text.trim(),
      'marketValue': marketValueController.text.trim(),
      'isExempt': state.isExempt,
      'exemptionReason': state.selectedExemptionReason,
      'lawNumber': lawNumberController.text.trim(),
      'lawYear': lawYearController.text.trim(),
      'ownershipDeedFile': state.ownershipDeedFilePath,
      'leaseContractFile': state.leaseContractFilePath,
      'additionalDocuments': additionalDocuments
          .map(
            (d) => {'name': d.nameController.text.trim(), 'file': d.filePath},
          )
          .toList(),
    };

    switch (unitType) {
      case UnitType.fixedInstallations:
        return {
          ...base,
          'installationType': state.selectedInstallationType,
          'isTaxpayerOwner': state.isTaxpayerOwner,
          'installationOwner': installationOwnerController.text.trim(),
          'contractStartDate': contractStartDateController.text.trim(),
          'contractEndDate': contractEndDateController.text.trim(),
          'annualRentalValue': annualRentalValueController.text.trim(),
        };
      case UnitType.vacantLand:
        return {
          ...base,
          'totalLandArea': totalLandAreaController.text.trim(),
          'exploitedArea': exploitedAreaController.text.trim(),
          'exploitationType': state.selectedExploitationType,
        };
      case UnitType.hotelFacility:
        return {
          ...base,
          'facilityName': facilityNameController.text.trim(),
          'hotelView': state.selectedHotelView,
          'starRating': state.selectedStarRating,
          'buildingsCount': buildings.length,
          'buildings': buildings
              .map(
                (b) => {
                  'floors': b.floorsCount,
                  'area': b.areaController.text.trim(),
                  'marketValue': b.marketValueController.text.trim(),
                },
              )
              .toList(),
          'constructionLicenseFile': state.constructionLicenseFilePath,
          'operatingLicenseFile': state.operatingLicenseFilePath,
          'starCertificateFile': state.starCertificateFilePath,
          'hasSubUnits': state.hasSubUnits,
        };
      case UnitType.industrialFacility:
      case UnitType.productionFacility:
        return {
          ...base,
          'facilityName': facilityNameController.text.trim(),
          'activityType': activityTypeController.text.trim(),
          'totalLandArea': totalLandAreaFacilityController.text.trim(),
          'exploitedLandArea': exploitedLandAreaController.text.trim(),
          'buildingsCount': buildings.length,
          'buildings': buildings
              .map(
                (b) => {
                  'floors': b.floorsCount,
                  'area': b.areaController.text.trim(),
                },
              )
              .toList(),
          'constructionLicenseFile': state.constructionLicenseFilePath,
          'operatingLicenseFile': state.operatingLicenseFilePath,
          'constructionPermitFile': state.constructionPermitFilePath,
        };
      case UnitType.petroleumFacility:
        return {
          ...base,
          'facilityName': facilityNameController.text.trim(),
          'usageType': usageTypeController.text.trim(),
          'totalLandArea': totalLandAreaFacilityController.text.trim(),
          'bookValue': bookValueController.text.trim(),
          'buildingsCount': buildings.length,
          'allAssetsBalanceSheetFile': state.allAssetsBalanceSheetFilePath,
        };
      default:
        return {
          ...base,
          'area': areaController.text.trim(),
          'permitPhotoFile': state.permitPhotoFilePath,
        };
    }
  }

  Future<void> submit(BuildContext context, UnitType unitType) async {
    final applicantCubit = context.read<ApplicantCubit>();
    final locationCubit = context.read<UnitLocationCubit>();
    final lookups = context.read<DeclarationLookupsCubit>().lookups!;

    emit(state.copyWith(isLoading: true));
    // نوع العقار من الـ lookups
    final propertyTypeId = lookups.propertyTypes
        .firstWhere(
          (p) => p.name == unitType.label,
          orElse: () => DeclarationLookup(id: 1, name: ''),
        )
        .id;

    final payload = {
      ...applicantCubit.buildPayload(),
      'unit': {
        'property_type_id': propertyTypeId,
        ...locationCubit.buildLocationPayload(),
        ..._buildUnitPayload(unitType, lookups),
      },
    };

    log('Final Payload: $payload');
    final result = await DeclarationService.instance.createDeclaration(
      payload,
      declarationId: declarationId,
    );

    switch (result) {
      case ApiSuccess(:final data):
        log('Declaration created: $data');
        emit(
          state.copyWith(
            isLoading: false,
            successMessage: 'تم حفظ الإقرار بنجاح',
          ),
        );
      // TODO: navigate to success page
      case ApiError(:final message):
        log('Failed to create declaration: $message');
        emit(state.copyWith(isLoading: false, errorMessage: message));
    }
  }

  Map<String, dynamic> _buildUnitPayload(
    UnitType unitType,
    DeclarationLookupsModel lookups,
  ) {
    switch (unitType) {
      case UnitType.residential:
        return buildResidentialPayload(lookups);
      case UnitType.commercial:
      case UnitType.administrative:
      case UnitType.serviceUnit:
        return buildCommercialPayload(lookups);
      case UnitType.fixedInstallations:
        return buildFixedInstallationsPayload();
      case UnitType.vacantLand:
        return buildVacantLandPayload();
      case UnitType.serviceFacility:
      case UnitType.industrialFacility:
      case UnitType.productionFacility:
        return buildFacilityPayload(lookups);
      case UnitType.hotelFacility:
        return buildHotelPayload(lookups);
      case UnitType.petroleumFacility:
        return buildPetroleumPayload();
      case UnitType.minesAndQuarries:
        return buildMinesPayload();
      default:
        return buildResidentialPayload(lookups);
    }
  }

  Map<String, dynamic> buildResidentialPayload(
    DeclarationLookupsModel lookups,
  ) {
    // نوع الوحدة
    final unitTypeId = lookups.residentialUnitTypes
        .firstWhere(
          (t) => t.name == state.selectedUnitSubType,
          orElse: () => DeclarationLookup(id: -1, name: ''),
        )
        .id;

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

    return {
      ..._buildBaseUnitPayload(),
      'usage_type': 'سكني',
      'area': double.tryParse(areaController.text.trim()) ?? 0,
      'unit_type_id': unitTypeId,
      'attachments': attachmentIds,
      'exempted_as_private_residence': state.isExempt,
      'exempted_as_residence': state.isExempt,
      if (state.ownershipDeedFilePath != null)
        'ownership_deed': {
          'path': state.ownershipDeedFilePath,
          'original_file_name': state.ownershipDeedOriginalName,
        },
      if (state.leaseContractFilePath != null)
        'lease_contract': {
          'path': state.leaseContractFilePath,
          'original_file_name': state.leaseContractOriginalName,
        },
      ..._buildSupportingDocsPayload(),
    };
  }

  // وحدة تجارية / إدارية / خدمية
  Map<String, dynamic> buildCommercialPayload(DeclarationLookupsModel lookups) {
    return {
      ..._buildBaseUnitPayload(),
      'usage_type': 'غير سكني',
      'area': double.tryParse(areaController.text.trim()) ?? 0,
      'activity_type': activityTypeController.text.trim(),
      if (state.ownershipDeedFilePath != null)
        'ownership_deed': {
          'path': state.ownershipDeedFilePath,
          'original_file_name': state.ownershipDeedOriginalName,
        },
      if (state.leaseContractFilePath != null)
        'lease_contract': {
          'path': state.leaseContractFilePath,
          'original_file_name': state.leaseContractOriginalName,
        },
      if (state.permitPhotoFilePath != null)
        'license_photo': {
          'path': state.permitPhotoFilePath,
          'original_file_name': state.permitPhotoOriginalName,
        },
      ..._buildSupportingDocsPayload(),
    };
  }

  // تركيبات ثابتة
  Map<String, dynamic> buildFixedInstallationsPayload() {
    return {
      ..._buildBaseUnitPayload(),
      'installation_type': state.selectedInstallationType,
      'is_taxpayer_owner': state.isTaxpayerOwner,
      'installation_owner': installationOwnerController.text.trim(),
      'contract_start_date': contractStartDateController.text.trim(),
      'contract_end_date': contractEndDateController.text.trim(),
      'annual_rental_value': annualRentalValueController.text.trim(),
      if (state.ownershipDeedFilePath != null)
        'ownership_deed': {
          'path': state.ownershipDeedFilePath,
          'original_file_name': state.ownershipDeedOriginalName,
        },
      ..._buildSupportingDocsPayload(),
    };
  }

  // أراضي فضاء مستغلة
  Map<String, dynamic> buildVacantLandPayload() {
    return {
      ..._buildBaseUnitPayload(),
      'total_land_area':
          double.tryParse(totalLandAreaController.text.trim()) ?? 0,
      'exploited_area':
          double.tryParse(exploitedAreaController.text.trim()) ?? 0,
      'exploitation_type': state.selectedExploitationType,
      if (state.ownershipDeedFilePath != null)
        'ownership_deed': {
          'path': state.ownershipDeedFilePath,
          'original_file_name': state.ownershipDeedOriginalName,
        },
      ..._buildSupportingDocsPayload(),
    };
  }

  // منشآت فندقية
  Map<String, dynamic> buildHotelPayload(DeclarationLookupsModel lookups) {
    return {
      ..._buildBaseUnitPayload(),
      'facility_name': facilityNameController.text.trim(),
      'hotel_view': state.selectedHotelView,
      'star_rating': state.selectedStarRating,
      'buildings_count': buildings.length,
      'buildings': buildings
          .map(
            (b) => {
              'floors': b.floorsCount,
              'area': b.areaController.text.trim(),
              'market_value': b.marketValueController.text.trim(),
            },
          )
          .toList(),
      if (state.constructionLicenseFilePath != null)
        'construction_license': {
          'path': state.constructionLicenseFilePath,
          'original_file_name': state.constructionLicenseOriginalName,
        },
      if (state.operatingLicenseFilePath != null)
        'operating_license': {
          'path': state.operatingLicenseFilePath,
          'original_file_name': state.operatingLicenseOriginalName,
        },
      if (state.starCertificateFilePath != null)
        'star_certificate': {
          'path': state.starCertificateFilePath,
          'original_file_name': state.starCertificateOriginalName,
        },
      'has_sub_units': state.hasSubUnits,
      ..._buildSupportingDocsPayload(),
    };
  }

  // منشآت صناعية / إنتاجية
  Map<String, dynamic> buildFacilityPayload(DeclarationLookupsModel lookups) {
    return {
      ..._buildBaseUnitPayload(),
      'facility_name': facilityNameController.text.trim(),
      'activity_type': activityTypeController.text.trim(),
      'total_land_area': totalLandAreaFacilityController.text.trim(),
      'exploited_land_area': exploitedLandAreaController.text.trim(),
      'buildings_count': buildings.length,
      'buildings': buildings
          .map(
            (b) => {
              'floors': b.floorsCount,
              'area': b.areaController.text.trim(),
            },
          )
          .toList(),
      if (state.constructionLicenseFilePath != null)
        'construction_license': {
          'path': state.constructionLicenseFilePath,
          'original_file_name': state.constructionLicenseOriginalName,
        },
      if (state.operatingLicenseFilePath != null)
        'operating_license': {
          'path': state.operatingLicenseFilePath,
          'original_file_name': state.operatingLicenseOriginalName,
        },
      ..._buildSupportingDocsPayload(),
    };
  }

  // منشآت بترولية
  Map<String, dynamic> buildPetroleumPayload() {
    return {
      ..._buildBaseUnitPayload(),
      'facility_name': facilityNameController.text.trim(),
      'usage_type': usageTypeController.text.trim(),
      'total_land_area': totalLandAreaFacilityController.text.trim(),
      'book_value': bookValueController.text.trim(),
      'buildings_count': buildings.length,
      if (state.allAssetsBalanceSheetFilePath != null)
        'all_assets_balance_sheet': {
          'path': state.allAssetsBalanceSheetFilePath,
          'original_file_name': 'ميزانية',
        },
      ..._buildSupportingDocsPayload(),
    };
  }

  // مناجم ومحاجر
  Map<String, dynamic> buildMinesPayload() {
    return {..._buildBaseUnitPayload(), ..._buildSupportingDocsPayload()};
  }

  // ── Helpers مشتركة ───────────────────────────────────
  Map<String, dynamic> _buildBaseUnitPayload() {
    final floorId = state.isFloorNumberOther ? -1 : _getFloorId();
    log("Floor id: $floorId - ${_getFloorId()}");
    return {
      'real_estate_floor_id': floorId,
      if (state.isFloorNumberOther)
        'real_estate_floor_other': floorNumberOtherController.text.trim(),
      'unit_id': state.isUnitNumberOther
          ? -1
          : int.tryParse(state.selectedUnitNumber ?? '') ?? -1,
      if (state.isUnitNumberOther)
        'unit_other': unitNumberOtherController.text.trim(),
      'reta_contact_about_unit': state.contactedTaxAuthority == true ? 1 : 2,
      'account_code': unitCodeController.text.trim().isEmpty
          ? null
          : unitCodeController.text.trim(),
      'market_value': double.tryParse(marketValueController.text.trim()),
      'submit_other_supporting_documents': state.hasAdditionalDocuments ? 1 : 2,
    };
  }

  Map<String, dynamic> _buildSupportingDocsPayload() {
    if (additionalDocuments.isEmpty) return {};
    final docs = additionalDocuments
        .where((d) => d.nameController.text.isNotEmpty && d.filePath != null)
        .map(
          (d) => {
            'name': d.nameController.text.trim(),
            'path': d.filePath,
            'original_file_name': d.nameController.text.trim(),
          },
        )
        .toList();
    if (docs.isEmpty) return {};
    return {'supporting_documents': docs};
  }

  int _getFloorId() {
    int floorId = lookups.realEstateFloors
        .firstWhere(
          (a) => a.name == state.selectedFloorNumber,
          orElse: () => DeclarationLookup(id: 0, name: ''),
        )
        .id;
    return floorId;
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
    for (final doc in additionalDocuments) doc.dispose();
    for (final building in buildings) building.dispose();
    return super.close();
  }

  void clearError() => emit(state.copyWith(errorMessage: null));
}
