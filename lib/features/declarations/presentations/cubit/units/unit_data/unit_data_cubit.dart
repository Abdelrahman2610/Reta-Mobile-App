import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../../../../core/helpers/app_enum.dart';
import '../../../../../../core/helpers/extensions/unit_type.dart';
import '../../../../data/models/additional_document.dart';
import '../../../../data/models/building_info.dart';
import 'unit_data_state.dart';

const String kYes = 'نعم';
const String kNo = 'لا';

class UnitDataCubit extends Cubit<UnitDataState> {
  UnitDataCubit() : super(const UnitDataState());

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
  // Mock Data
  // ─────────────────────────────────────────
  final List<String> residentialUnitTypes = [
    'شقة',
    'فيلا',
    'دوبلكس',
    'بنتهاوس',
    'استوديو',
    'شاليه',
    'تاون هاوس',
    'توين هاوس',
    'سكن إداري',
    'أخرى',
  ];

  final List<String> amenities = [
    'جراج',
    'حديقة',
    'روف',
    'حمام سباحة',
    'بدروم',
    'غرفة سائق',
    'غرفة حارس',
    'غرفة سطح',
  ];
  final List<String> floorNumbers = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    'أخرى',
  ];
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

  final List<String> exemptionReasons = [
    'الأبنية المملوكة للجمعيات المسجلة وفقاً للقانون',
    'المنظمات العمالية المخصصة لمكاتب إدارتها',
    'المؤسسات التعليمية التي لا تهدف إلى الربح',
    'المستشفيات التي لا تهدف إلى الربح',
    'المستوصفات والملاجئ التي لا تهدف إلى الربح',
    'المقار المملوكة للأحزاب السياسية',
    'المقار المملوكة للنقابات المهنية',
    'أبنية مراكز الشباب والرياضة',
    'العقارات المملوكة للجهات الحكومية الأجنبية',
    'الدور المخصصة لاستخدامها في مناسبات اجتماعية',
    'إعفاء بقانون خاص',
  ];

  final List<String> installationTypes = ['شبكات محمول', 'إعلانات', 'أخرى'];

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
    additionalDocuments.add(AdditionalDocument(id: _uuid.v4()));
    emit(
      state.copyWith(
        hasAdditionalDocuments: state.hasAdditionalDocuments,
        additionalDocuments: additionalDocuments,
        additionalUpdateCount: (state.additionalUpdateCount + 1),
      ),
    );
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
  void setOwnershipDeedFile(String? path) =>
      emit(state.copyWith(ownershipDeedFilePath: path));
  void setLeaseContractFile(String? path) =>
      emit(state.copyWith(leaseContractFilePath: path));
  void setPermitPhotoFile(String? path) =>
      emit(state.copyWith(permitPhotoFilePath: path));
  void setConstructionLicenseFile(String? path) =>
      emit(state.copyWith(constructionLicenseFilePath: path));
  void setOperatingLicenseFile(String? path) =>
      emit(state.copyWith(operatingLicenseFilePath: path));
  void setStarCertificateFile(String? path) =>
      emit(state.copyWith(starCertificateFilePath: path));
  void setConstructionPermitFile(String? path) =>
      emit(state.copyWith(constructionPermitFilePath: path));
  void setAllAssetsBalanceSheetFile(String? path) =>
      emit(state.copyWith(allAssetsBalanceSheetFilePath: path));

  // ─────────────────────────────────────────
  // Validation & Submit
  // ─────────────────────────────────────────

  bool validate() => formKey.currentState?.validate() ?? false;

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
}
