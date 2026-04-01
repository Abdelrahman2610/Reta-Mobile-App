import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';

class PaymentSelectedBox extends StatelessWidget {
  const PaymentSelectedBox({super.key, required this.isSelected, this.onTap});

  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 22.w,
        height: 22.w,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.highlightDarkest : Colors.white,
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(
            color: isSelected
                ? AppColors.highlightDarkest
                : AppColors.mainNeutral,
          ),
        ),
        child: isSelected
            ? Icon(Icons.check, color: Colors.white, size: 14.sp)
            : null,
      ),
    );
  }
}
