import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/app_box_shadow.dart';
import '../../core/theme/app_colors.dart';

class AppContainer extends StatelessWidget {
  const AppContainer({
    super.key,
    this.height,
    this.padding,
    required this.child,
    this.boxShadow,
    this.borderRadius,
  });

  final double? height;
  final EdgeInsets? padding;
  final Widget child;
  final List<BoxShadow>? boxShadow;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      padding: padding ?? EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      alignment: AlignmentDirectional.center,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(borderRadius ?? 10.r),
        boxShadow: boxShadow ?? AppBoxShadow.instance.cardShadow,
      ),
      child: child,
    );
  }
}
