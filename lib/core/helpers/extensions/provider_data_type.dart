import '../app_enum.dart';

extension ProviderDataType on DeclarationsDataType {
  String get displayText {
    switch (this) {
      case DeclarationsDataType.providerData:
        return 'بيانات المقدم';
      case DeclarationsDataType.taxpayerData:
        return 'بيانات المكلف';
      case DeclarationsDataType.locationData:
        return 'بيانات الموقع';
      case DeclarationsDataType.unitData:
        return 'بيانات الوحدة';
    }
  }

  String get displayIndex {
    switch (this) {
      case DeclarationsDataType.providerData:
        return '1';
      case DeclarationsDataType.taxpayerData:
        return '2';
      case DeclarationsDataType.locationData:
        return '1';
      case DeclarationsDataType.unitData:
        return '2';
    }
  }
}
