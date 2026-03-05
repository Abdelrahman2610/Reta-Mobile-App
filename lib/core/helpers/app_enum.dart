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
