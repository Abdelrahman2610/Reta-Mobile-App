import 'dart:ui';

import 'package:reta/core/theme/app_colors.dart';

enum OnlinePaymentTransactionStatus {
  success,
  pendingFailure,
  failed;

  String get displayText {
    switch (this) {
      case OnlinePaymentTransactionStatus.success:
        return 'نجاح السداد';
      case OnlinePaymentTransactionStatus.pendingFailure:
        return 'معلق لفشل السداد';
      case OnlinePaymentTransactionStatus.failed:
        return 'فشل السداد';
    }
  }

  Color get statusColor {
    switch (this) {
      case OnlinePaymentTransactionStatus.success:
        return AppColors.successMedium;
      case OnlinePaymentTransactionStatus.pendingFailure:
        return AppColors.warningDark;
      case OnlinePaymentTransactionStatus.failed:
        return AppColors.errorMedium;
    }
  }

  String get toJson {
    switch (this) {
      case OnlinePaymentTransactionStatus.success:
        return 'success';
      case OnlinePaymentTransactionStatus.pendingFailure:
        return 'pending_failure';
      case OnlinePaymentTransactionStatus.failed:
        return 'failed';
    }
  }
}

extension PaymentStatusExtensionString on String {
  OnlinePaymentTransactionStatus get fromJson {
    switch (this) {
      case 'success':
        return OnlinePaymentTransactionStatus.success;
      case 'pending_failure':
        return OnlinePaymentTransactionStatus.pendingFailure;
      case 'failed':
        return OnlinePaymentTransactionStatus.failed;
      default:
        return OnlinePaymentTransactionStatus.success;
    }
  }
}
