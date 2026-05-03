import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../components/app_text.dart';

class BuildingsTitle extends StatelessWidget {
  const BuildingsTitle({super.key, this.title});

  final String? title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 25.h),
      decoration: BoxDecoration(
        color: AppColors.highlightLight,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: AppText(
        text: title ?? 'وصف المباني',
        fontWeight: FontWeight.w600,
        fontSize: 16.sp,
        color: AppColors.neutralDarkDarkest,
        alignment: Alignment.center,
      ),
    );
  }
}
