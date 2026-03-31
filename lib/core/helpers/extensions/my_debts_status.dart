import 'package:flutter/material.dart';
import 'package:reta/core/theme/app_colors.dart';

Color myDebtsStatusColor(String statusId) {
  switch (statusId) {
    case '1':
      return AppColors.neutralDarkLightest; // مسودة
    case '2':
      return AppColors.successMedium; // تم التقديم
    case '3':
      return AppColors.highlightDark; // قيد التعديل
    case '4':
      return AppColors.mainOrange; // قيد المراجعة
    case '5':
      return AppColors.errorDark; // ملغي لغلق باب التقديم
    default:
      return AppColors.highlightDark;
  }
}
