import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';

class FilterAppContainer extends StatelessWidget {
  const FilterAppContainer({
    super.key,
    required this.child,
    this.paddingVertical,
  });

  final Widget child;
  final double? paddingVertical;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12.w,
        vertical: paddingVertical ?? 10.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        // color: Colors.red,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: child,
    );
  }
}
