import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/extensions/dimensions.dart';
import '../../../../core/helpers/fixed_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../components/app_container.dart';
import '../../../components/app_text.dart';
import '../../../components/image_svg_custom_widget.dart';

class MyPaymentCard extends StatelessWidget {
  const MyPaymentCard({
    super.key,
    this.title,
    this.content,
    this.iconPath,
    this.counter,
    this.onTap,
  });

  final String? title;
  final String? content;
  final String? iconPath;
  final String? counter;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AppContainer(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
        boxShadow: [],
        child: Row(
          children: [
            ImageSvgCustomWidget(
              imgPath: iconPath ?? FixedAssets.instance.settlementIC,
            ),
            15.ws,
            Expanded(
              child: Column(
                children: [
                  AppText(
                    text: title,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                    color: AppColors.neutralDarkDarkest,
                  ),
                  AppText(
                    text: content,
                    fontWeight: FontWeight.w500,
                    fontSize: 12.sp,
                    color: AppColors.neutralDarkLight,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            15.ws,
            if (counter == null)
              Icon(
                Icons.arrow_forward_ios,
                size: 16.sp,
                color: AppColors.neutralDarkLight,
              )
            else
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: AppColors.errorDark,
                  shape: BoxShape.circle,
                ),
                child: AppText(
                  text: counter,
                  color: AppColors.white,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
