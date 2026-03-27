import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/extensions/dimensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../components/app_text.dart';

class AmountRow extends StatelessWidget {
  final String label;
  final String? amount;
  final Color? backgroundColor;

  const AmountRow({
    super.key,
    required this.label,
    this.amount,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppText(
          text: label,
          fontSize: 12.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.mainBlueIndigoDye,
          textAlign: TextAlign.center,
          alignment: AlignmentDirectional.center,
        ),
        6.hs,
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.transparent,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: AppColors.neutralLightDarkest,
              width: 0.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: AppText(
                      text: amount ?? '00.00',
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.neutralDarkMedium,
                      alignment: AlignmentDirectional.center,
                    ),
                  ),
                  10.ws,
                  Container(
                    width: 0.5.w,
                    height: 25.h,
                    color: AppColors.neutralLightDarkest,
                  ),
                  10.ws,
                  AppText(
                    text: 'ج.م',
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.neutralDarkMedium,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
