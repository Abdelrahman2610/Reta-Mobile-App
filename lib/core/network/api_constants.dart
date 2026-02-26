class ApiConstants {
  static const String baseUrl = 'http://reta-services.local/api';

  static const String login = '/login';
  static const String registerSendOtp = '/register/sendOTP';
  static const String registerConfirmOtp = '/register/confirmOTP';
  static const String uploadAttachment =
      '/declaration-system/declarations/upload-attachments';
  static const String declarations = '/declaration-system/declarations';

  static String declarationById(int id) =>
      '/declaration-system/declarations/$id';

  static String submitDeclaration(int id) =>
      '/declaration-system/declarations/$id/submit';
  static String deleteUnit(int declarationId, String unitType, int unitId) =>
      '/declaration-system/declarations/$declarationId/units/$unitType/$unitId';
  static const String lookupBase = '/declaration-system/declaration-lookups';

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
  static String walletDetails(int declarationId) =>
      '/declaration-system/declarations/wallet/$declarationId';
  static String initialPayment(int claimId) =>
      '/declaration-system/initial-payment/$claimId';
  static String underDeclarationProperties(int declarationId) =>
      '/declaration-system/UnderDeclarationProperties/list/$declarationId';
  static const String settlementOfDebts =
      '/declaration-system/declarations/settlement-of-debts-with-the-taxpayers-knowledge';
}
