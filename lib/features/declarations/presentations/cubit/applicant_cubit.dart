import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reta/core/network/api_constants.dart';
import 'package:reta/core/network/api_result.dart';
import 'package:reta/features/declarations/presentations/cubit/declaration_lookups_cubit.dart';
import 'package:reta/features/declarations/presentations/pages/select_types_of_properties_page.dart';

import '../../../../core/helpers/app_enum.dart';
import '../../../../core/helpers/extensions/applicant_type.dart';
import '../../../../core/helpers/extensions/nationality.dart';
import '../../../../core/services/upload_service.dart';
import '../pages/taxpayer_data_page.dart';
import 'applicant_states.dart';

class ApplicantCubit extends Cubit<ApplicantState> {
  ApplicantCubit({required this.applicantType, required this.declarationId})
    : super(const ApplicantState());

  final formKey = GlobalKey<FormState>();

  final ApplicantType applicantType;
  UnitType unitType = UnitType.residential;
  final int declarationId;

  /// --------------------------- Applicant -----------------------------
  final applicantFirstNameController = TextEditingController();
  final applicantLastNameController = TextEditingController();
  final applicantPhoneController = TextEditingController();
  final applicantEmailController = TextEditingController();
  Nationality applicantNationality = Nationality.egyptian;
  final applicantNationalIdController = TextEditingController();
  String? applicantNationalIdFilePath;
  String? applicantNationalIdOriginalName;
  final applicantPassportNumberController = TextEditingController();
  String? applicantPassportFilePath;
  String? applicantPassportOriginalName;

  void initFromUser(Map<String, dynamic>? user) {
    if (user == null) return;
    String secondName = user['second_name'];
    String thirdName = user['third_name'];
    String fourthName = user['fourth_name'];
    applicantFirstNameController.text = user['first_name'] ?? '';
    applicantLastNameController.text = '$secondName $thirdName $fourthName'
        .trim();
    applicantPhoneController.text = user['mobile'] ?? '';
    applicantEmailController.text = user['email'] ?? '';

    final nationalityName = user['nationality']?['name'] ?? '';
    if (nationalityName == 'مصر') {
      applicantNationality = Nationality.egyptian;
    } else {
      applicantNationality = Nationality.foreign;
    }

    if (applicantNationality == Nationality.egyptian) {
      applicantNationalIdController.text = user['national_id'] ?? '';
    } else {
      applicantPassportNumberController.text = user['passport_num'] ?? '';
    }

    final nationalIdFiles = user['national_id_file'] as List?;
    if (nationalIdFiles != null && nationalIdFiles.isNotEmpty) {
      applicantNationalIdFilePath = nationalIdFiles.first['full_url'];
    }

    final passportFiles = user['passport_num_file'] as List?;
    if (passportFiles != null && passportFiles.isNotEmpty) {
      applicantPassportFilePath = passportFiles.first['full_url'];
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
  final taxpayerPassportNumberController = TextEditingController();
  String? taxpayerPassportFilePath;
  String? taxpayerPassportOriginalName;
  String? taxpayerPassportUrl;
  String? ownershipProofDocumentPath;
  String? ownershipProofDocumentOriginName;
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
  final taxpayerCommercialRegisterController = TextEditingController();
  String? taxpayerCommercialRegisterFilePath;
  String? taxpayerCommercialRegisterOriginalName;
  final taxpayerOtherAttachmentNameController = TextEditingController();
  String? taxpayerOtherAttachmentFilePath;
  String? taxpayerOtherAttachmentOriginalName;
  String? taxpayerAuthorizationFilePath;
  String? taxpayerAuthorizationOriginName;
  String? taxpayerAuthorizationUrl;

  /// ------------------ End of taxpayer information ------------------------

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
        emit(state.copyWith(isLoading: false));
      case ApiError<UploadedFileModel>(:final message):
        emit(state.copyWith(isLoading: false, errorMessage: message));
    }
    emit(
      state.copyWith(taxpayerNationalIdFilePath: taxpayerNationalIdFilePath),
    );
  }

  void removeNationalIdFile() {
    taxpayerNationalIdFilePath = null;
    emit(state.copyWith(taxpayerNationalIdFilePath: 'remove'));
  }

  Future<void> setPassportFile(String path) async {
    emit(state.copyWith(isLoading: true));
    final result = await UploadService.instance.uploadFile(
      filePath: path,
      label: ApiConstants.passportLabel,
    );
    switch (result) {
      case ApiSuccess<UploadedFileModel>(:final data):
        applicantPassportFilePath = data.path;
        applicantPassportOriginalName = data.originalFileName;
        emit(state.copyWith(isLoading: false));
      case ApiError<UploadedFileModel>(:final message):
        emit(state.copyWith(isLoading: false, errorMessage: message));
    }
    emit(state.copyWith(taxpayerPassportFilePath: taxpayerPassportFilePath));
  }

  void removePassportFile() {
    taxpayerPassportFilePath = null;
    emit(state.copyWith(taxpayerPassportFilePath: 'remove'));
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
        ownershipProofDocumentOriginName = data.originalFileName;
        ownershipProofDocumentUrl = data.fullUrl;
        emit(state.copyWith(isLoading: false));
      case ApiError<UploadedFileModel>(:final message):
        emit(state.copyWith(isLoading: false, errorMessage: message));
    }
    emit(
      state.copyWith(ownershipProofDocumentPath: ownershipProofDocumentPath),
    );
  }

  void removeOwnershipProofDocumentFile() {
    ownershipProofDocumentPath = null;
    emit(state.copyWith(ownershipProofDocumentPath: 'remove'));
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
      ),
    );
  }

  void removeLegalAuthorizationFile() {
    taxpayerAuthorizationFilePath = null;
    emit(state.copyWith(taxpayerAuthorizationFilePath: 'remove'));
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
        emit(state.copyWith(isLoading: false));
      case ApiError<UploadedFileModel>(:final message):
        emit(state.copyWith(isLoading: false, errorMessage: message));
    }
    emit(state.copyWith(taxpayerTaxCardFilePath: taxpayerTaxCardFilePath));
  }

  void removeTaxCardFile() {
    taxpayerTaxCardFilePath = null;
    emit(state.copyWith(taxpayerTaxCardFilePath: 'remove'));
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
        emit(state.copyWith(isLoading: false));
      case ApiError<UploadedFileModel>(:final message):
        emit(state.copyWith(isLoading: false, errorMessage: message));
    }
    emit(
      state.copyWith(
        taxpayerCommercialRegisterFilePath: taxpayerCommercialRegisterFilePath,
      ),
    );
  }

  void removeCommercialRegisterFile() {
    taxpayerCommercialRegisterFilePath = null;
    emit(state.copyWith(taxpayerCommercialRegisterFilePath: 'remove'));
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
        emit(state.copyWith(isLoading: false));
      case ApiError<UploadedFileModel>(:final message):
        emit(state.copyWith(isLoading: false, errorMessage: message));
    }
    emit(
      state.copyWith(
        taxpayerOtherAttachmentFilePath: taxpayerOtherAttachmentFilePath,
      ),
    );
  }

  void removeOtherAttachmentFile() {
    taxpayerOtherAttachmentFilePath = null;
    emit(state.copyWith(taxpayerOtherAttachmentFilePath: 'remove'));
  }

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

  // ──────────────────────────────────────────────────────
  // Validation
  // ──────────────────────────────────────────────────────

  bool validate() {
    final isFormValid = formKey.currentState?.validate() ?? false;
    if (!isFormValid) return false;

    if (applicantNationalIdFilePath == null) {
      emit(state.copyWith(errorMessage: 'يرجى رفع صورة الرقم القومي'));
      return false;
    }

    switch (state.applicantType) {
      case ApplicantType.owner:
      case ApplicantType.beneficiary:
      case ApplicantType.agent:
        if (applicantPassportFilePath == null) {
          emit(state.copyWith(errorMessage: 'يرجى رفع صورة جواز السفر'));
          return false;
        }
        break;
      case ApplicantType.sharedOwnership:
        if (applicantPassportFilePath == null) {
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
        applicantType == ApplicantType.beneficiary) {
      log("ApiBody: ${buildPayload()}");
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
    log("ApiBody: ${buildPayload()}");
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
          ),
        ),
      ),
    );
  }

  Future<void> submit() async {
    if (!validate()) return;

    emit(state.copyWith(isLoading: true));

    try {
      // TODO:Call API
      final payload = buildPayload();
      debugPrint('Payload: $payload');

      // await repository.submitApplicant(payload);

      emit(state.copyWith(isLoading: false, successMessage: 'تم الحفظ بنجاح'));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Map<String, dynamic> buildPayload() {
    final applicantRoleId = applicantType.id;

    final Map<String, dynamic> payload = {
      'declaration_type_id': 1, // TODO: Need to change this
      'applicant_role_id': applicantRoleId,
    };

    if (applicantType == ApplicantType.other) {
      payload["applicant_role_other"] = null;
    }

    // ── سند التوكيل ──────────────────────────────────
    if (applicantType == ApplicantType.agent ||
        applicantType == ApplicantType.legalRepresentative ||
        applicantType == ApplicantType.other) {
      if (taxpayerAuthorizationFilePath != null) {
        payload['power_of_attorney'] = {
          'path': taxpayerAuthorizationFilePath,
          'original_file_name': taxpayerAuthorizationOriginName,
          'full_url': taxpayerAuthorizationUrl,
        };
      }
    }

    // ── سند الملكية على الشيوع ───────────────────────
    if (applicantType == ApplicantType.sharedOwnership) {
      if (ownershipProofDocumentPath != null) {
        payload['joint_ownership_document'] = {
          'path': ownershipProofDocumentPath,
          'original_file_name': ownershipProofDocumentOriginName,
          'full_url': ownershipProofDocumentUrl,
        };
      }
    }

    payload['taxpayer'] = _buildTaxpayerPayload();

    return payload;
  }

  Map<String, dynamic> _buildTaxpayerPayload() {
    // للمالك والمنتفع — المكلف هو نفس المقدم
    final Map<String, dynamic> taxpayer = {
      'type_id': 1,
      'first_name': taxpayerNameController.text.trim(), // اسم المكلف
      'last_name': '',
      'nationality_id': taxpayerNationality.id,
      'phone': taxpayerPhoneController.text.trim(),
      'email': taxpayerEmailController.text.trim(),
    };
    if (applicantType == ApplicantType.owner ||
        applicantType == ApplicantType.beneficiary) {
      if (applicantNationality == Nationality.egyptian) {
        taxpayer['national_id'] = applicantNationalIdController.text.trim();
        if (applicantNationalIdFilePath != null) {
          taxpayer['national_id_attachment'] = {
            'path': applicantNationalIdFilePath,
            'original_file_name': applicantNationalIdOriginalName,
          };
        }
      } else {
        taxpayer['passport_number'] = applicantPassportNumberController.text
            .trim();
        if (applicantPassportFilePath != null) {
          taxpayer['passport_attachment'] = {
            'path': applicantPassportFilePath,
            'original_file_name': applicantPassportOriginalName,
          };
        }
      }
      return taxpayer;
    }

    // أضف case للـ sharedOwnership
    if (applicantType == ApplicantType.sharedOwnership) {
      if (taxpayerNationality == Nationality.egyptian) {
        taxpayer['national_id'] = taxpayerNationalIdController.text.trim();
        if (taxpayerNationalIdFilePath != null) {
          taxpayer['national_id_attachment'] = {
            'path': taxpayerNationalIdFilePath,
            'original_file_name': taxpayerNationalIdOriginalName,
          };
        }
      } else {
        taxpayer['passport_number'] = taxpayerPassportNumberController.text
            .trim();
        if (taxpayerPassportFilePath != null) {
          taxpayer['passport_attachment'] = {
            'path': taxpayerPassportFilePath,
            'original_file_name': taxpayerPassportOriginalName,
            'full_url': taxpayerPassportUrl,
          };
        }
      }
      return taxpayer;
    }

    // للباقي — المكلف شخص آخر
    if (taxpayerTypes == 'طبيعي') {
      final Map<String, dynamic> taxpayer = {
        'type_id': 1,
        'first_name': taxpayerFirstNameController.text.trim(),
        'last_name': taxpayerLastNameController.text.trim(),
        'nationality_id': taxpayerNationality.id,
        'phone': taxpayerPhoneController.text.trim(),
        'email': taxpayerEmailController.text.trim(),
      };
      if (taxpayerNationality == Nationality.egyptian) {
        taxpayer['national_id'] = taxpayerNationalIdController.text.trim();
        if (taxpayerNationalIdFilePath != null) {
          taxpayer['national_id_attachment'] = {
            'path': taxpayerNationalIdFilePath,
            'original_file_name': taxpayerNationalIdOriginalName,
          };
        }
      } else {
        taxpayer['passport_number'] = taxpayerPassportNumberController.text
            .trim();
        if (taxpayerPassportFilePath != null) {
          taxpayer['passport_attachment'] = {
            'path': taxpayerPassportFilePath,
            'original_file_name': applicantPassportOriginalName,
            'full_url': taxpayerPassportUrl,
          };
        }
      }
      return taxpayer;
    } else {
      // اعتباري
      return {
        'type_id': 2,
        'name': taxpayerNameController.text.trim(),
        'nationality_id': taxpayerNationality.id,
        'tax_card_number': taxpayerTaxCardNumberController.text.trim(),
        'commercial_register': taxpayerCommercialRegisterController.text.trim(),
        if (taxpayerTaxCardFilePath != null)
          'tax_card_attachment': {
            'path': taxpayerTaxCardFilePath,
            'original_file_name': taxpayerTaxCardOriginalName,
          },
        if (taxpayerCommercialRegisterFilePath != null)
          'commercial_register_attachment': {
            'path': taxpayerCommercialRegisterFilePath,
            'original_file_name': taxpayerCommercialRegisterOriginalName,
          },
        if (taxpayerOtherAttachmentNameController.text.isNotEmpty) ...{
          'other_attachment_name': taxpayerOtherAttachmentNameController.text
              .trim(),
          if (taxpayerOtherAttachmentFilePath != null)
            'other_attachment': {
              'path': taxpayerOtherAttachmentFilePath,
              'original_file_name': taxpayerOtherAttachmentOriginalName,
            },
        },
      };
    }
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
}
