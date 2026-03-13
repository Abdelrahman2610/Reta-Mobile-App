class ApiConstants {
  // ─── Base URL ───────────────────────────────────────────────────────────────
  // static const String baseUrl =
  //     'http://dev-rta-services.etax.com.eg/reta-services/public/api';

  // static const String baseUrl =
  //     'https://tst-rta-services.etax.com.eg/reta-services/public/api';
  static const String baseUrl = 'http://10.0.2.2:3000/api';
  // ─── Auth ───────────────────────────────────────────────────────────────────
  static const String login = '/login';
  static const String registerSendOtp = '/register/sendOTP';

  static const String registerConfirmOtp = '/validatePhone/confirmOtp';

  // ─── Forgot Password (Phone flow) ───────────────────────────────────────────
  static const String forgotPasswordPhone = '/forgot-password-phone';
  static const String resetPasswordOtp = '/reset-password-otp';
  static const String generateTokenForOtp = '/generate-token-for-otp';
  static const String resetPassword = '/reset-password';

  // ─── Forgot Password (Email flow) ───────────────────────────────────────────
  static const String forgotPasswordEmail = '/forgot-password-mail';

  // ─── Profile Verifications ──────────────────────────────────────────────────
  static const String userProfile = '/user-profile';
  static const String validatePhoneSendOtp = '/validatePhone/sendOtp';
  static const String validatePhoneConfirmOtp = '/validatePhone/confirmOtp';
  static const String validateEmail = '/validateEmail';
  static const String validateIdentity = '/validateIdentity';
  static const String userVerifications = '/user/verifications';
  static const String checkEmailVerified = '/check-email-verified';

  // ─── Profile Edit ────────────────────────────────────────────────────────────
  static const String editProfile = '/edit-profile';
  static const String editPassword = '/edit-password';

  // ─── File Upload ─────────────────────────────────────────────────────────────
  static const String uploadAttachment =
      '/declaration-system/declarations/upload-attachments';

  // ─── Declarations ────────────────────────────────────────────────────────────
  static const String declarations = '/declaration-system/declarations';

  static String declarationById(String id) =>
      '/declaration-system/declarations/$id';

  static String cancelDeclarationById(String id) =>
      '/declaration-system/declarations/$id/cancel';

  static String submitDeclaration(String id) =>
      '/declaration-system/declarations/$id/submit';

  static String deleteUnit(
    String declarationId,
    String unitType,
    String unitId,
  ) =>
      '/declaration-system/declarations/$declarationId/units/$unitType/$unitId';

  // ─── Lookups ─────────────────────────────────────────────────────────────────
  static const String lookupBase = '/declaration-system/declaration-lookups';

  static const String allLookups = '$lookupBase/declaration-all-lookups';
  static const String listFilterLookups = '$lookupBase/list-filter-all-lookups';

  static const String governoratesPublic = '/category/governorates/out';
  static const String nationalitiesPublic = '/category/nationalities';
  static const String genderPublic = '/category/gender';

  static const String governorates = '$lookupBase/governorates';

  static const String declarationTypes = '$lookupBase/declaration-types';
  static const String propertyTypes = '$lookupBase/property-types';
  static const String taxpayerTypes = '$lookupBase/taxpayer-types';
  static const String applicantRoles = '$lookupBase/applicant-roles';
  static const String realEstateFloors = '$lookupBase/real-estate-floors';
  static const String mineQuarryFacilityLookups =
      '$lookupBase/mineQuarry-facility-lookups';
  static const String industrialFacilityLookups =
      '$lookupBase/industrial-facility-lookups';
  static const String productionFacilityLookups =
      '$lookupBase/production-facility-lookups';
  static const String starRatings = '$lookupBase/getStarRatings';
  static const String exploitationTypes = '$lookupBase/getExploitationTypes';
  static const String viewTypes = '$lookupBase/getViewTypes';
  static const String hotelCategories = '$lookupBase/getHotelCategories';
  static const String claimStatus = '$lookupBase/claim-status';

  static String districtsByGovernorate(int governorateId) =>
      '$lookupBase/governorates/$governorateId/districts';

  static String villagesByDistrict(int districtId) =>
      '$lookupBase/districts/$districtId/villages';

  static String regionsByVillage(int villageId) =>
      '$lookupBase/villages/$villageId/regions';

  static String realEstatesByRegion(int regionId) =>
      '$lookupBase/regions/$regionId/real-estates';

  static String unitsByRealEstate(int realEstateId) =>
      '$lookupBase/real-estates/$realEstateId/units';

  // ─── Claims ──────────────────────────────────────────────────────────────────
  static const String storeClaim =
      '/declaration-system/declarations/user/claim';
  static String claimsList(int declarationId) =>
      '/declaration-system/declarations/user/declaration/claims-list/$declarationId';
  static String claimDetail(int claimId) =>
      '/declaration-system/declarations/user/claims/$claimId';
  static String cancelClaim(int claimId) =>
      '/declaration-system/declarations/user/claim/$claimId';
  static String claimTransactionDetails(int claimId) =>
      '/declaration-system/declarations/user/claims-payment-transaction-details/$claimId';

  // ─── Wallet / Payment ────────────────────────────────────────────────────────
  static String walletDetails(int declarationId) =>
      '/declaration-system/declarations/wallet/$declarationId';
  static String initialPayment(int claimId) =>
      '/declaration-system/initial-payment/$claimId';
  static String underDeclarationProperties(int declarationId) =>
      '/declaration-system/UnderDeclarationProperties/list/$declarationId';
  static const String settlementOfDebts =
      '/declaration-system/declarations/settlement-of-debts-with-the-taxpayers-knowledge';

  /// ------------------------------ Files label ---------------------------------
  static const String nationalIdLabel = 'national_id_attachment';
  static const String passportLabel = 'passport_attachment';
  static const String ownershipProofDocumentLabel =
      'joint_ownership_document'; //سند الملكية
  static const String taxpayerAuthorizationLabel =
      'power_of_attorney'; //سند التوكيل
  static const String taxpayerTaxCardLabel =
      'tax_card_attachment'; //سند الضريبة
  static const String taxpayerCommercialRegisterLabel =
      'commercial_register_attachment'; //سجل تجاري
  static const String taxpayerOtherAttachmentLabel =
      'other_attachment'; //مستند آخر
  static const String ownershipDeedLabel = 'ownership_deed'; //سند تمليك
  static const String leaseContractLabel = 'lease_contract'; //عقد ايجار
  static const String permitPhotoLabel = 'license_photo'; //صورة رخصة
  static const String constructionLicenseLabel =
      'construction_license'; //رخصة بناء
  static const String operatingLicenseLabel =
      'operating_licenses'; //ترخيص تشغيل
  static const String starCertificateLabel = 'star_certificate'; //شهادة_نجومية
}
