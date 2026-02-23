import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';

class EmptyDataWidget extends StatelessWidget {
  final String title;

  const EmptyDataWidget({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: DottedBorder(
          options: RoundedRectDottedBorderOptions(
            color: AppColors.neutralLightDarkest,
            strokeCap: StrokeCap.round,
            dashPattern: const [10, 8],
            radius: Radius.circular(10),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.neutralLightLight,
            ),
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  color: AppColors.neutralDarkLightest,
                  fontWeight: FontWeight.w700,
                  fontSize: 16.sp,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
