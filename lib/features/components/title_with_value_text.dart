import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/app_colors.dart';
import 'app_text.dart';

class TitleWithValueText extends StatelessWidget {
  final String title;
  final String value;

  final Color? valueColor;
  final double? width;

  const TitleWithValueText(
    this.title,
    this.value, {
    super.key,
    this.valueColor,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.maxFinite,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.neutralLightDark),
        color: Colors.transparent,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        child: Column(
          children: [
            AppText(
              text: title,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.neutralDarkMedium,
            ),
            SizedBox(height: 4.h),
            AppText(
              text: value,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: valueColor ?? AppColors.highlightDarkest,
            ),
          ],
        ),
      ),
    );
  }
}
