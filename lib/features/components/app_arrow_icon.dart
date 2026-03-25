import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/app_colors.dart';

class AppArrowIcon extends StatelessWidget {
  const AppArrowIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36.w,
      height: 36.w,
      decoration: BoxDecoration(
        color: AppColors.neutralLightMedium,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Icon(
        Icons.arrow_forward_ios_rounded,
        size: 16.sp,
        color: AppColors.neutralDarkLightest,
      ),
    );
  }
}
