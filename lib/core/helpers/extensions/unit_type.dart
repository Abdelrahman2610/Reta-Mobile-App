import '../app_enum.dart';

extension UnitTypeLabel on UnitType {
  String get label {
    switch (this) {
      case UnitType.residential:
        return 'الوحدات السكنية';
      case UnitType.commercial:
        return 'الوحدات التجارية';
      case UnitType.administrative:
        return 'الوحدات الإدارية';
      case UnitType.serviceUnit:
        return 'الوحدات الخدمية';
      case UnitType.fixedInstallations:
        return 'التركيبات الثابتة';
      case UnitType.vacantLand:
        // return 'أراضي فضاء مستغلة';
        return 'الأرض الفضاء المستغلة';
      case UnitType.serviceFacility:
        return 'المنشآت الخدمية';
      case UnitType.hotelFacility:
        return 'المنشآت الفندقية';
      case UnitType.industrialFacility:
        return 'المنشآت الصناعية';
      case UnitType.productionFacility:
        return 'المنشآت الإنتاجية';
      case UnitType.petroleumFacility:
        return 'منشآت بترولية';
      case UnitType.minesAndQuarries:
        return 'مناجم ومحاجر وملاحات';
    }
  }

  String get unitLabel {
    switch (this) {
      case UnitType.residential:
        return 'وحدة سكنية';
      case UnitType.commercial:
        return 'وحدة تجارية';
      case UnitType.administrative:
        return 'وحدة إدارية';
      case UnitType.serviceUnit:
        return 'وحدة خدمية';
      case UnitType.fixedInstallations:
        return 'تركيبات ثابتة';
      case UnitType.vacantLand:
        return 'أراضٍ فضاء مستغلة';
      case UnitType.serviceFacility:
        return 'المنشآت الخدمية';
      case UnitType.hotelFacility:
        return 'المنشآت الفندقية';
      case UnitType.industrialFacility:
        return 'المنشآت الصناعية';
      case UnitType.productionFacility:
        return 'المنشآت الإنتاجية';
      case UnitType.petroleumFacility:
        return 'المنشآت البترولية';
      case UnitType.minesAndQuarries:
        return 'مناجم/محاجر/ملاحات';
    }
  }

  DeclarationsDataType get tabEnum {
    switch (this) {
      case UnitType.residential:
        return DeclarationsDataType.unitData;
      case UnitType.commercial:
        return DeclarationsDataType.unitData;
      case UnitType.administrative:
        return DeclarationsDataType.unitData;
      case UnitType.serviceUnit:
        return DeclarationsDataType.unitData;
      case UnitType.fixedInstallations:
        return DeclarationsDataType.compositionData;
      case UnitType.vacantLand:
        return DeclarationsDataType.landData;
      case UnitType.serviceFacility:
        return DeclarationsDataType.establishmentData;
      case UnitType.hotelFacility:
        return DeclarationsDataType.establishmentData;
      case UnitType.industrialFacility:
        return DeclarationsDataType.establishmentData;
      case UnitType.productionFacility:
        return DeclarationsDataType.establishmentData;
      case UnitType.petroleumFacility:
        return DeclarationsDataType.establishmentData;
      case UnitType.minesAndQuarries:
        return DeclarationsDataType.establishmentData;
    }
  }
}

extension UnitTypeParser on String {
  UnitType get toUnitType {
    switch (this) {
      case 'الوحدات السكنية':
        return UnitType.residential;
      case 'الوحدات التجارية':
        return UnitType.commercial;
      case 'الوحدات الإدارية':
        return UnitType.administrative;
      case 'الوحدات الخدمية':
        return UnitType.serviceUnit;
      case 'التركيبات الثابتة':
        return UnitType.fixedInstallations;
      case 'أراضي فضاء مستغلة':
      case 'الأرض الفضاء المستغلة':
        return UnitType.vacantLand;
      case 'المنشآت الخدمية':
        return UnitType.serviceFacility;
      case 'المنشآت الفندقية':
        return UnitType.hotelFacility;
      case 'المنشآت الصناعية':
        return UnitType.industrialFacility;
      case 'المنشآت الإنتاجية':
        return UnitType.productionFacility;
      case 'منشآت بترولية':
        return UnitType.petroleumFacility;
      default:
        return UnitType.minesAndQuarries;
    }
  }
}
