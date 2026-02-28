class ApiConstants {
  // ─── Base URL ───────────────────────────────────────────────────────────────
  // static const String baseUrl =
  //     'http://dev-rta-services.etax.com.eg/reta-services/public';

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

  static String declarationById(int id) =>
      '/api/declaration-system/declarations/$id';
  static String submitDeclaration(int id) =>
      '/api/declaration-system/declarations/$id/submit';
  static String deleteUnit(int declarationId, String unitType, int unitId) =>
      '/api/declaration-system/declarations/$declarationId/units/$unitType/$unitId';

  // ─── Lookups ─────────────────────────────────────────────────────────────────
  static const String lookupBase =
      '/api/declaration-system/declaration-lookups';

  static const String allLookups = '$lookupBase/declaration-all-lookups';
  static const String listFilterLookups = '$lookupBase/list-filter-all-lookups';
  static const String governorates = '$lookupBase/governorates';
  static const String declarationTypes = '$lookupBase/declaration-types';
  static const String propertyTypes = '$lookupBase/property-types';
  static const String taxpayerTypes = '$lookupBase/taxpayer-types';
  static const String applicantRoles = '$lookupBase/applicant-roles';
  static const String realEstateFloors = '$lookupBase/real-estate-floors';
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
      '/api/declaration-system/declarations/user/claim';
  static String claimsList(int declarationId) =>
      '/api/declaration-system/declarations/user/declaration/claims-list/$declarationId';
  static String claimDetail(int claimId) =>
      '/api/declaration-system/declarations/user/claims/$claimId';
  static String cancelClaim(int claimId) =>
      '/api/declaration-system/declarations/user/claim/$claimId';
  static String claimTransactionDetails(int claimId) =>
      '/api/declaration-system/declarations/user/claims-payment-transaction-details/$claimId';

  // ─── Wallet / Payment ────────────────────────────────────────────────────────
  static String walletDetails(int declarationId) =>
      '/api/declaration-system/declarations/wallet/$declarationId';
  static String initialPayment(int claimId) =>
      '/api/declaration-system/initial-payment/$claimId';
  static String underDeclarationProperties(int declarationId) =>
      '/api/declaration-system/UnderDeclarationProperties/list/$declarationId';
  static const String settlementOfDebts =
      '/api/declaration-system/declarations/settlement-of-debts-with-the-taxpayers-knowledge';
}
