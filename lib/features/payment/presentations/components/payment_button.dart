import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reta/core/theme/app_colors.dart';

import '../../../components/app_text.dart';

class PaymentButton extends StatelessWidget {
  const PaymentButton({
    super.key,
    this.onTap,
    this.label,
    this.backgroundColor,
    this.textColor,
  });

  final VoidCallback? onTap;
  final String? label;
  final Color? backgroundColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.highlightDarkest,
          disabledBackgroundColor: AppColors.neutralLightDarkest,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          elevation: 0,
        ),
        child: AppText(
          text: label,
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: textColor ?? Colors.white,
          alignment: AlignmentDirectional.center,
        ),
      ),
    );
  }
}
