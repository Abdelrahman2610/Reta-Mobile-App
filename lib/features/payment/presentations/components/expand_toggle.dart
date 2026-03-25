import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';

class ExpandToggle extends StatelessWidget {
  const ExpandToggle({
    super.key,
    required this.onTap,
    required this.isExpanded,
  });

  final VoidCallback onTap;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 37.w,
        height: 37.w,
        decoration: BoxDecoration(
          color: AppColors.neutralLightMedium,
          borderRadius: BorderRadius.circular(7.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: AnimatedRotation(
          turns: isExpanded ? -0.25 : 0,
          duration: const Duration(milliseconds: 250),
          child: Icon(
            Icons.arrow_forward_ios_rounded,
            size: 15.sp,
            color: AppColors.neutralDarkLightest,
          ),
        ),
      ),
    );
  }
}
