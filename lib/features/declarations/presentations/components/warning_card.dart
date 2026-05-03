import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/extensions/dimensions.dart';
import '../../../../core/helpers/fixed_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../components/app_text.dart';
import '../../../components/image_svg_custom_widget.dart';

class WarningCard extends StatelessWidget {
  const WarningCard({super.key, this.label});

  final String? label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.warningLight,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          ImageSvgCustomWidget(imgPath: FixedAssets.instance.warningInfoIC),
          16.ws,
          Expanded(
            child: AppText(
              text:
                  label ??
                  'إذا كان العقار تابعًا لهيئة المجتمعات العمرانية، يرجى تحديد ذلك قبل فتح الخريطة.',
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.neutralDarkDarkest,
              maxLines: 3,
            ),
          ),
        ],
      ),
    );
  }
}
