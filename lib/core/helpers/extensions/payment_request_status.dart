import 'package:flutter/material.dart';
import 'package:reta/core/theme/app_colors.dart';

import '../app_enum.dart';

extension PaymentRequestStatusX on PaymentRequestStatus {
  String get label {
    switch (this) {
      case PaymentRequestStatus.pending:
        return 'لم يتم السداد';
      case PaymentRequestStatus.inProgress:
        return 'جاري السداد';
      case PaymentRequestStatus.paid:
        return 'تم السداد';
      case PaymentRequestStatus.cancelled:
        return 'ملغاة';
      case PaymentRequestStatus.failedOnHold:
        return 'معلق لفشل السداد';
    }
  }

  Color get badgeColor {
    switch (this) {
      case PaymentRequestStatus.pending:
      case PaymentRequestStatus.inProgress:
        return AppColors.highlightDark;
      case PaymentRequestStatus.paid:
        return AppColors.successMedium;
      case PaymentRequestStatus.cancelled:
        return AppColors.errorDark;
      case PaymentRequestStatus.failedOnHold:
        return AppColors.mainOrange;
    }
  }

  Gradient get cardBackground {
    final colors = switch (this) {
      PaymentRequestStatus.paid => [
        Color(0xFFB8E8D0),
        Color(0xFFD4F0E2),
        Color(0xFFE8F7F0),
        Colors.white,
      ],
      PaymentRequestStatus.cancelled => [
        Color(0xFFF5C5B8),
        Color(0xFFF9D9D0),
        Color(0xFFFBEEE8),
        Colors.white,
      ],
      PaymentRequestStatus.failedOnHold => [
        Color(0xFFF8D5B0),
        Color(0xFFFAE4C8),
        Color(0xFFFDF0E0),
        Colors.white,
      ],
      PaymentRequestStatus.pending => [
        Color(0xFFC8DFF5),
        Color(0xFFDDEAF8),
        Color(0xFFEDF4FB),
        Colors.white,
      ],
      PaymentRequestStatus.inProgress => [
        Color(0xFFC8DFF5),
        Color(0xFFDDEAF8),
        Color(0xFFEDF4FB),
        Colors.white,
      ],
    };
    return RadialGradient(
      center: Alignment(-1.0, 0),
      radius: 1.0,
      colors: colors,
      stops: const [0.0, 0.03, 0.25, 1.0],
    );
  }

  bool get canPayElectronically {
    return this == PaymentRequestStatus.pending ||
        this == PaymentRequestStatus.failedOnHold;
  }

  bool get canShareReceipt {
    return this == PaymentRequestStatus.paid;
  }

  bool get showDetails {
    return this == PaymentRequestStatus.inProgress ||
        this == PaymentRequestStatus.paid;
  }
}

extension PaymentRequestStatusFromString on String {
  PaymentRequestStatus get toStatus {
    switch (this) {
      case '1':
        return PaymentRequestStatus.pending;
      case '2':
        return PaymentRequestStatus.paid;
      case '3':
        return PaymentRequestStatus.failedOnHold;
      case '4':
        return PaymentRequestStatus.cancelled;
      case '5':
        return PaymentRequestStatus.inProgress;
      default:
        return PaymentRequestStatus.pending;
    }
  }
}

extension PaymentStatusColorX on dynamic {
  Color get toStatusColor {
    switch (this) {
      case 'all':
        return const Color(0xFFAAAAAA);
      case '1':
        return const Color(0xFF2563EB); // لم يتم السداد
      case '2':
        return const Color(0xFF22C55E); // تم السداد
      case '3':
        return const Color(0xFFF97316); // معلق
      case '4':
        return const Color(0xFFEF4444); // ملغاة
      case '5':
        return const Color(0xFFF59E0B); // جاري الدفع
      default:
        return const Color(0xFFAAAAAA);
    }
  }
}
