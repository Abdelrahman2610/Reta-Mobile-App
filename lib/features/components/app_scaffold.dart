import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/app_colors.dart';
import 'app_bar.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    this.title,
    this.onBackTapped,
    this.onSave,
    required this.child,
    this.padding,
  });

  final String? title;
  final VoidCallback? onBackTapped;
  final VoidCallback? onSave;
  final Widget child;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.neutralLightLight,
        appBar: MainAppBar(
          backButtonAction: onBackTapped ?? () => Navigator.pop(context),
          title: title ?? '',
          backgroundColor: AppColors.mainBlueIndigoDye,
          backButtonIconColor: Colors.white,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 16.sp),
          onSave: onSave,
        ),
        body: Padding(
          padding:
              padding ?? EdgeInsets.symmetric(horizontal: 25.w, vertical: 25.h),
          child: child,
        ),
      ),
    );
  }
}
