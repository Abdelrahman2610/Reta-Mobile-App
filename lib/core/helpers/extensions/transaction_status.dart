import 'dart:ui';

import 'package:reta/core/helpers/app_enum.dart';
import 'package:reta/core/theme/app_colors.dart';

extension TransactionStatusExtension on TransactionStatus {
  String get displayText {
    switch (this) {
      case TransactionStatus.withdraw:
        return 'خصم';
      case TransactionStatus.deposit:
        return 'إسترداد';
    }
  }

  Color get statusColor {
    switch (this) {
      case TransactionStatus.withdraw:
        return AppColors.warningDark;
      case TransactionStatus.deposit:
        return AppColors.successMedium;
    }
  }

  String get toJson {
    switch (this) {
      case TransactionStatus.withdraw:
        return 'withdraw';
      case TransactionStatus.deposit:
        return 'deposit';
    }
  }
}

extension TransactionStatusExtensionString on String {
  TransactionStatus get fromJson {
    switch (this) {
      case 'withdraw':
        return TransactionStatus.withdraw;
      case 'deposit':
        return TransactionStatus.deposit;
      default:
        return TransactionStatus.withdraw;
    }
  }
}
