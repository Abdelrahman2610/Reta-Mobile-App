import 'package:equatable/equatable.dart';

import '../../../../core/helpers/app_enum.dart';

class ApplicantState extends Equatable {
  final ApplicantType? applicantType;
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;
  final Nationality? taxpayerNationality;
  final String? ownershipProofDocumentPath;
  final String? ownershipProofDocumentFullUrl;
  final String? taxpayerNationalIdFilePath;
  final String? taxpayerNationalIdFileUrl;
  final String? taxpayerPassportFilePath;
  final String? taxpayerPassportFileUrl;
  final String? taxpayerTypes;
  final String? taxpayerAuthorizationFilePath;
  final String? taxpayerAuthorizationFileId;
  final String? taxpayerAuthorizationFullUrl;
  final String? taxpayerTaxCardFilePath;
  final String? taxpayerTaxCardFullUrl;
  final String? taxpayerCommercialRegisterFilePath;
  final String? taxpayerCommercialRegisterFullUrl;
  final String? taxpayerOtherAttachmentFilePath;
  final String? taxpayerOtherAttachmentFullUrl;

  const ApplicantState({
    this.applicantType,
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
    this.taxpayerNationality,
    this.ownershipProofDocumentPath,
    this.ownershipProofDocumentFullUrl,
    this.taxpayerNationalIdFilePath,
    this.taxpayerNationalIdFileUrl,
    this.taxpayerPassportFilePath,
    this.taxpayerPassportFileUrl,
    this.taxpayerTypes,
    this.taxpayerAuthorizationFilePath,
    this.taxpayerAuthorizationFileId,
    this.taxpayerAuthorizationFullUrl,
    this.taxpayerTaxCardFilePath,
    this.taxpayerTaxCardFullUrl,
    this.taxpayerCommercialRegisterFilePath,
    this.taxpayerCommercialRegisterFullUrl,
    this.taxpayerOtherAttachmentFilePath,
    this.taxpayerOtherAttachmentFullUrl,
  });

  @override
  List<Object?> get props => [
    taxpayerTypes,
    taxpayerNationality,
    taxpayerNationalIdFilePath,
    taxpayerPassportFilePath,
    taxpayerAuthorizationFilePath,
    isLoading,
    errorMessage,
    successMessage,
    ownershipProofDocumentPath,
    ownershipProofDocumentFullUrl,
  ];

  ApplicantState copyWith({
    ApplicantType? applicantType,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    String? successMessage,
    bool clearSuccess = false,
    Nationality? taxpayerNationality,
    String? ownershipProofDocumentPath,
    String? ownershipProofDocumentFullUrl,
    String? taxpayerNationalIdFilePath,
    String? taxpayerNationalIdFileUrl,
    String? taxpayerPassportFilePath,
    String? taxpayerPassportFileUrl,
    String? taxpayerTypes,
    String? taxpayerAuthorizationFilePath,
    String? taxpayerAuthorizationFileId,
    String? taxpayerAuthorizationFullUrl,
    String? taxpayerTaxCardFilePath,
    String? taxpayerTaxCardFullUrl,
    String? taxpayerCommercialRegisterFilePath,
    String? taxpayerCommercialRegisterFullUrl,
    String? taxpayerOtherAttachmentFilePath,
    String? taxpayerOtherAttachmentFullUrl,
  }) {
    return ApplicantState(
      applicantType: applicantType ?? this.applicantType,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      successMessage: clearSuccess
          ? null
          : successMessage ?? this.successMessage,
      taxpayerNationality: taxpayerNationality ?? this.taxpayerNationality,
      ownershipProofDocumentPath: ownershipProofDocumentPath == 'remove'
          ? null
          : ownershipProofDocumentPath ?? this.ownershipProofDocumentPath,
      ownershipProofDocumentFullUrl: ownershipProofDocumentFullUrl == 'remove'
          ? null
          : ownershipProofDocumentFullUrl ?? this.ownershipProofDocumentFullUrl,
      taxpayerNationalIdFilePath: taxpayerNationalIdFilePath == 'remove'
          ? null
          : taxpayerNationalIdFilePath ?? this.taxpayerNationalIdFilePath,
      taxpayerNationalIdFileUrl: taxpayerNationalIdFileUrl == 'remove'
          ? null
          : taxpayerNationalIdFileUrl ?? this.taxpayerNationalIdFileUrl,
      taxpayerPassportFilePath: taxpayerPassportFilePath == 'remove'
          ? null
          : taxpayerPassportFilePath ?? this.taxpayerPassportFilePath,
      taxpayerPassportFileUrl: taxpayerPassportFileUrl == 'remove'
          ? null
          : taxpayerPassportFileUrl ?? this.taxpayerPassportFileUrl,
      taxpayerTypes: taxpayerTypes ?? this.taxpayerTypes,
      taxpayerAuthorizationFilePath: taxpayerAuthorizationFilePath == 'remove'
          ? null
          : taxpayerAuthorizationFilePath ?? this.taxpayerAuthorizationFilePath,
      taxpayerAuthorizationFileId: taxpayerAuthorizationFileId == 'remove'
          ? null
          : taxpayerAuthorizationFileId ?? this.taxpayerAuthorizationFileId,
      taxpayerAuthorizationFullUrl: taxpayerAuthorizationFullUrl == 'remove'
          ? null
          : taxpayerAuthorizationFullUrl ?? this.taxpayerAuthorizationFullUrl,
      taxpayerTaxCardFilePath: taxpayerTaxCardFilePath == 'remove'
          ? null
          : taxpayerTaxCardFilePath ?? this.taxpayerTaxCardFilePath,
      taxpayerTaxCardFullUrl: taxpayerTaxCardFullUrl == 'remove'
          ? null
          : taxpayerTaxCardFullUrl ?? this.taxpayerTaxCardFullUrl,
      taxpayerCommercialRegisterFilePath:
          taxpayerCommercialRegisterFilePath == 'remove'
          ? null
          : taxpayerCommercialRegisterFilePath ??
                this.taxpayerCommercialRegisterFilePath,
      taxpayerCommercialRegisterFullUrl:
          taxpayerCommercialRegisterFullUrl == 'remove'
          ? null
          : taxpayerCommercialRegisterFullUrl ??
                this.taxpayerCommercialRegisterFullUrl,
      taxpayerOtherAttachmentFilePath:
          taxpayerOtherAttachmentFilePath == 'remove'
          ? null
          : taxpayerOtherAttachmentFilePath ??
                this.taxpayerOtherAttachmentFilePath,
      taxpayerOtherAttachmentFullUrl: taxpayerOtherAttachmentFullUrl == 'remove'
          ? null
          : taxpayerOtherAttachmentFullUrl ??
                this.taxpayerOtherAttachmentFullUrl,
    );
  }
}
