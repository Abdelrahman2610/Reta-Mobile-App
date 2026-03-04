import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class ComingSoonBottomSheet extends StatelessWidget {
  const ComingSoonBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const ComingSoonBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56.w,
              height: 56.w,
              decoration: const BoxDecoration(
                color: AppColors.highlightDarkest,
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                'assets/images/info_icon.svg',
                width: 28.sp,
                height: 28.sp,
              ),
            ),

            SizedBox(height: 24.h),

            Text(
              'قريباً',
              textDirection: TextDirection.rtl,
              style: AppTextStyles.h3.copyWith(
                color: AppColors.neutralDarkDarkest,
              ),
            ),

            SizedBox(height: 12.h),

            Text(
              'يمكنك حالياً تقديم الإقرار فقط.\nخدمات الدفع وإصدار طلبات السداد قيد الإطلاق، وسيتم تفعيلها في مرحلة لاحقة.',
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyS.copyWith(
                color: AppColors.neutralDarkLight,
              ),
            ),

            SizedBox(height: 32.h),

            SizedBox(
              width: double.infinity,
              height: 52.h,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.highlightDarkest,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                child: Text(
                  'حسناً',
                  style: AppTextStyles.actionM.copyWith(
                    color: AppColors.neutralLightLightest,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
