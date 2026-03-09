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
      case DeclarationsDataType.compositionData:
        return 'بيانات التركيبة';
      case DeclarationsDataType.landData:
        return 'بيانات الأرض';
      case DeclarationsDataType.establishmentData:
        return 'بيانات المنشأة';
      case DeclarationsDataType.payInfo:
        return 'بيانات الدفع';
      case DeclarationsDataType.paymentRequests:
        return 'طلبات السداد';
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
      case DeclarationsDataType.compositionData:
        return '2';
      case DeclarationsDataType.landData:
        return '2';
      case DeclarationsDataType.establishmentData:
        return '2';
      case DeclarationsDataType.payInfo:
        return '1';
      case DeclarationsDataType.paymentRequests:
        return '2';
    }
  }
}
