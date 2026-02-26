import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reta/core/helpers/extensions/taxpayer_types.dart';
import 'package:reta/features/declarations/presentations/pages/units/unit_location_data_page.dart';

import '../../../../core/helpers/app_enum.dart';
import '../../../../core/helpers/extensions/nationality.dart';
import '../pages/taxpayer_data_page.dart';
import 'applicant_states.dart';

class ApplicantCubit extends Cubit<ApplicantState> {
  ApplicantCubit() : super(const ApplicantState());

  final formKey = GlobalKey<FormState>();

  ApplicantType applicantType = ApplicantType.sharedOwnership;

  /// --------------------------- Applicant -----------------------------
  final applicantFirstNameController = TextEditingController();
  final applicantLastNameController = TextEditingController();
  final applicantPhoneController = TextEditingController();
  final applicantEmailController = TextEditingController();
  Nationality applicantNationality = Nationality.egyptian;
  final applicantNationalIdController = TextEditingController();
  String? applicantNationalIdFilePath;
  final applicantPassportNumberController = TextEditingController();
  String? applicantPassportFilePath;

  void initFromUser(Map<String, dynamic>? user) {
    if (user == null) return;
    applicantFirstNameController.text = user['firstName'] ?? '';
    applicantLastNameController.text = user['lastName'] ?? '';
    applicantPhoneController.text = user['phone'] ?? '';
    applicantEmailController.text = user['email'] ?? '';
    applicantNationalIdFilePath = user['nationalIdFileURL'] ?? '';

    final nationality = user['nationality'];
    if (nationality == 'egyptian') {
      applicantNationality = Nationality.egyptian;
    } else {
      applicantNationality = Nationality.foreign;
    }

    if (applicantNationality == Nationality.egyptian) {
      applicantNationalIdController.text = user['nationalId'] ?? '';
    } else {
      applicantPassportNumberController.text = user['passportNumber'] ?? '';
    }

    emit(state.copyWith(applicantType: state.applicantType));
  }

  /// ----------------------- End of applicant -----------------------------

  /// --------------------- Taxpayer information ---------------------------
  final taxpayerNameController = TextEditingController();
  Nationality taxpayerNationality = Nationality.egyptian;
  final taxpayerNationalIdController = TextEditingController();
  String? taxpayerNationalIdFilePath;
  final taxpayerPassportNumberController = TextEditingController();
  String? taxpayerPassportFilePath;
  String? ownershipProofDocumentPath;
  String? ownershipDeedFilePath;

  final taxpayerFirstNameController = TextEditingController();
  final taxpayerLastNameController = TextEditingController();
  TaxpayerTypes taxpayerTypes = TaxpayerTypes.natural;
  final taxpayerPhoneController = TextEditingController();
  final taxpayerEmailController = TextEditingController();

  final taxpayerTaxCardNumberController = TextEditingController();
  String? taxpayerTaxCardFilePath;
  final taxpayerCommercialRegisterController = TextEditingController();
  String? taxpayerCommercialRegisterFilePath;
  final taxpayerOtherAttachmentNameController = TextEditingController();
  String? taxpayerOtherAttachmentFilePath;
  String? taxpayerAuthorizationFilePath;

  /// ------------------ End of taxpayer information ------------------------

  void changeNationality(String? value) {
    taxpayerNationality = value?.getNationality ?? Nationality.egyptian;
    emit(state.copyWith(taxpayerNationality: taxpayerNationality));
  }

  void changeTaxpayerType(String? value) {
    taxpayerTypes = value?.getTaxpayerType ?? TaxpayerTypes.natural;
    emit(state.copyWith(taxpayerTypes: taxpayerTypes));
  }

  void setNationalIdFile(String path) {
    taxpayerNationalIdFilePath = path;
    emit(
      state.copyWith(taxpayerNationalIdFilePath: taxpayerNationalIdFilePath),
    );
  }

  void removeNationalIdFile() {
    taxpayerNationalIdFilePath = null;
    emit(state.copyWith(taxpayerNationalIdFilePath: 'remove'));
  }

  void setPassportFile(String path) {
    taxpayerPassportFilePath = path;
    emit(state.copyWith(taxpayerPassportFilePath: taxpayerPassportFilePath));
  }

  void removePassportFile() {
    taxpayerPassportFilePath = null;
    emit(state.copyWith(taxpayerPassportFilePath: 'remove'));
  }

  void setOwnershipProofDocumentFile(String path) {
    ownershipProofDocumentPath = path;
    emit(
      state.copyWith(ownershipProofDocumentPath: ownershipProofDocumentPath),
    );
  }

  void removeOwnershipProofDocumentFile() {
    ownershipProofDocumentPath = null;
    emit(state.copyWith(ownershipProofDocumentPath: 'remove'));
  }

  void setLegalAuthorizationFile(String path) {
    taxpayerAuthorizationFilePath = path;
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

  void setTaxCardFile(String path) {
    taxpayerTaxCardFilePath = path;
    emit(state.copyWith(taxpayerTaxCardFilePath: taxpayerTaxCardFilePath));
  }

  void removeTaxCardFile() {
    taxpayerTaxCardFilePath = null;
    emit(state.copyWith(taxpayerTaxCardFilePath: 'remove'));
  }

  void setCommercialRegisterFile(String path) {
    taxpayerCommercialRegisterFilePath = path;
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

  void setOtherAttachmentFile(String path) {
    taxpayerOtherAttachmentFilePath = path;
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
    if (applicantType == ApplicantType.owner ||
        applicantType == ApplicantType.beneficiary) {
      // TODO: Call submit
      log("ApiBody: ${_buildPayload()}");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: this,
            child: UnitLocationDataPage(applicantType: applicantType),
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: this,
            child: TaxpayerDataPage(applicantType: applicantType),
          ),
        ),
      );
    }
  }

  Future<void> onTaxpayerNextTapped(BuildContext context) async {
    log("ApiBody: ${_buildPayload()}");
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: this,
          child: UnitLocationDataPage(applicantType: applicantType),
        ),
      ),
    );
  }

  Future<void> submit() async {
    if (!validate()) return;

    emit(state.copyWith(isLoading: true));

    try {
      // TODO:Call API
      final payload = _buildPayload();
      debugPrint('Payload: $payload');

      // await repository.submitApplicant(payload);

      emit(state.copyWith(isLoading: false, successMessage: 'تم الحفظ بنجاح'));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Map<String, dynamic> _buildPayload() {
    Map<String, dynamic> base = {'applicantType': applicantType.name};

    switch (applicantType) {
      case ApplicantType.owner:
      case ApplicantType.beneficiary:
        base = {
          ...base,
          'firstName': applicantFirstNameController.text.trim(),
          'lastName': applicantLastNameController.text.trim(),
          'nationality': applicantNationality.name,
          'phone': applicantPhoneController.text.trim(),
          'email': applicantEmailController.text.trim(),
        };
        if (applicantNationality == Nationality.egyptian) {
          return {
            ...base,
            'nationalId': applicantNationalIdController.text.trim(),
            'nationalIdFile': applicantNationalIdFilePath,
          };
        } else {
          return {
            ...base,
            'passportNumber': applicantPassportNumberController.text.trim(),
            'passportFile': applicantPassportFilePath,
          };
        }
      case ApplicantType.sharedOwnership:
        base = {
          ...base,
          'taxpayerName': taxpayerNameController.text.trim(),
          'nationality': applicantNationality.name,
          'ownershipProofDocumentPath': ownershipProofDocumentPath,
        };

        if (applicantNationality == Nationality.egyptian) {
          return {
            ...base,
            'nationalId': taxpayerNationalIdController.text.trim(),
            'nationalIdFile': taxpayerNationalIdFilePath,
          };
        } else {
          return {
            ...base,
            'passportNumber': taxpayerPassportNumberController.text.trim(),
            'passportFile': taxpayerPassportFilePath,
          };
        }

      case ApplicantType.agent:
      case ApplicantType.legalRepresentative:
      case ApplicantType.other:
        base = {
          ...base,
          'taxpayerType': taxpayerTypes.name,
          'phoneNumber': taxpayerPhoneController.text.trim(),
          'email': taxpayerEmailController.text.trim(),
          if (applicantType == ApplicantType.agent)
            'authorizationFilePath': taxpayerAuthorizationFilePath,
          if (applicantType == ApplicantType.legalRepresentative)
            'legalAuthorizationFilePath': taxpayerAuthorizationFilePath,
          if (applicantType == ApplicantType.other)
            'otherFilePath': taxpayerAuthorizationFilePath,
        };

        if (taxpayerTypes == TaxpayerTypes.natural) {
          base = {
            ...base,
            'taxpayerName':
                '${taxpayerFirstNameController.text.trim()} ${taxpayerLastNameController.text.trim()}',
            'nationality': taxpayerNationality.name,
          };
          if (applicantNationality == Nationality.egyptian) {
            return {
              ...base,
              'nationalId': taxpayerNationalIdController.text.trim(),
              'nationalIdFile': taxpayerNationalIdFilePath,
            };
          } else {
            return {
              ...base,
              'passportNumber': taxpayerPassportNumberController.text.trim(),
              'passportFile': taxpayerPassportFilePath,
            };
          }
        } else if (taxpayerTypes == TaxpayerTypes.conventional) {
          return {
            ...base,
            'taxpayerName': taxpayerNameController.text.trim(),
            'cardNumber': taxpayerTaxCardNumberController.text.trim(),
            'cardFile': taxpayerTaxCardFilePath,
            'commercialRegister': taxpayerCommercialRegisterController.text
                .trim(),
            'commercialRegisterFile': taxpayerCommercialRegisterFilePath,
            'otherAttachmentName': taxpayerOtherAttachmentNameController.text
                .trim(),
            'otherAttachmentFile': taxpayerOtherAttachmentFilePath,
          };
        }
        return base;
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
}
