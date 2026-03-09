import 'dart:ui';

import 'package:reta/core/theme/app_colors.dart';

enum PaymentStatus {
  success,
  pendingFailure,
  failed;

  String get displayText {
    switch (this) {
      case PaymentStatus.success:
        return 'نجاح السداد';
      case PaymentStatus.pendingFailure:
        return 'معلق لفشل السداد';
      case PaymentStatus.failed:
        return 'فشل السداد';
    }
  }

  Color get statusColor {
    switch (this) {
      case PaymentStatus.success:
        return AppColors.successMedium;
      case PaymentStatus.pendingFailure:
        return AppColors.warningDark;
      case PaymentStatus.failed:
        return AppColors.errorMedium;
    }
  }

  String get toJson {
    switch (this) {
      case PaymentStatus.success:
        return 'success';
      case PaymentStatus.pendingFailure:
        return 'pending_failure';
      case PaymentStatus.failed:
        return 'failed';
    }
  }
}

extension PaymentStatusExtensionString on String {
  PaymentStatus get fromJson {
    switch (this) {
      case 'success':
        return PaymentStatus.success;
      case 'pending_failure':
        return PaymentStatus.pendingFailure;
      case 'failed':
        return PaymentStatus.failed;
      default:
        return PaymentStatus.success;
    }
  }
}
