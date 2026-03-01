import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reta/features/components/inkwell_transparent.dart';

import '../../../../core/helpers/fixed_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../components/app_button.dart';
import '../../../components/app_text.dart';
import '../../../components/image_svg_custom_widget.dart';
import '../../../components/title_with_value_text.dart';

class PropertyItemInDeclaration extends StatelessWidget {
  final String propertyTypeText;
  final String governorateText;
  final String districtText;
  final String regionText;
  final String realEstateFloorText;
  final String realEstateCode;
  final String unitUnitNum;
  final String unitTypeText;
  final bool canEditOrRemove;
  final Function() onDelete;
  final Function() onEdit;

  const PropertyItemInDeclaration({
    super.key,
    required this.propertyTypeText,
    required this.governorateText,
    required this.districtText,
    required this.regionText,
    required this.realEstateFloorText,
    required this.realEstateCode,
    required this.unitUnitNum,
    required this.unitTypeText,
    required this.canEditOrRemove,
    required this.onDelete,
    required this.onEdit,
  });

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
                  text: propertyTypeText,
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
                      text: unitTypeText,
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
                Expanded(
                  child: TitleWithValueText("المحافظة", governorateText),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: TitleWithValueText("المنطقة / الحي", districtText),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                Expanded(child: TitleWithValueText("الشارع", regionText)),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                Expanded(
                  child: TitleWithValueText("رقم العقار", realEstateCode),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: TitleWithValueText("رقم الدور", realEstateFloorText),
                ),
                SizedBox(width: 10.w),
                Expanded(child: TitleWithValueText("رقم الوحدة", unitUnitNum)),
              ],
            ),
            if (canEditOrRemove) SizedBox(height: 12.h),
            if (canEditOrRemove)
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
                  InkwellTransparent(
                    onTap: () {
                      onDelete();
                    },
                    child: ImageSvgCustomWidget(
                      imgPath: FixedAssets.instance.deleteIcon,
                      height: 44.h,
                      width: 44.w,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
