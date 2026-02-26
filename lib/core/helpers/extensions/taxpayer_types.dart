import 'package:reta/core/helpers/app_enum.dart';

extension TaxpayerTypesExtension on TaxpayerTypes {
  String get displayText {
    switch (this) {
      case TaxpayerTypes.natural:
        return 'طبيعي';
      case TaxpayerTypes.conventional:
        return 'إعتباري';
    }
  }
}

extension TaxpayerTypesFromString on String {
  TaxpayerTypes get getTaxpayerType {
    switch (this) {
      case 'طبيعي':
        return TaxpayerTypes.natural;
      case 'إعتباري':
        return TaxpayerTypes.conventional;
      default:
        return TaxpayerTypes.natural;
    }
  }
}
