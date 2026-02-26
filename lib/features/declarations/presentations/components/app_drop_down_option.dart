import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../components/app_text.dart';

DropdownMenuItem<String> appDropDownOption({
  required String label,
  double? fontSize,
  Color? textColor,
}) {
  return DropdownMenuItem(
    value: label,
    child: Align(
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: AppText(
          alignment: AlignmentDirectional.centerEnd,
          text: label,
          fontSize: fontSize ?? 14.sp,
          textAlign: TextAlign.left,
          fontWeight: FontWeight.w400,
          color: textColor ?? AppColors.neutralDarkDarkest,
        ),
      ),
    ),
  );
}
