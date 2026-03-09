import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/extensions/dimensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../components/app_text.dart';

class PaymentInfoBox extends StatelessWidget {
  const PaymentInfoBox({
    super.key,
    this.value,
    this.label,
    this.suffix,
    this.alignment,
    this.crossAxisAlignment,
    this.valueColor,
    this.valueFontSize,
    this.padding,
    this.borderColor,
  });

  final String? value;
  final String? label;
  final String? suffix;
  final AlignmentDirectional? alignment;
  final CrossAxisAlignment? crossAxisAlignment;
  final Color? valueColor;
  final double? valueFontSize;
  final EdgeInsets? padding;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          padding ?? EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: borderColor ?? AppColors.neutralLightDark),
      ),
      child: Column(
        crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
        children: [
          AppText(
            text: label,
            fontWeight: FontWeight.w500,
            fontSize: 12.sp,
            color: AppColors.neutralDarkMedium,
            alignment: alignment ?? AlignmentDirectional.center,
          ),
          4.hs,
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: TextStyle(
                    fontSize: valueFontSize ?? 12.sp,
                    fontWeight: FontWeight.w600,
                    color: valueColor ?? AppColors.neutralDarkMedium,
                  ),
                ),
                if (suffix != null)
                  TextSpan(
                    text: suffix,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: valueColor ?? AppColors.neutralDarkMedium,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
