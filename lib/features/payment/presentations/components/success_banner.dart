import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/extensions/dimensions.dart';
import '../../../../core/helpers/fixed_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../components/app_text.dart';
import '../../../components/image_svg_custom_widget.dart';

class SuccessBanner extends StatelessWidget {
  const SuccessBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.successLight,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          ImageSvgCustomWidget(imgPath: FixedAssets.instance.successIC),
          16.ws,
          AppText(
            text: 'تم تقديم الإقرار بنجاح',
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.neutralDarkDarkest,
          ),
        ],
      ),
    );
  }
}
