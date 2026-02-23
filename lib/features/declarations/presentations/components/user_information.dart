import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/extensions/dimensions.dart';
import '../../../../core/helpers/fixed_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../components/app_container.dart';
import '../../../components/app_text.dart';
import '../../../components/app_text_form_field.dart';
import '../../../components/drop_down_icon.dart';
import '../../../components/image_svg_custom_widget.dart';
import 'app_attachment_item.dart';

class UserInformation extends StatelessWidget {
  const UserInformation({super.key});

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      child: Column(
        children: [
          AppText(
            text: 'بيانات مقدم الطلب',
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.mainBlueIndigoDye,
          ),
          24.hs,
          AppTextFormField(
            labelText: 'الإسم الأول',
            enabled: false,
            filledColor: AppColors.neutralLightLight,
          ),
          16.hs,
          AppTextFormField(
            labelText: 'باقي الإسم',
            enabled: false,
            filledColor: AppColors.neutralLightLight,
          ),
          16.hs,
          AppTextFormField(
            labelText: 'البريد الإلكتروني',
            enabled: false,
            filledColor: AppColors.neutralLightLight,
          ),
          16.hs,
          AppTextFormField(
            labelText: 'رقم الهاتف المحمول',
            enabled: false,
            filledColor: AppColors.neutralLightLight,
          ),
          16.hs,
          AppTextFormField(
            labelText: 'الجنسية',
            enabled: false,
            filledColor: AppColors.neutralLightLight,
            suffixWidget: DropDownIcon(),
          ),
          16.hs,
          AppTextFormField(
            labelText: 'الرقم القومي',
            enabled: false,
            filledColor: AppColors.neutralLightLight,
          ),
          16.hs,
          AppTextFormField(
            labelText: 'مرفق الرقم القومي',
            enabled: false,
            filledColor: AppColors.neutralLightLight,
            suffixWidget: ImageSvgCustomWidget(
              imgPath: FixedAssets.instance.attachmentIC,
              width: 16.w,
              height: 16.h,
            ),
            prefixWidget: AppAttachmentItem(),
            infoText: 'ملف بصيغة Jpg أو pdf لا يتجاوز حجمه 5 ميجا بايت',
          ),
          16.hs,
        ],
      ),
    );
  }
}
