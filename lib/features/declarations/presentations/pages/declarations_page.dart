import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reta/core/helpers/fixed_assets.dart';
import 'package:reta/features/components/app_text.dart';
import 'package:reta/features/components/image_svg_custom_widget.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../components/app_bar.dart';
import '../../../components/app_button.dart';

class DeclarationsPage extends StatelessWidget {
  const DeclarationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralLightMedium,
      appBar: MainAppBar(
        backButtonAction: () {},
        title: "إقراراتي",
        backgroundColor: AppColors.mainBlueIndigoDye,
        backButtonIconColor: Colors.white,
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 16.sp),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: 31.h),
            Row(
              textDirection: TextDirection.rtl,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  text: 'إدارة الإقرارات المضافة إلى حسابي',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.mainBlueIndigoDye,
                ),
                AppButton(
                  label: "إضافة إقرار",
                  width: 109.w,
                  height: 46.h,
                  borderColor: Colors.transparent,
                  backgroundColor: AppColors.mainOrange,
                  textColor: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  icon: ImageSvgCustomWidget(
                    color: Colors.white,
                    imgPath: FixedAssets.instance.addIcon,
                    height: 18.h,
                    width: 18.w,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 24.h,
                  ),
                  child: DottedBorder(
                    options: RoundedRectDottedBorderOptions(
                      color: AppColors.neutralLightDarkest,
                      strokeCap: StrokeCap.round,
                      dashPattern: const [3, 3],
                      radius: Radius.circular(10),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.neutralLightLight,
                      ),
                      child: Center(
                        child: Text(
                          "لم يتم إضافة أي إقرار بعد",
                          style: TextStyle(
                            color: AppColors.neutralDarkLightest,
                            fontWeight: FontWeight.w700,
                            fontSize: 16.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 38.h),
          ],
        ),
      ),
    );
  }
}
