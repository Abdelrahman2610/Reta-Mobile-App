import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/extensions/dimensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../components/payment_text_form_field.dart';

class MultiPaymentBox extends StatelessWidget {
  const MultiPaymentBox({
    super.key,
    required this.firstTitle,
    required this.firstValue,
    required this.secondTitle,
    required this.secondValue,
  });

  final String firstTitle;
  final String? firstValue;
  final String secondTitle;
  final String? secondValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: AppColors.neutralLightDark),
      ),
      child: Row(
        children: [
          Expanded(
            child: PaymentInfoBox(
              label: firstTitle,
              value: firstValue,
              crossAxisAlignment: CrossAxisAlignment.start,
              alignment: AlignmentDirectional.centerStart,
              padding: EdgeInsets.zero,
              borderColor: AppColors.transparent,
            ),
          ),
          8.ws,
          Expanded(
            child: PaymentInfoBox(
              label: secondTitle,
              value: secondValue,
              suffix: '  ج.م',
              valueFontSize: 16.sp,
              crossAxisAlignment: CrossAxisAlignment.start,
              alignment: AlignmentDirectional.centerStart,
              padding: EdgeInsets.zero,
              borderColor: AppColors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}
