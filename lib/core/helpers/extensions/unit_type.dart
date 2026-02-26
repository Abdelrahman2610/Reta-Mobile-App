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
        return 'أراضي فضاء مستغلة';
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
