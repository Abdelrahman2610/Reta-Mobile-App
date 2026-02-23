import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/app_colors.dart';

class DropDownIcon extends StatelessWidget {
  const DropDownIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 10.h),
      margin: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.neutralLightMedium,
        borderRadius: BorderRadius.circular(7.r),
      ),
      child: Icon(Icons.keyboard_arrow_down_outlined),
    );
  }
}
