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

  void initFromUser(UserModel? user) {
    if (user == null) return;
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
  String? taxpayerNationalIdOriginalName;
  String? taxpayerNationalIdUrl;
  final taxpayerPassportNumberController = TextEditingController();
  String? taxpayerPassportFilePath;
  String? taxpayerPassportOriginalName;
  String? taxpayerPassportUrl;
  String? ownershipProofDocumentPath;
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
  String? taxpayerTaxCardOriginalName;
  String? taxpayerTaxCardUrl;
  final taxpayerCommercialRegisterController = TextEditingController();
  String? taxpayerCommercialRegisterFilePath;
  String? taxpayerCommercialRegisterOriginalName;
  String? taxpayerCommercialRegisterUrl;
  final taxpayerOtherAttachmentNameController = TextEditingController();
  String? taxpayerOtherAttachmentFilePath;
  String? taxpayerOtherAttachmentOriginalName;
  String? taxpayerOtherAttachmentUrl;
  String? taxpayerAuthorizationFilePath;
  String? taxpayerAuthorizationOriginName;
  String? taxpayerAuthorizationUrl;

  /// ------------------ End of taxpayer information ------------------------
  void initFromDeclaration(DeclarationDetailsModel declaration) {
    final taxpayer = declaration.taxpayer;
    applicantType = declaration.applicantRoleId.displayApplicant;
    if (taxpayer.isNatural) {
      taxpayerTypes = TaxpayerTypes.natural.displayText;
      taxpayerFirstNameController.text = taxpayer.firstName ?? '';
      taxpayerLastNameController.text = taxpayer.lastName ?? '';
      taxpayerPhoneController.text = taxpayer.phone ?? '';
      taxpayerEmailController.text = taxpayer.email ?? '';
      taxpayerNationalIdController.text = taxpayer.nationalId ?? '';
      taxpayerNationality = taxpayer.nationalityId == 1
          ? Nationality.egyptian
          : Nationality.foreign;
      taxpayerNationalIdFilePath = taxpayer.nationalIdAttachment?.url;
      taxpayerNationalIdUrl = taxpayer.nationalIdAttachment?.fullUrl;
      taxpayerNationalIdOriginalName =
          taxpayer.nationalIdAttachment?.originalFileName;
      taxpayerPassportFilePath = taxpayer.passportAttachment?.url;
      taxpayerPassportUrl = taxpayer.passportAttachment?.fullUrl;
      taxpayerPassportOriginalName =
          taxpayer.passportAttachment?.originalFileName;
    } else {
      taxpayerTypes = TaxpayerTypes.conventional.displayText;
      taxpayerNameController.text = taxpayer.name ?? '';
      taxpayerTaxCardNumberController.text = taxpayer.taxCardNumber ?? '';
      taxpayerCommercialRegisterController.text =
          taxpayer.commercialRegister ?? '';
      taxpayerNationality = taxpayer.nationalityId == 1
          ? Nationality.egyptian
          : Nationality.foreign;
      taxpayerTaxCardFilePath = taxpayer.taxCardAttachment?.url;
      taxpayerTaxCardOriginalName =
          taxpayer.taxCardAttachment?.originalFileName;
      taxpayerCommercialRegisterFilePath =
          taxpayer.commercialRegisterAttachment?.url;
      taxpayerCommercialRegisterOriginalName =
          taxpayer.commercialRegisterAttachment?.originalFileName;
      taxpayerOtherAttachmentFilePath = taxpayer.otherAttachment?.url;
      taxpayerOtherAttachmentOriginalName =
          taxpayer.otherAttachment?.originalFileName;
      taxpayerOtherAttachmentNameController.text =
          taxpayer.otherAttachmentName ?? '';
    }

    // سند التوكيل
    taxpayerAuthorizationFilePath = declaration.powerOfAttorney?.url;
    taxpayerAuthorizationUrl = declaration.powerOfAttorney?.fullUrl;
    taxpayerAuthorizationOriginName =
        declaration.powerOfAttorney?.originalFileName;

    // سند الملكية على الشيوع
    ownershipProofDocumentPath = declaration.jointOwnershipDocument?.url;
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
        taxpayerNationalIdOriginalName = data.originalFileName;
        taxpayerNationalIdUrl = data.fullUrl;
        emit(state.copyWith(isLoading: false));
      case ApiError<UploadedFileModel>(:final message):
        emit(state.copyWith(isLoading: false, errorMessage: message));
    }
    emit(
      state.copyWith(
        taxpayerNationalIdFilePath: taxpayerNationalIdFilePath,
        taxpayerNationalIdFileUrl: taxpayerNationalIdUrl,
      ),
    );
  }

  void removeNationalIdFile() {
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
        taxpayerPassportOriginalName = data.originalFileName;
        taxpayerPassportUrl = data.fullUrl;
        emit(state.copyWith(isLoading: false));
      case ApiError<UploadedFileModel>(:final message):
        emit(state.copyWith(isLoading: false, errorMessage: message));
    }
    emit(state.copyWith(taxpayerPassportFilePath: taxpayerPassportFilePath));
  }

  void removePassportFile() {
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
        ownershipProofDocumentOriginalName = data.originalFileName;
        ownershipProofDocumentUrl = data.fullUrl;
        emit(state.copyWith(isLoading: false));
      case ApiError<UploadedFileModel>(:final message):
        emit(state.copyWith(isLoading: false, errorMessage: message));
    }
    emit(
      state.copyWith(
        ownershipProofDocumentPath: ownershipProofDocumentPath,
        ownershipProofDocumentFullUrl: ownershipProofDocumentUrl,
      ),
    );
  }

  void removeOwnershipProofDocumentFile() {
    ownershipProofDocumentPath = null;
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
        taxpayerAuthorizationOriginName = data.originalFileName;
        taxpayerAuthorizationUrl = data.fullUrl;
        emit(state.copyWith(isLoading: false));
      case ApiError<UploadedFileModel>(:final message):
        emit(state.copyWith(isLoading: false, errorMessage: message));
    }
    emit(
      state.copyWith(
        taxpayerAuthorizationFilePath: taxpayerAuthorizationFilePath,
        taxpayerAuthorizationFullUrl: taxpayerAuthorizationUrl,
      ),
    );
  }

  void removeLegalAuthorizationFile() {
    taxpayerAuthorizationUrl = null;
    taxpayerAuthorizationFilePath = null;
    emit(
      state.copyWith(
        taxpayerAuthorizationFilePath: 'remove',
        taxpayerAuthorizationFullUrl: 'remove',
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
        taxpayerTaxCardOriginalName = data.originalFileName;
        taxpayerTaxCardUrl = data.fullUrl;
        emit(state.copyWith(isLoading: false));
      case ApiError<UploadedFileModel>(:final message):
        emit(state.copyWith(isLoading: false, errorMessage: message));
    }
    emit(
      state.copyWith(
        taxpayerTaxCardFilePath: taxpayerTaxCardFilePath,
        taxpayerTaxCardFullUrl: taxpayerTaxCardUrl,
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
        taxpayerCommercialRegisterOriginalName = data.originalFileName;
        taxpayerCommercialRegisterUrl = data.fullUrl;
        emit(state.copyWith(isLoading: false));
      case ApiError<UploadedFileModel>(:final message):
        emit(state.copyWith(isLoading: false, errorMessage: message));
    }
    emit(
      state.copyWith(
        taxpayerCommercialRegisterFilePath: taxpayerCommercialRegisterFilePath,
        taxpayerCommercialRegisterFullUrl: taxpayerCommercialRegisterUrl,
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
        taxpayerOtherAttachmentOriginalName = data.originalFileName;
        taxpayerOtherAttachmentUrl = data.fullUrl;
        emit(state.copyWith(isLoading: false));
      case ApiError<UploadedFileModel>(:final message):
        emit(state.copyWith(isLoading: false, errorMessage: message));
    }
    emit(
      state.copyWith(
        taxpayerOtherAttachmentFilePath: taxpayerOtherAttachmentFilePath,
        taxpayerOtherAttachmentFullUrl: taxpayerOtherAttachmentUrl,
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

    switch (state.applicantType) {
      case ApplicantType.owner:
      case ApplicantType.exploited:
      case ApplicantType.beneficiary:
        return true;
      case ApplicantType.sharedOwnership:
      case ApplicantType.agent:
        if (taxpayerNationalIdFilePath == null) {
          emit(state.copyWith(errorMessage: 'يرجى رفع صورة الرقم القومي'));
          return false;
        }
        if (taxpayerPassportFilePath == null) {
          emit(state.copyWith(errorMessage: 'يرجى رفع صورة جواز السفر'));
          return false;
        }
        if (ownershipDeedFilePath == null) {
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
      case null:
        break;
    }

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
          // BlocProvider.value(value: this, child: TaxpayerDataPage()),
        ),
      );
    }
  }

  Future<void> onTaxpayerNextTapped(BuildContext context) async {
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
          ),
        ),
      ),
    );
  }

  Future<void> submit(BuildContext context) async {
    if (!validate()) return;

    emit(state.copyWith(isLoading: true));

    try {
      final payload = buildPayload(context);
      debugPrint('Payload: $payload');

      emit(state.copyWith(isLoading: false, successMessage: 'تم الحفظ بنجاح'));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Map<String, dynamic> buildPayload(BuildContext context) {
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
      if (taxpayerAuthorizationFilePath != null) {
        payload['power_of_attorney'] = {
          'file_id': taxpayerAuthorizationFilePath,
          'original_file_name': taxpayerAuthorizationOriginName,
          'full_url': taxpayerAuthorizationUrl,
        };
      }
    }

    // ── سند الملكية على الشيوع ───────────────────────
    if (applicantType == ApplicantType.sharedOwnership) {
      if (ownershipProofDocumentPath != null) {
        payload['joint_ownership_document'] = {
          'file_id': ownershipProofDocumentPath,
          'original_file_name': ownershipProofDocumentOriginalName,
          'full_url': ownershipProofDocumentUrl,
        };
      }
    }

    if (applicantType != ApplicantType.owner &&
        applicantType != ApplicantType.beneficiary) {
      payload['taxpayer'] = _buildTaxpayerPayload(context);
    }

    return payload;
  }

  Map<String, dynamic> _buildTaxpayerPayload(BuildContext context) {
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
    final Map<String, dynamic> taxpayer = {
      if (applicantType == ApplicantType.agent ||
          applicantType == ApplicantType.legalRepresentative ||
          applicantType == ApplicantType.other)
        'type_id': taxpayerTypeId,
      if (applicantType == ApplicantType.sharedOwnership) 'type_id': null,

      if (taxpayerTypeId == 1 || applicantType != ApplicantType.sharedOwnership)
        'first_name': taxpayerNameController.text.trim().isNotEmpty
            ? taxpayerNameController.text.trim()
            : taxpayerFirstNameController.text.trim(), // اسم المكلف

      if (taxpayerTypeId == 2 || applicantType == ApplicantType.sharedOwnership)
        'name': taxpayerNameController.text.trim(),

      if (taxpayerLastNameController.text.trim().isNotEmpty)
        'last_name': taxpayerLastNameController.text.trim(),

      if (taxpayerTypes == 'طبيعي') 'nationality_id': taxpayerNationality.id,
      if (phone.isNotEmpty) 'phone': phone,
      if (phone.isEmpty) 'phone': null,
      if (email.isNotEmpty) 'email': email,
      if (email.isEmpty) 'email': null,
    };

    if (applicantType == ApplicantType.sharedOwnership) {
      taxpayer['nationality_id'] = taxpayerNationality.id;
      if (taxpayerNationality == Nationality.egyptian) {
        taxpayer['national_id'] = taxpayerNationalIdController.text.trim();
        if (taxpayerNationalIdFilePath != null) {
          taxpayer['national_id_attachment'] = {
            'file_id': taxpayerNationalIdFilePath,
            'original_file_name': taxpayerNationalIdOriginalName,
            'full_url': taxpayerNationalIdUrl,
          };
        }
      } else {
        taxpayer['passport_number'] = taxpayerPassportNumberController.text
            .trim();
        if (taxpayerPassportFilePath != null) {
          taxpayer['passport_attachment'] = {
            'file_id': taxpayerPassportFilePath,
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
            'file_id': taxpayerNationalIdFilePath,
            'original_file_name': taxpayerNationalIdOriginalName,
            'full_url': taxpayerNationalIdUrl,
          };
        }
      } else {
        taxpayer['passport_number'] = taxpayerPassportNumberController.text
            .trim();
        if (taxpayerPassportFilePath != null) {
          taxpayer['passport_attachment'] = {
            'file_id': taxpayerPassportFilePath,
            'original_file_name': taxpayerPassportOriginalName,
            'full_url': taxpayerPassportUrl,
          };
        }
      }
    }
    if (taxpayerTypes == 'اعتباري') {
      taxpayer['tax_card_number'] = taxpayerTaxCardNumberController.text.trim();
      taxpayer['commercial_register'] = taxpayerCommercialRegisterController
          .text
          .trim();
      if (taxpayerTaxCardFilePath != null) {
        taxpayer['tax_card_attachment'] = {
          'file_id': taxpayerTaxCardFilePath,
          'original_file_name': taxpayerTaxCardOriginalName,
          'full_url': taxpayerTaxCardUrl,
        };
      }
      if (taxpayerCommercialRegisterFilePath != null) {
        taxpayer['commercial_register_attachment'] = {
          'file_id': taxpayerCommercialRegisterFilePath,
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
          'file_id': taxpayerOtherAttachmentFilePath,
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

  void clearError() => emit(state.copyWith(errorMessage: null));

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

    final payload = <String, dynamic>{
      'declaration_type_id': 1,
      'applicant_role_id': applicantType.id,
      'applicant_role_other': applicantOtherName,
    };

    // ── سند التوكيل ──────────────────────────
    if (taxpayerAuthorizationFilePath != null) {
      payload['power_of_attorney'] = {
        'file_id': taxpayerAuthorizationFilePath,
        'original_file_name': taxpayerAuthorizationOriginName,
        'full_url': taxpayerAuthorizationUrl,
      };
    }

    // ── سند الملكية على الشيوع ───────────────
    if (ownershipProofDocumentPath != null) {
      payload['joint_ownership_document'] = {
        'file_id': ownershipProofDocumentPath,
        'original_file_name': ownershipProofDocumentOriginalName,
        'full_url': ownershipProofDocumentUrl,
      };
    }

    // ── بيانات المكلف ─────────────────────────
    final taxpayer = <String, dynamic>{};

    if (taxpayerTypes == TaxpayerTypes.natural.displayText) {
      taxpayer['first_name'] = taxpayerFirstNameController.text.trim();
      taxpayer['last_name'] = taxpayerLastNameController.text.trim();
      taxpayer['phone'] = taxpayerPhoneController.text.trim();
      taxpayer['email'] = taxpayerEmailController.text.trim();
      taxpayer['nationality_id'] = taxpayerNationality.id;

      if (taxpayerNationality == Nationality.egyptian) {
        taxpayer['national_id'] = taxpayerNationalIdController.text.trim();
        if (taxpayerNationalIdFilePath != null) {
          taxpayer['national_id_attachment'] = {
            'file_id': taxpayerNationalIdFilePath,
            'original_file_name': taxpayerNationalIdOriginalName,
            'full_url': taxpayerNationalIdUrl,
          };
        }
      } else {
        taxpayer['passport_number'] = taxpayerPassportNumberController.text
            .trim();
        if (taxpayerPassportFilePath != null) {
          taxpayer['passport_attachment'] = {
            'file_id': taxpayerPassportFilePath,
            'original_file_name': taxpayerPassportOriginalName,
            'full_url': taxpayerPassportUrl,
          };
        }
      }
    } else {
      taxpayer['name'] = taxpayerNameController.text.trim();
      taxpayer['tax_card_number'] = taxpayerTaxCardNumberController.text.trim();
      taxpayer['commercial_register'] = taxpayerCommercialRegisterController
          .text
          .trim();
      taxpayer['nationality_id'] = taxpayerNationality.id;

      if (taxpayerTaxCardFilePath != null) {
        taxpayer['tax_card_attachment'] = {
          'file_id': taxpayerTaxCardFilePath,
          'original_file_name': taxpayerTaxCardOriginalName,
          'full_url': taxpayerTaxCardUrl,
        };
      }
      if (taxpayerCommercialRegisterFilePath != null) {
        taxpayer['commercial_register_attachment'] = {
          'file_id': taxpayerCommercialRegisterFilePath,
          'original_file_name': taxpayerCommercialRegisterOriginalName,
          'full_url': taxpayerCommercialRegisterUrl,
        };
      }
      if (taxpayerOtherAttachmentNameController.text.isNotEmpty) {
        taxpayer['other_attachment_name'] =
            taxpayerOtherAttachmentNameController.text.trim();
        if (taxpayerOtherAttachmentFilePath != null) {
          taxpayer['other_attachment'] = {
            'file_id': taxpayerOtherAttachmentFilePath,
            'original_file_name': taxpayerOtherAttachmentOriginalName,
            'full_url': taxpayerOtherAttachmentUrl,
          };
        }
      }
    }

    final lookups = context.read<DeclarationLookupsCubit>().lookups;
    final taxpayerTypeId = (lookups?.taxpayerTypes ?? [])
        .firstWhere(
          (p) => p.name == taxpayerTypes,
          orElse: () => DeclarationLookup(id: 1, name: ''),
        )
        .id;

    if (applicantType == ApplicantType.sharedOwnership) {
      taxpayer["type_id"] = null;
    } else {
      taxpayer["type_id"] = taxpayerTypeId;
    }

    payload['taxpayer'] = taxpayer;
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
