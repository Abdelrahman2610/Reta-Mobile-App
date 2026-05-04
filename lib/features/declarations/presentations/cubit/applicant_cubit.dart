import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:reta/core/network/api_constants.dart';
import 'package:reta/core/network/api_result.dart';
import 'package:reta/features/auth/data/models/user_models.dart';
import 'package:reta/features/declarations/presentations/cubit/declaration_lookups_cubit.dart';
import 'package:reta/features/declarations/presentations/pages/select_types_of_properties_page.dart';

import '../../../../core/helpers/app_enum.dart';
import '../../../../core/helpers/extensions/applicant_type.dart';
import '../../../../core/helpers/extensions/nationality.dart';
import '../../../../core/helpers/extensions/taxpayer_types.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/services/upload_service.dart';
import '../../data/models/declaration_details_model.dart';
import '../../data/models/declarations_lookups.dart';
import '../pages/taxpayer_data_page.dart';
import 'applicant_states.dart';

class ApplicantCubit extends Cubit<ApplicantState> {
  ApplicantCubit({
    required this.applicantType,
    required this.declarationId,
    required this.isEditMode,
    this.afterUpdating,
    this.applicantOtherName,
  }) : super(const ApplicantState());

  final formKey = GlobalKey<FormState>();
  String? applicantOtherName;
  ApplicantType applicantType;
  UnitType unitType = UnitType.residential;
  final int declarationId;
  final bool isEditMode;
  final VoidCallback? afterUpdating;

  /// --------------------------- Applicant -----------------------------
  final applicantFirstNameController = TextEditingController();
  final applicantLastNameController = TextEditingController();
  final applicantPhoneController = TextEditingController();
  final applicantEmailController = TextEditingController();
  Nationality applicantNationality = Nationality.egyptian;
  final applicantNationalIdController = TextEditingController();
  String? applicantNationalIdFilePath;
  String? applicantNationalIdUrl;
  String? applicantNationalIdOriginalName;
  final applicantPassportNumberController = TextEditingController();
  String? applicantPassportFilePath;
  String? applicantPassportOriginalName;
  String? userId;

  void initFromUser(UserModel? user) {
    if (user == null) return;
    userId = user.id;
    applicantFirstNameController.text = user.firstname ?? '';
    applicantLastNameController.text = user.lastname ?? ''.trim();
    applicantPhoneController.text = user.phone ?? '';
    applicantEmailController.text = user.email ?? '';

    final nationalityName = user.nationality ?? '';
    if (nationalityName == 'مصر') {
      applicantNationality = Nationality.egyptian;
    } else {
      applicantNationality = Nationality.foreign;
    }

    if (applicantNationality == Nationality.egyptian) {
      applicantNationalIdController.text = user.nationalId ?? '';
      final nationalIdFiles = user.nationalIdFiles as List?;
      if (nationalIdFiles != null && nationalIdFiles.isNotEmpty) {
        applicantNationalIdFilePath = nationalIdFiles.first['full_url'];
      }
    } else {
      applicantPassportNumberController.text = user.passportNumber ?? '';
      final passportFiles = user.passportFiles as List?;
      if (passportFiles != null && passportFiles.isNotEmpty) {
        applicantPassportFilePath = passportFiles.first['full_url'];
      }
    }

    emit(state.copyWith(applicantType: state.applicantType));
  }

  /// ----------------------- End of applicant -----------------------------

  /// --------------------- Taxpayer information ---------------------------
  final taxpayerNameController = TextEditingController();
  Nationality taxpayerNationality = Nationality.egyptian;
  final taxpayerNationalIdController = TextEditingController();
  String? taxpayerNationalIdFilePath;
  String? taxpayerNationalIdFileId;
  String? taxpayerNationalIdOriginalName;
  String? taxpayerNationalIdUrl;
  final taxpayerPassportNumberController = TextEditingController();
  String? taxpayerPassportFilePath;
  String? taxpayerPassportFileId;
  String? taxpayerPassportOriginalName;
  String? taxpayerPassportUrl;
  String? ownershipProofDocumentPath;
  String? ownershipProofDocumentFileId;
  String? ownershipProofDocumentOriginalName;
  String? ownershipProofDocumentUrl;
  String? ownershipDeedFilePath;

  final taxpayerFirstNameController = TextEditingController();
  final taxpayerLastNameController = TextEditingController();
  String? taxpayerTypes;
  final taxpayerPhoneController = TextEditingController();
  final taxpayerEmailController = TextEditingController();

  final taxpayerTaxCardNumberController = TextEditingController();
  String? taxpayerTaxCardFilePath;
  String? taxpayerTaxCardFileId;
  String? taxpayerTaxCardOriginalName;
  String? taxpayerTaxCardUrl;
  final taxpayerCommercialRegisterController = TextEditingController();
  String? taxpayerCommercialRegisterFilePath;
  String? taxpayerCommercialRegisterFileId;
  String? taxpayerCommercialRegisterOriginalName;
  String? taxpayerCommercialRegisterUrl;
  final taxpayerOtherAttachmentNameController = TextEditingController();
  String? taxpayerOtherAttachmentFilePath;
  String? taxpayerOtherAttachmentFileId;
  String? taxpayerOtherAttachmentOriginalName;
  String? taxpayerOtherAttachmentUrl;
  String? taxpayerAuthorizationFilePath;
  String? taxpayerAuthorizationFileId;
  String? taxpayerAuthorizationOriginName;
  String? taxpayerAuthorizationUrl;
  TaxpayerAttachmentModel? taxCardAttachment;
  TaxpayerAttachmentModel? commercialNumberAttachment;
  TaxpayerAttachmentModel? otherAttachment;
  TaxpayerAttachmentModel? authorizationAttachment;

  /// ------------------ End of taxpayer information ------------------------
  void initFromDeclaration(DeclarationDetailsModel declaration) {
    final taxpayer = declaration.taxpayer;
    applicantType = declaration.applicantRoleId.displayApplicant;
    if (taxpayer.isNatural) {
      taxpayerTypes = TaxpayerTypes.natural.displayText;
      authorizationAttachment = declaration.powerOfAttorney;
      taxpayerFirstNameController.text = taxpayer.firstName ?? '';
      taxpayerLastNameController.text = taxpayer.lastName ?? '';
      taxpayerPhoneController.text = taxpayer.phone ?? '';
      taxpayerEmailController.text = taxpayer.email ?? '';
      taxpayerNationalIdController.text = taxpayer.nationalId ?? '';
      taxpayerPassportNumberController.text = taxpayer.passportNumber ?? '';
      taxpayerNationality = taxpayer.nationalityText == 'مصر'
          ? Nationality.egyptian
          : Nationality.foreign;
      taxpayerNationalIdFilePath = taxpayer.nationalIdAttachment?.path;
      taxpayerNationalIdFileId = taxpayer.nationalIdAttachment?.url;
      taxpayerNationalIdUrl = taxpayer.nationalIdAttachment?.fullUrl;
      taxpayerNationalIdOriginalName =
          taxpayer.nationalIdAttachment?.originalFileName;
      taxpayerPassportFilePath = taxpayer.passportAttachment?.path;
      taxpayerPassportFileId = taxpayer.passportAttachment?.url;
      taxpayerPassportUrl = taxpayer.passportAttachment?.fullUrl;
      taxpayerPassportOriginalName =
          taxpayer.passportAttachment?.originalFileName;
    } else {
      taxpayerTypes = TaxpayerTypes.conventional.displayText;
      if (taxpayerTypes == 'إعتباري') {
        taxpayerTypes = 'اعتباري';
      }

      taxCardAttachment = taxpayer.taxCardAttachment;
      commercialNumberAttachment = taxpayer.commercialRegisterAttachment;
      otherAttachment = taxpayer.otherAttachment;
      authorizationAttachment = declaration.powerOfAttorney;
      taxpayerNameController.text = taxpayer.name ?? '';
      taxpayerTaxCardNumberController.text = taxpayer.taxCardNumber ?? '';
      taxpayerCommercialRegisterController.text =
          taxpayer.commercialRegister ?? '';
      taxpayerNationality = taxpayer.nationalityText == 'مصر'
          ? Nationality.egyptian
          : Nationality.foreign;

      taxpayerPassportNumberController.text = taxpayer.passportNumber ?? '';
      taxpayerNationalIdController.text = taxpayer.nationalId ?? '';

      taxpayerPassportUrl = taxpayer.passportAttachment?.fullUrl;
      taxpayerPassportFileId = taxpayer.passportAttachment?.id.toString();
      taxpayerPassportFilePath = taxpayer.passportAttachment?.url;
      taxpayerPassportOriginalName =
          taxpayer.passportAttachment?.originalFileName;

      taxpayerNationalIdFileId = taxpayer.nationalIdAttachment?.id.toString();
      taxpayerNationalIdUrl = taxpayer.nationalIdAttachment?.fullUrl;
      taxpayerNationalIdFilePath = taxpayer.nationalIdAttachment?.url;
      taxpayerNationalIdOriginalName =
          taxpayer.nationalIdAttachment?.originalFileName;

      taxpayerTaxCardFilePath = taxpayer.taxCardAttachment?.path;
      taxpayerTaxCardFileId = taxpayer.taxCardAttachment?.url;
      taxpayerTaxCardUrl = taxpayer.taxCardAttachment?.fullUrl;

      taxpayerTaxCardOriginalName =
          taxpayer.taxCardAttachment?.originalFileName;
      taxpayerCommercialRegisterFilePath =
          taxpayer.commercialRegisterAttachment?.path;
      taxpayerCommercialRegisterFileId =
          taxpayer.commercialRegisterAttachment?.url;
      taxpayerCommercialRegisterUrl =
          taxpayer.commercialRegisterAttachment?.fullUrl;

      taxpayerCommercialRegisterOriginalName =
          taxpayer.commercialRegisterAttachment?.originalFileName;
      taxpayerOtherAttachmentFilePath = taxpayer.otherAttachment?.path;
      taxpayerOtherAttachmentFileId = taxpayer.otherAttachment?.url;
      taxpayerOtherAttachmentUrl = taxpayer.otherAttachment?.fullUrl;

      taxpayerOtherAttachmentOriginalName =
          taxpayer.otherAttachment?.originalFileName;
      taxpayerOtherAttachmentNameController.text =
          taxpayer.otherAttachmentName ?? '';
    }

    // سند التوكيل
    taxpayerAuthorizationFilePath = declaration.powerOfAttorney?.path;
    taxpayerAuthorizationFileId = declaration.powerOfAttorney?.url;
    taxpayerAuthorizationUrl = declaration.powerOfAttorney?.fullUrl;
    taxpayerAuthorizationOriginName =
        declaration.powerOfAttorney?.originalFileName;

    // سند الملكية على الشيوع
    ownershipProofDocumentPath = declaration.jointOwnershipDocument?.url;
    ownershipProofDocumentFileId = declaration.jointOwnershipDocument?.id
        .toString();
    ownershipProofDocumentUrl = declaration.jointOwnershipDocument?.fullUrl;
    ownershipProofDocumentOriginalName =
        declaration.jointOwnershipDocument?.originalFileName;

    emit(
      state.copyWith(
        taxpayerNationality: taxpayerNationality,
        taxpayerTypes: taxpayerTypes,
        taxpayerNationalIdFilePath: taxpayerNationalIdFilePath,
        taxpayerPassportFilePath: taxpayerPassportFilePath,
        taxpayerAuthorizationFilePath: taxpayerAuthorizationFilePath,
        ownershipProofDocumentPath: ownershipProofDocumentPath,
        ownershipProofDocumentFullUrl: ownershipProofDocumentUrl,
      ),
    );
  }

  void changeNationality(String? value) {
    taxpayerNationality = value?.getNationality ?? Nationality.egyptian;
    emit(state.copyWith(taxpayerNationality: taxpayerNationality));
  }

  void changeTaxpayerType(String? value) {
    taxpayerTypes = value;
    emit(state.copyWith(taxpayerTypes: taxpayerTypes));
  }

  Future<void> setNationalIdFile(String path) async {
    emit(state.copyWith(isLoading: true));
    final result = await UploadService.instance.uploadFile(
      filePath: path,
      label: ApiConstants.nationalIdLabel,
    );
    switch (result) {
      case ApiSuccess<UploadedFileModel>(:final data):
        taxpayerNationalIdFilePath = data.path;
        taxpayerNationalIdFileId = data.fileId;
        taxpayerNationalIdOriginalName = data.originalFileName;
        taxpayerNationalIdUrl = data.fullUrl;
      case ApiError<UploadedFileModel>(:final message):
        emit(state.copyWith(isLoading: false, errorMessage: message));
    }
    emit(
      state.copyWith(
        taxpayerNationalIdFilePath: taxpayerNationalIdFilePath,
        taxpayerNationalIdFileUrl: taxpayerNationalIdUrl,
        isLoading: false,
      ),
    );
  }

  void removeNationalIdFile() {
    emit(state.copyWith(isLoading: true));
    taxpayerNationalIdFilePath = null;
    taxpayerNationalIdUrl = null;
    emit(
      state.copyWith(
        taxpayerNationalIdFilePath: 'remove',
        taxpayerNationalIdFileUrl: 'remove',
      ),
    );
  }

  Future<void> setPassportFile(String path) async {
    emit(state.copyWith(isLoading: true));
    final result = await UploadService.instance.uploadFile(
      filePath: path,
      label: ApiConstants.passportLabel,
    );
    switch (result) {
      case ApiSuccess<UploadedFileModel>(:final data):
        taxpayerPassportFilePath = data.path;
        taxpayerPassportFileId = data.fileId;
        taxpayerPassportOriginalName = data.originalFileName;
        taxpayerPassportUrl = data.fullUrl;
      case ApiError<UploadedFileModel>(:final message):
        emit(state.copyWith(isLoading: false, errorMessage: message));
    }
    emit(
      state.copyWith(
        taxpayerPassportFilePath: taxpayerPassportFilePath,
        isLoading: false,
      ),
    );
  }

  void removePassportFile() {
    emit(state.copyWith(isLoading: true));
    taxpayerPassportFilePath = null;
    taxpayerPassportUrl = null;
    emit(
      state.copyWith(
        taxpayerPassportFilePath: 'remove',
        taxpayerPassportFileUrl: 'remove',
      ),
    );
  }

  Future<void> setOwnershipProofDocumentFile(String path) async {
    emit(state.copyWith(isLoading: true));
    final result = await UploadService.instance.uploadFile(
      filePath: path,
      label: ApiConstants.ownershipProofDocumentLabel,
    );
    switch (result) {
      case ApiSuccess<UploadedFileModel>(:final data):
        ownershipProofDocumentPath = data.path;
        ownershipProofDocumentFileId = data.fileId;
        ownershipProofDocumentOriginalName = data.originalFileName;
        ownershipProofDocumentUrl = data.fullUrl;
      case ApiError<UploadedFileModel>(:final message):
        emit(state.copyWith(isLoading: false, errorMessage: message));
    }
    emit(
      state.copyWith(
        ownershipProofDocumentPath: ownershipProofDocumentPath,
        ownershipProofDocumentFullUrl: ownershipProofDocumentUrl,
        isLoading: false,
      ),
    );
  }

  void removeOwnershipProofDocumentFile() {
    ownershipProofDocumentUrl = null;
    ownershipProofDocumentPath = null;
    ownershipProofDocumentFileId = null;
    ownershipProofDocumentOriginalName = null;
    emit(
      state.copyWith(
        ownershipProofDocumentPath: 'remove',
        ownershipProofDocumentFullUrl: 'remove',
      ),
    );
  }

  Future<void> setLegalAuthorizationFile(String path) async {
    emit(state.copyWith(isLoading: true));
    final result = await UploadService.instance.uploadFile(
      filePath: path,
      label: ApiConstants.taxpayerAuthorizationLabel,
    );
    switch (result) {
      case ApiSuccess<UploadedFileModel>(:final data):
        taxpayerAuthorizationFilePath = data.path;
        taxpayerAuthorizationFileId = data.fileId;
        taxpayerAuthorizationOriginName = data.originalFileName;
        taxpayerAuthorizationUrl = data.fullUrl;
      case ApiError<UploadedFileModel>(:final message):
        emit(state.copyWith(isLoading: false, errorMessage: message));
    }
    emit(
      state.copyWith(
        taxpayerAuthorizationFilePath: taxpayerAuthorizationFilePath,
        taxpayerAuthorizationFileId: taxpayerAuthorizationFileId,
        taxpayerAuthorizationFullUrl: taxpayerAuthorizationUrl,
        isLoading: false,
      ),
    );
  }

  void removeLegalAuthorizationFile() {
    emit(state.copyWith(isLoading: true));
    taxpayerAuthorizationUrl = null;
    taxpayerAuthorizationFilePath = null;
    taxpayerAuthorizationFileId = null;
    emit(
      state.copyWith(
        taxpayerAuthorizationFilePath: 'remove',
        taxpayerAuthorizationFullUrl: 'remove',
        taxpayerAuthorizationFileId: 'remove',
      ),
    );
  }

  Future<void> setTaxCardFile(String path) async {
    emit(state.copyWith(isLoading: true));
    final result = await UploadService.instance.uploadFile(
      filePath: path,
      label: ApiConstants.taxpayerTaxCardLabel,
    );
    switch (result) {
      case ApiSuccess<UploadedFileModel>(:final data):
        taxpayerTaxCardFilePath = data.path;
        taxpayerTaxCardFileId = data.fileId;
        taxpayerTaxCardOriginalName = data.originalFileName;
        taxpayerTaxCardUrl = data.fullUrl;
      case ApiError<UploadedFileModel>(:final message):
        emit(state.copyWith(isLoading: false, errorMessage: message));
    }
    emit(
      state.copyWith(
        taxpayerTaxCardFilePath: taxpayerTaxCardFilePath,
        taxpayerTaxCardFullUrl: taxpayerTaxCardUrl,
        isLoading: false,
      ),
    );
  }

  void removeTaxCardFile() {
    taxpayerTaxCardFilePath = null;
    taxpayerTaxCardUrl = null;
    emit(
      state.copyWith(
        taxpayerTaxCardFilePath: 'remove',
        taxpayerTaxCardFullUrl: 'remove',
      ),
    );
  }

  Future<void> setCommercialRegisterFile(String path) async {
    emit(state.copyWith(isLoading: true));
    final result = await UploadService.instance.uploadFile(
      filePath: path,
      label: ApiConstants.taxpayerCommercialRegisterLabel,
    );
    switch (result) {
      case ApiSuccess<UploadedFileModel>(:final data):
        taxpayerCommercialRegisterFilePath = data.path;
        taxpayerCommercialRegisterFileId = data.fileId;
        taxpayerCommercialRegisterOriginalName = data.originalFileName;
        taxpayerCommercialRegisterUrl = data.fullUrl;
      case ApiError<UploadedFileModel>(:final message):
        emit(state.copyWith(isLoading: false, errorMessage: message));
    }
    emit(
      state.copyWith(
        taxpayerCommercialRegisterFilePath: taxpayerCommercialRegisterFilePath,
        taxpayerCommercialRegisterFullUrl: taxpayerCommercialRegisterUrl,
        isLoading: false,
      ),
    );
  }

  void removeCommercialRegisterFile() {
    taxpayerCommercialRegisterFilePath = null;
    taxpayerCommercialRegisterUrl = null;
    emit(
      state.copyWith(
        taxpayerCommercialRegisterFilePath: 'remove',
        taxpayerCommercialRegisterFullUrl: 'remove',
      ),
    );
  }

  Future<void> setOtherAttachmentFile(String path) async {
    emit(state.copyWith(isLoading: true));
    final result = await UploadService.instance.uploadFile(
      filePath: path,
      label: ApiConstants.taxpayerOtherAttachmentLabel,
    );
    switch (result) {
      case ApiSuccess<UploadedFileModel>(:final data):
        taxpayerOtherAttachmentFilePath = data.path;
        taxpayerOtherAttachmentFileId = data.fileId;
        taxpayerOtherAttachmentOriginalName = data.originalFileName;
        taxpayerOtherAttachmentUrl = data.fullUrl;
      case ApiError<UploadedFileModel>(:final message):
        emit(state.copyWith(isLoading: false, errorMessage: message));
    }
    emit(
      state.copyWith(
        taxpayerOtherAttachmentFilePath: taxpayerOtherAttachmentFilePath,
        taxpayerOtherAttachmentFullUrl: taxpayerOtherAttachmentUrl,
        isLoading: false,
      ),
    );
  }

  void removeOtherAttachmentFile() {
    taxpayerOtherAttachmentFilePath = null;
    taxpayerOtherAttachmentUrl = null;
    emit(
      state.copyWith(
        taxpayerOtherAttachmentFilePath: 'remove',
        taxpayerOtherAttachmentFullUrl: 'remove',
      ),
    );
  }

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

  // ──────────────────────────────────────────────────────
  // Validation
  // ──────────────────────────────────────────────────────

  bool validate() {
    final isFormValid = formKey.currentState?.validate() ?? false;
    if (!isFormValid) return false;

    switch (applicantType) {
      case ApplicantType.owner:
      case ApplicantType.exploited:
      case ApplicantType.beneficiary:
        return true;
      case ApplicantType.sharedOwnership:
      case ApplicantType.agent:
        if (taxpayerNationalIdFilePath == null &&
            taxpayerNationality == Nationality.egyptian &&
            taxpayerTypes == 'طبيعي') {
          emit(state.copyWith(errorMessage: 'يرجى رفع صورة الرقم القومي'));
          return false;
        }
        if (taxpayerPassportFilePath == null &&
            taxpayerNationality != Nationality.egyptian) {
          emit(state.copyWith(errorMessage: 'يرجى رفع صورة جواز السفر'));
          return false;
        }
        if (ownershipProofDocumentPath == null &&
            applicantType == ApplicantType.sharedOwnership) {
          emit(
            state.copyWith(
              errorMessage: 'يرجى رفع سند الملكية على الشيوع / إعلام الوراثة',
            ),
          );
          return false;
        }
        break;
      case ApplicantType.legalRepresentative:
        if (taxpayerAuthorizationFilePath == null) {
          emit(state.copyWith(errorMessage: 'يرجى رفع التوكيل القانوني'));
          return false;
        }
        break;
      case ApplicantType.other:
    }

    // if (applicantType == ApplicantType.sharedOwnership) {
    //   if (ownershipProofDocumentPath == null) {
    //     emit(
    //       state.copyWith(
    //         errorMessage: 'يرجى رفع سند الملكية على الشيوع / إعلام الوراثة',
    //       ),
    //     );
    //     return false;
    //   }
    // }

    return true;
  }

  // ──────────────────────────────────────────────────────
  // Submit
  // ──────────────────────────────────────────────────────

  Future<void> onNextTapped(BuildContext context) async {
    final lookupsCubit = context.read<DeclarationLookupsCubit>();
    if (applicantType == ApplicantType.owner ||
        applicantType == ApplicantType.beneficiary ||
        applicantType == ApplicantType.exploited) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: this),
              BlocProvider.value(value: lookupsCubit),
            ],
            child: SelectTypesOfPropertiesPage(
              applicantType: applicantType,
              declarationId: declarationId,
              otherName: applicantOtherName,
            ),
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: this),
              BlocProvider.value(value: lookupsCubit),
            ],
            child: TaxpayerDataPage(),
          ),
        ),
      );
    }
  }

  bool validateFiles() {
    if (taxpayerTypes == 'اعتباري' &&
        applicantType != ApplicantType.sharedOwnership) {
      if ((taxpayerTaxCardUrl == null) &&
          (taxpayerCommercialRegisterUrl == null) &&
          (taxpayerOtherAttachmentUrl == null)) {
        emit(state.copyWith(errorMessage: 'يجب رفع ملف واحد على الأفل'));
        return false;
      }

      if (taxpayerTaxCardUrl != null &&
          taxpayerTaxCardNumberController.text.trim().isEmpty) {
        emit(state.copyWith(errorMessage: 'رقم البطاقه الضريبيه مطلوب'));
        return false;
      }

      if (taxpayerTaxCardUrl == null &&
          taxpayerTaxCardNumberController.text.trim().isNotEmpty) {
        emit(state.copyWith(errorMessage: 'مرفق البطاقه الضريبيه مطلوب'));
        return false;
      }

      if (taxpayerCommercialRegisterUrl != null &&
          taxpayerCommercialRegisterController.text.trim().isEmpty) {
        emit(state.copyWith(errorMessage: 'رقم السجل التجاري مطلوب'));
        return false;
      }

      if (taxpayerCommercialRegisterUrl == null &&
          taxpayerCommercialRegisterController.text.trim().isNotEmpty) {
        emit(state.copyWith(errorMessage: 'مرفق السجل التجاري مطلوب'));
        return false;
      }

      if (taxpayerOtherAttachmentUrl != null &&
          taxpayerOtherAttachmentNameController.text.trim().isEmpty) {
        emit(state.copyWith(errorMessage: 'إسم المرفق الآخر مطلوب'));
        return false;
      }

      if (taxpayerOtherAttachmentUrl == null &&
          taxpayerOtherAttachmentNameController.text.trim().isNotEmpty) {
        emit(state.copyWith(errorMessage: 'المرفق الآخر مطلوب'));
        return false;
      }
      return true;
    } else {
      return true;
    }
  }

  Future<void> onTaxpayerNextTapped(
    BuildContext context, {
    handleCreateNewUnitFromDeclarationPropList = false,
  }) async {
    if (validateFiles()) {
      emit(state.copyWith(isLoading: true));
      Map<String, dynamic> payload = buildPayload(
        context,
        isEdit: declarationId != -1,
      );

      final result = await safeApiCall(() async {
        final response = await DioClient.instance.dio.post(
          ApiConstants.validateTaxpayer,
          data: payload,
        );
        return response.data as Map<String, dynamic>;
      });

      switch (result) {
        case ApiSuccess(:final data):
          emit(state.copyWith(isLoading: false));
          onNavigateConfirmed(
            context,
            handleCreateNewUnitFromDeclarationPropList,
          );
        case ApiError(:final message):
          emit(state.copyWith(isLoading: false, errorMessage: message));
      }
    }
  }

  void onNavigateConfirmed(
    BuildContext context,
    bool handleCreateNewUnitFromDeclarationPropList,
  ) {
    final lookupsCubit = context.read<DeclarationLookupsCubit>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: this),
            BlocProvider.value(value: lookupsCubit),
          ],
          child: SelectTypesOfPropertiesPage(
            applicantType: applicantType,
            declarationId: declarationId,
            otherName: applicantOtherName,
            handleCreateNewUnitFromDeclarationPropList:
                handleCreateNewUnitFromDeclarationPropList,
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> buildPayload(
    BuildContext context, {
    bool save = false,
    bool isEdit = false,
  }) {
    final applicantRoleId = applicantType.id;

    final Map<String, dynamic> payload = {
      'declaration_type_id': 1,
      'applicant_role_id': applicantRoleId,
    };

    if (applicantType == ApplicantType.other) {
      payload["applicant_role_other"] = applicantOtherName;
    }

    // ── سند التوكيل ──────────────────────────────────
    if (applicantType == ApplicantType.agent ||
        applicantType == ApplicantType.legalRepresentative ||
        applicantType == ApplicantType.other) {
      if (taxpayerAuthorizationUrl != null) {
        payload['power_of_attorney'] = {
          'file_id': taxpayerAuthorizationFileId,
          if (!save) 'path': taxpayerAuthorizationFilePath,
          'original_file_name': taxpayerAuthorizationOriginName,
          'full_url': taxpayerAuthorizationUrl,
        };
      }
    }

    // ── سند الملكية على الشيوع ───────────────────────
    if (applicantType == ApplicantType.sharedOwnership) {
      if (ownershipProofDocumentPath != null) {
        payload['joint_ownership_document'] = {
          if (isEdit) 'id': ownershipProofDocumentFileId,
          if (!isEdit) 'file_id': ownershipProofDocumentFileId,
          if (!save && !isEdit) 'path': ownershipProofDocumentPath,
          if (isEdit) 'url': ownershipProofDocumentPath,
          'original_file_name': ownershipProofDocumentOriginalName,
          'full_url': ownershipProofDocumentUrl,
        };
      }
    }

    if (applicantType != ApplicantType.owner &&
        applicantType != ApplicantType.beneficiary) {
      payload['taxpayer'] = _buildTaxpayerPayload(
        context,
        save: save,
        isEdit: isEdit,
      );
    }

    return payload;
  }

  Map<String, dynamic> _buildTaxpayerPayload(
    BuildContext context, {
    required bool save,
    required bool isEdit,
  }) {
    // للمالك والمنتفع — المكلف هو نفس المقدم
    final lookups = context.read<DeclarationLookupsCubit>().lookups;
    final taxpayerTypeId = (lookups?.taxpayerTypes ?? [])
        .firstWhere(
          (p) => p.name == taxpayerTypes,
          orElse: () => DeclarationLookup(id: 1, name: ''),
        )
        .id;
    String phone = taxpayerPhoneController.text.trim();
    String email = taxpayerEmailController.text.trim();

    final nationalityId = (lookups?.nationalities ?? [])
        .firstWhere(
          (p) =>
              p.name ==
              (taxpayerNationality == Nationality.egyptian ? 'مصر' : 'أسبانيا'),
          orElse: () => DeclarationLookup(id: 1, name: ''),
        )
        .id;

    final Map<String, dynamic> taxpayer = {
      if (applicantType == ApplicantType.agent ||
          applicantType == ApplicantType.legalRepresentative ||
          applicantType == ApplicantType.other)
        'type_id': taxpayerTypeId,
      if (applicantType == ApplicantType.sharedOwnership) 'type_id': null,

      if (taxpayerTypeId == 1 && applicantType != ApplicantType.sharedOwnership)
        'first_name': taxpayerNameController.text.trim().isNotEmpty
            ? taxpayerNameController.text.trim()
            : taxpayerFirstNameController.text.trim(), // اسم المكلف
      if (taxpayerTypeId == 2 || applicantType == ApplicantType.sharedOwnership)
        'name': taxpayerNameController.text.trim(),

      if (taxpayerLastNameController.text.trim().isNotEmpty)
        'last_name': taxpayerLastNameController.text.trim(),

      if (taxpayerTypes == 'طبيعي') 'nationality_id': nationalityId,
      if (phone.isNotEmpty) 'phone': phone,
      if (phone.isEmpty) 'phone': null,
      if (email.isNotEmpty) 'email': email,
      if (email.isEmpty) 'email': null,
    };

    if (applicantType == ApplicantType.sharedOwnership) {
      taxpayer['nationality_id'] = nationalityId;
      if (taxpayerNationality == Nationality.egyptian) {
        taxpayer['national_id'] = taxpayerNationalIdController.text.trim();
        if (taxpayerNationalIdFilePath != null) {
          taxpayer['national_id_attachment'] = {
            if (!isEdit) 'file_id': taxpayerNationalIdFileId,
            if (isEdit) 'id': taxpayerNationalIdFileId,
            if (!save && !isEdit) 'path': taxpayerNationalIdFilePath,
            if (isEdit) 'url': taxpayerNationalIdFilePath,
            'original_file_name': taxpayerNationalIdOriginalName,
            'full_url': taxpayerNationalIdUrl,
          };
        }
      } else {
        taxpayer['passport_number'] = taxpayerPassportNumberController.text
            .trim();
        if (taxpayerPassportFilePath != null) {
          taxpayer['passport_attachment'] = {
            if (isEdit) 'id': taxpayerPassportFileId,
            if (!isEdit) 'file_id': taxpayerPassportFileId,
            if (!save && !isEdit) 'path': taxpayerPassportFilePath,
            if (isEdit) 'url': taxpayerPassportFilePath,
            'original_file_name': taxpayerPassportOriginalName,
            'full_url': taxpayerPassportUrl,
          };
        }
      }
    }
    if (taxpayerTypes == 'طبيعي') {
      taxpayer['last_name'] = taxpayerLastNameController.text.trim();
      if (taxpayerNationality == Nationality.egyptian) {
        taxpayer['national_id'] = taxpayerNationalIdController.text.trim();
        if (taxpayerNationalIdFilePath != null) {
          taxpayer['national_id_attachment'] = {
            if (isEdit) 'id': taxpayerNationalIdFileId,
            if (!isEdit) 'file_id': taxpayerNationalIdFileId,
            if (isEdit) 'url': taxpayerNationalIdFilePath,
            if (!isEdit) 'path': taxpayerNationalIdFilePath,
            'original_file_name': taxpayerNationalIdOriginalName,
            'full_url': taxpayerNationalIdUrl,
          };
        }
      } else {
        taxpayer['passport_number'] = taxpayerPassportNumberController.text
            .trim();
        if (taxpayerPassportFilePath != null) {
          taxpayer['passport_attachment'] = {
            if (isEdit) 'id': taxpayerPassportFileId,
            if (!isEdit) 'file_id': taxpayerPassportFileId,
            if (isEdit) 'url': taxpayerPassportFilePath,
            if (!isEdit) 'path': taxpayerPassportFilePath,
            'original_file_name': taxpayerPassportOriginalName,
            'full_url': taxpayerPassportUrl,
          };
        }
      }
    }
    if (taxpayerTypes == 'اعتباري') {
      if (taxpayerTaxCardNumberController.text.isNotEmpty) {
        taxpayer['tax_card_number'] = taxpayerTaxCardNumberController.text
            .trim();
      }
      if (taxpayerCommercialRegisterController.text.isNotEmpty) {
        taxpayer['commercial_register'] = taxpayerCommercialRegisterController
            .text
            .trim();
      }
      if (taxpayerTaxCardFilePath != null) {
        taxpayer['tax_card_attachment'] = {
          if (isEdit) 'id': taxpayerTaxCardFileId,
          if (!isEdit) 'file_id': taxpayerTaxCardFileId,
          if (taxpayerTaxCardFilePath != null && !isEdit)
            'path': taxpayerTaxCardFilePath,
          if (isEdit) 'url': taxpayerTaxCardFilePath,
          'original_file_name': taxpayerTaxCardOriginalName,
          'full_url': taxpayerTaxCardUrl,
        };
      }
      if (taxpayerCommercialRegisterFilePath != null) {
        taxpayer['commercial_register_attachment'] = {
          if (isEdit) 'id': taxpayerCommercialRegisterFileId,
          if (!isEdit) 'file_id': taxpayerCommercialRegisterFileId,
          if (isEdit) 'url': taxpayerCommercialRegisterFilePath,
          if (!isEdit) 'path': taxpayerCommercialRegisterFilePath,
          'original_file_name': taxpayerCommercialRegisterOriginalName,
          'full_url': taxpayerCommercialRegisterUrl,
        };
      }
      if (taxpayerOtherAttachmentNameController.text.isNotEmpty) {
        taxpayer['other_attachment_name'] =
            taxpayerOtherAttachmentNameController.text.trim();
      }
      if (taxpayerOtherAttachmentFilePath != null) {
        taxpayer['other_attachment'] = {
          if (isEdit) 'id': taxpayerOtherAttachmentFileId,
          if (!isEdit) 'file_id': taxpayerOtherAttachmentFileId,
          if (!isEdit) 'path': taxpayerOtherAttachmentFilePath,
          if (isEdit) 'url': taxpayerOtherAttachmentFilePath,
          'original_file_name': taxpayerOtherAttachmentOriginalName,
          'full_url': taxpayerOtherAttachmentUrl,
        };
      }
    }

    return taxpayer;
  }

  @override
  Future<void> close() {
    // Applicant
    applicantFirstNameController.dispose();
    applicantLastNameController.dispose();
    applicantPhoneController.dispose();
    applicantEmailController.dispose();
    applicantNationalIdController.dispose();
    applicantPassportNumberController.dispose();

    // Taxpayer
    taxpayerNameController.dispose();
    taxpayerNationalIdController.dispose();
    taxpayerPassportNumberController.dispose();
    taxpayerFirstNameController.dispose();
    taxpayerLastNameController.dispose();
    taxpayerPhoneController.dispose();
    taxpayerEmailController.dispose();
    taxpayerTaxCardNumberController.dispose();
    taxpayerCommercialRegisterController.dispose();
    taxpayerOtherAttachmentNameController.dispose();
    return super.close();
  }

  void clearError() => emit(state.copyWith(clearError: true));

  void saveEdit(BuildContext context) {
    final lookupsCubit = context.read<DeclarationLookupsCubit>();
    if (applicantType == ApplicantType.owner ||
        applicantType == ApplicantType.exploited ||
        applicantType == ApplicantType.beneficiary) {
      if (context.mounted) Navigator.pop(context);
    } else {
      PersistentNavBarNavigator.pushNewScreen(
        context,
        screen: MultiBlocProvider(
          providers: [
            BlocProvider.value(value: this),
            BlocProvider.value(value: lookupsCubit),
          ],
          child: TaxpayerDataPage(),
        ),
        withNavBar: true,
        pageTransitionAnimation: PageTransitionAnimation.slideUp,
      );
    }
  }

  Future<void> saveTaxpayerEdit(BuildContext context) async {
    emit(state.copyWith(isLoading: true));

    final payload = buildPayload(
      context,
      save: true,
      isEdit: declarationId != -1,
    );

    final result = await safeApiCall(() async {
      final response = await DioClient.instance.dio.put(
        ApiConstants.declarationById(declarationId.toString()),
        data: payload,
      );
      return response.data as Map<String, dynamic>;
    });

    switch (result) {
      case ApiSuccess(:final data):
        emit(
          state.copyWith(
            isLoading: false,
            successMessage: 'تم تحديث البيانات بنجاح',
          ),
        );
        if (afterUpdating != null) afterUpdating!();
        if (context.mounted) Navigator.pop(context);
        if (context.mounted) Navigator.pop(context);
      case ApiError(:final message):
        emit(state.copyWith(isLoading: false, errorMessage: message));
    }
  }
}
