import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../components/app_text.dart';

class AppCounter extends StatelessWidget {
  const AppCounter({
    super.key,
    required this.count,
    required this.onDecrement,
    required this.onIncrement,
  });

  final int count;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onIncrement,
          child: Container(
            width: 24.w,
            height: 24.w,
            decoration: BoxDecoration(
              color: AppColors.highlightLightest,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.add,
              size: 16.sp,
              color: AppColors.highlightDarkest,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: AppText(
            text: '$count',
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.neutralDarkDark,
          ),
        ),
        GestureDetector(
          onTap: onDecrement,
          child: Container(
            width: 24.w,
            height: 24.w,
            decoration: BoxDecoration(
              color: AppColors.decrementBG,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.remove,
              size: 16.sp,
              color: AppColors.neutralLightDarkest,
            ),
          ),
        ),
      ],
    );
  }
}
