import '../../../../core/helpers/app_enum.dart';

class ApplicantState {
  final ApplicantType? applicantType;
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;
  final Nationality? taxpayerNationality;
  final String? ownershipProofDocumentPath;
  final String? taxpayerNationalIdFilePath;
  final String? taxpayerPassportFilePath;
  final String? taxpayerTypes;
  final String? taxpayerAuthorizationFilePath;
  final String? taxpayerTaxCardFilePath;
  final String? taxpayerCommercialRegisterFilePath;
  final String? taxpayerOtherAttachmentFilePath;

  const ApplicantState({
    this.applicantType,
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
    this.taxpayerNationality,
    this.ownershipProofDocumentPath,
    this.taxpayerNationalIdFilePath,
    this.taxpayerPassportFilePath,
    this.taxpayerTypes,
    this.taxpayerAuthorizationFilePath,
    this.taxpayerTaxCardFilePath,
    this.taxpayerCommercialRegisterFilePath,
    this.taxpayerOtherAttachmentFilePath,
  });

  ApplicantState copyWith({
    ApplicantType? applicantType,
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
    Nationality? taxpayerNationality,
    String? ownershipProofDocumentPath,
    String? taxpayerNationalIdFilePath,
    String? taxpayerPassportFilePath,
    String? taxpayerTypes,
    String? taxpayerAuthorizationFilePath,
    String? taxpayerTaxCardFilePath,
    String? taxpayerCommercialRegisterFilePath,
    String? taxpayerOtherAttachmentFilePath,
  }) {
    return ApplicantState(
      applicantType: applicantType ?? this.applicantType,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      successMessage: successMessage,
      taxpayerNationality: taxpayerNationality ?? this.taxpayerNationality,
      ownershipProofDocumentPath: ownershipProofDocumentPath == 'remove'
          ? null
          : ownershipProofDocumentPath ?? this.ownershipProofDocumentPath,
      taxpayerNationalIdFilePath: taxpayerNationalIdFilePath == 'remove'
          ? null
          : taxpayerNationalIdFilePath ?? this.taxpayerNationalIdFilePath,
      taxpayerPassportFilePath: taxpayerPassportFilePath == 'remove'
          ? null
          : taxpayerPassportFilePath ?? this.taxpayerPassportFilePath,
      taxpayerTypes: taxpayerTypes ?? this.taxpayerTypes,
      taxpayerAuthorizationFilePath: taxpayerAuthorizationFilePath == 'remove'
          ? null
          : taxpayerAuthorizationFilePath ?? this.taxpayerAuthorizationFilePath,
      taxpayerTaxCardFilePath: taxpayerTaxCardFilePath == 'remove'
          ? null
          : taxpayerTaxCardFilePath ?? this.taxpayerTaxCardFilePath,
      taxpayerCommercialRegisterFilePath:
          taxpayerCommercialRegisterFilePath == 'remove'
          ? null
          : taxpayerCommercialRegisterFilePath ??
                this.taxpayerCommercialRegisterFilePath,
      taxpayerOtherAttachmentFilePath:
          taxpayerOtherAttachmentFilePath == 'remove'
          ? null
          : taxpayerOtherAttachmentFilePath ??
                this.taxpayerOtherAttachmentFilePath,
    );
  }
}
