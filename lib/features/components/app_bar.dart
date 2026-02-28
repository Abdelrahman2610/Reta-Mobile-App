import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/app_colors.dart';
import 'app_button.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? backButtonAction;
  final String title;
  final Color backgroundColor;
  final Color? backButtonIconColor;
  final TextStyle titleTextStyle;
  final bool? isTitleCenter;
  final List<Widget>? actions;
  final VoidCallback? onCancel;
  final VoidCallback? onSave;

  const MainAppBar({
    super.key,
    this.backButtonAction,
    this.actions,
    this.isTitleCenter = true,
    required this.title,
    required this.backgroundColor,
    this.backButtonIconColor,
    required this.titleTextStyle,
    this.onCancel,
    this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    if (onCancel != null || onSave != null) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          height: 104.h,
          decoration: BoxDecoration(color: backgroundColor),
          padding: EdgeInsetsDirectional.only(bottom: 15.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.only(start: 10.0),
                child: AppButton(
                  width: 100.w,
                  label: 'حفظ',
                  backgroundColor: onSave == null
                      ? AppColors.neutralLightDarkest
                      : AppColors.highlightDarkest,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  textColor: onSave == null
                      ? AppColors.neutralDarkLight
                      : AppColors.white,
                  onTap: onSave,
                ),
              ),
              Text(title, style: titleTextStyle),
              Padding(
                padding: EdgeInsetsDirectional.only(end: 10.0),
                child: AppButton(
                  width: 100.w,
                  label: 'لاغي',
                  borderColor: AppColors.highlightDarkest,
                  textColor: AppColors.highlightDarkest,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  onTap: onCancel,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AppBar(
        backgroundColor: backgroundColor,
        centerTitle: isTitleCenter,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: backButtonIconColor),
          onPressed: backButtonAction ?? () => Navigator.maybePop(context),
        ),
        title: Text(title, style: titleTextStyle),
        actions: actions,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
