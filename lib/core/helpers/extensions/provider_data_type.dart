import '../app_enum.dart';

extension ProviderDataType on DeclarationsDataType {
  String get displayText {
    switch (this) {
      case DeclarationsDataType.providerData:
        return 'بيانات المقدم';
      case DeclarationsDataType.taxpayerData:
        return 'بيانات المكلف';
    }
  }

  String get displayIndex {
    switch (this) {
      case DeclarationsDataType.providerData:
        return '1';
      case DeclarationsDataType.taxpayerData:
        return '2';
    }
  }
}
