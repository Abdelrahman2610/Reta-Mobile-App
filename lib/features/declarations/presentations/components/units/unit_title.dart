import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../components/app_text.dart';

class UnitTitle extends StatelessWidget {
  const UnitTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65.h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: AppColors.mainBlueIndigoDye,
      ),
      child: AppText(
        text: title,
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.white,
        alignment: Alignment.center,
      ),
    );
  }
}
