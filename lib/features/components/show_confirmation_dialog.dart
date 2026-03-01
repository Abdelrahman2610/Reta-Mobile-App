// Helper function to show dialog (barrierDismissible: false = can't tap outside)
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/app_colors.dart';
import 'app_button.dart';
import 'app_text.dart';

// Reusable confirmation dialog
class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final Widget? icon;
  final Color? confirmBackgroundColors;
  final Color? confirmTextColors;
  final Color? cancelBackgroundColors;
  final Color? cancelTextColors;
  final Color? confirmBorderColor;
  final Color? cancelBorderColors;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    required this.confirmText,
    this.cancelText = 'لاغي',
    required this.onConfirm,
    required this.onCancel,
    this.icon,
    this.confirmBackgroundColors,
    this.confirmTextColors,
    this.confirmBorderColor,
    this.cancelBackgroundColors,
    this.cancelTextColors,
    this.cancelBorderColors,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Prevent back button from closing
      canPop: false,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[icon!, SizedBox(height: 20.h)],
                AppText(
                  alignment: Alignment.center,
                  text: title,
                  textAlign: TextAlign.center,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.neutralDarkDarkest,
                ),
                SizedBox(height: 8.h),
                AppText(
                  alignment: Alignment.center,
                  text: message,
                  textAlign: TextAlign.center,
                  fontSize: 12.sp,
                  maxLines: 6,
                  color: AppColors.neutralDarkLight,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(height: 28.h),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        label: confirmText,
                        backgroundColor:
                            confirmBackgroundColors ?? AppColors.errorDark,
                        textColor: confirmTextColors ?? Colors.white,
                        borderColor: confirmBorderColor,
                        fontSize: 12.sp,
                        height: 40.h,
                        fontWeight: FontWeight.w600,
                        onTap: () {
                          onConfirm();
                        },
                      ),
                    ),
                    SizedBox(width: 8.w),
                    // Cancel button
                    Expanded(
                      child: AppButton(
                        label: cancelText,
                        backgroundColor: cancelBackgroundColors ?? Colors.white,
                        borderColor:
                            cancelBorderColors ?? AppColors.highlightDarkest,
                        textColor:
                            confirmTextColors ?? AppColors.highlightDarkest,
                        fontSize: 12.sp,
                        height: 40.h,
                        fontWeight: FontWeight.w600,
                        onTap: () {
                          onCancel();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<bool?> showConfirmationDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmText,
  String cancelText = 'لاغي',
  Widget? icon,
  Color? confirmBackgroundColors,
  Color? confirmTextColors,
  Color? cancelBackgroundColors,
  Color? cancelTextColors,
  Color? confirmBorderColor,
  Color? cancelBorderColors,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false, // Can't close by tapping outside
    builder: (_) => ConfirmationDialog(
      title: title,
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
      icon: icon,
      onConfirm: () => Navigator.of(context).pop(true),
      onCancel: () => Navigator.of(context).pop(false),
      cancelBackgroundColors: cancelBackgroundColors,
      confirmBackgroundColors: confirmBackgroundColors,
      confirmTextColors: confirmTextColors,
      cancelTextColors: cancelTextColors,
      confirmBorderColor: confirmBorderColor,
      cancelBorderColors: cancelBorderColors,
    ),
  );
}
