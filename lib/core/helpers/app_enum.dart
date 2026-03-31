enum ApplicantType {
  owner,
  sharedOwnership,
  beneficiary,
  exploited,
  agent,
  legalRepresentative,
  other,
}

enum DeclarationsDataType {
  providerData,
  taxpayerData,
  locationData,
  unitData,
  compositionData,
  landData,
  establishmentData,
  payInfo,
  paymentRequests,
}

enum Nationality { egyptian, foreign }

enum TaxpayerTypes { natural, conventional }

enum UnitType {
  residential,
  commercial,
  administrative,
  serviceUnit,
  fixedInstallations,
  vacantLand,
  serviceFacility,
  hotelFacility,
  industrialFacility,
  productionFacility,
  petroleumFacility,
  minesAndQuarries,
}

enum UserType { guest, authenticated }

enum TransactionStatus { withdraw, deposit }

enum PaymentRequestStatus { pending, inProgress, paid, cancelled, failedOnHold }

enum PaymentRequestInfoStatus { completed, partiallyCompleted, allAvailable }

enum ClaimsSource { declaration, underDebt }

enum UserAttachmentTypes { nationalId, passport, other }
