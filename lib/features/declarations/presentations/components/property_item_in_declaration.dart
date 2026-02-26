import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/fixed_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../components/app_button.dart';
import '../../../components/app_text.dart';
import '../../../components/image_svg_custom_widget.dart';
import '../../../components/title_with_value_text.dart';

class PropertyItemInDeclaration extends StatelessWidget {
  const PropertyItemInDeclaration({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  text: "وحدة سكنية",
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.mainBlueIndigoDye,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.highlightLightest,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    child: AppText(
                      text: "شقة",
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.mainBlueIndigoDye,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                Expanded(child: TitleWithValueText("المحافظة", "القاهرة")),
                SizedBox(width: 10.w),
                Expanded(
                  child: TitleWithValueText("المنطقة / الحي", "حدائق القبة"),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                Expanded(
                  child: TitleWithValueText("الشارع", "شارع مصر والسودان"),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                Expanded(child: TitleWithValueText("رقم العقار", "147")),
                SizedBox(width: 10.w),
                Expanded(child: TitleWithValueText("رقم الدور", "5")),
                SizedBox(width: 10.w),
                Expanded(child: TitleWithValueText("رقم الوحدة", "5")),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    onTap: () {},
                    label: "تعديل",
                    width: double.maxFinite,
                    height: 44.h,
                    borderColor: Colors.transparent,
                    backgroundColor: AppColors.highlightDarkest,
                    textColor: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 15.w),
                ImageSvgCustomWidget(
                  imgPath: FixedAssets.instance.deleteIcon,
                  height: 44.h,
                  width: 44.w,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
