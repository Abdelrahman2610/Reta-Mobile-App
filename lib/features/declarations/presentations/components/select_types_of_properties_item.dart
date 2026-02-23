import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reta/features/components/image_svg_custom_widget.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../components/app_text.dart';

class SelectTypesOfPropertiesItem extends StatelessWidget {
  final String title;
  final String subTitle;
  final String icon;

  const SelectTypesOfPropertiesItem({
    super.key,
    required this.title,
    required this.subTitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.neutralLightLight,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Row(
          children: [
            ImageSvgCustomWidget(imgPath: icon, height: 30.h, width: 20.w),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                children: [
                  AppText(
                    text: title,
                    color: AppColors.neutralDarkDarkest,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(height: 4.h),
                  AppText(
                    text: subTitle,
                    maxLines: 4,
                    color: AppColors.neutralDarkLight,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ],
              ),
            ),
            SizedBox(width: 5.w),
            Icon(
              Icons.arrow_forward_ios_sharp,
              color: AppColors.neutralDarkLightest,
              size: 15,
            ),
          ],
        ),
      ),
    );
  }
}
