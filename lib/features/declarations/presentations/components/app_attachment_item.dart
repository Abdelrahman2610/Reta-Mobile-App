import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/extensions/dimensions.dart';
import '../../../../core/helpers/fixed_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../components/app_text.dart';
import '../../../components/image_svg_custom_widget.dart';

class AppAttachmentItem extends StatelessWidget {
  const AppAttachmentItem({super.key, this.onTap, this.containFile = false});

  final VoidCallback? onTap;
  final bool containFile;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 152.w,
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: containFile
              ? AppColors.errorDark
              : AppColors.neutralLightDarkest,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppText(
              text: containFile ? 'حذف الصورة' : 'JPG',
              fontWeight: FontWeight.w600,
              fontSize: 12.sp,
              color: containFile
                  ? AppColors.white
                  : AppColors.neutralDarkLightest,
            ),
            8.ws,
            ImageSvgCustomWidget(
              imgPath: containFile
                  ? FixedAssets.instance.attachmentWhiteIC
                  : FixedAssets.instance.attachmentIC,
              width: 12.w,
              height: 12.h,
              color: containFile ? AppColors.white : null,
            ),
          ],
        ),
      ),
    );
  }
}
