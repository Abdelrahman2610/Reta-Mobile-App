import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/extensions/dimensions.dart';
import '../../../../core/helpers/fixed_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../components/app_text.dart';
import '../../../components/image_svg_custom_widget.dart';

class PaymentFilterChip extends StatelessWidget {
  const PaymentFilterChip({
    super.key,
    required this.count,
    required this.onTap,
  });
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: AppColors.highlightLightest,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.highlightDarkest),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ImageSvgCustomWidget(
              imgPath: FixedAssets.instance.filterIC,
              width: 12.w,
              height: 12.h,
            ),
            6.ws,
            AppText(
              text: 'تصفية',
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.neutralDarkDarkest,
            ),
            6.ws,
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                color: AppColors.highlightDarkest,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: AppText(
                text: count.toString(),
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
                alignment: AlignmentDirectional.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
