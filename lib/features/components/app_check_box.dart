import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/app_colors.dart';

class AppCheckBox extends StatelessWidget {
  const AppCheckBox({super.key, required this.isSelected, this.onTap});

  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 32.w,
        height: 32.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.neutralLightDarkest),
        ),
        child: isSelected
            ? Icon(Icons.check, color: AppColors.color1, size: 20.sp)
            : SizedBox.shrink(),
      ),
    );
  }
}
