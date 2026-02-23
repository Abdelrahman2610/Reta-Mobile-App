import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reta/core/helpers/extensions/nationality.dart';

import '../../../../core/helpers/app_enum.dart';
import '../../../../core/helpers/extensions/dimensions.dart';
import '../../../../core/helpers/fixed_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../components/app_container.dart';
import '../../../components/app_text.dart';
import '../../../components/app_text_form_field.dart';
import '../../../components/image_svg_custom_widget.dart';
import 'app_attachment_item.dart';
import 'nationality_form.dart';

class SharedOwnershipForm extends StatelessWidget {
  SharedOwnershipForm({super.key});

  Nationality nationality = Nationality.egyptian;

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      child: Column(
        children: [
          AppText(
            text: 'بيانات المكلف بأداء الضريبة',
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.mainBlueIndigoDye,
          ),
          24.hs,
          AppTextFormField(
            labelText: 'إسم المكلف بأداء الضريبة',
            labelRequired: true,
            labelColor: AppColors.neutralDarkDark,
            validator: (value) => value == null ? 'هذا الحقل مطلوب' : null,
            labelFontSize: 14.sp,
            prefixWidget: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.only(start: 16.w),
                  child: AppText(
                    text: 'ورثة/شركاء',
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                    color: AppColors.neutralDarkLightest,
                  ),
                ),
              ],
            ),
          ),
          16.hs,
          NationalityForm(
            nationality: nationality,
            onNationalityChanged: onNationalityChanged,
          ),

          16.hs,
          AppTextFormField(
            labelText: 'رفع سند الملكية على الشيوع/ إعلام الوراثة',
            labelRequired: true,
            labelColor: AppColors.neutralDarkDark,
            labelFontSize: 14.sp,
            suffixWidget: ImageSvgCustomWidget(
              imgPath: FixedAssets.instance.attachmentWhiteIC,
              width: 16.w,
              height: 16.h,
              color: AppColors.neutralDarkLightest,
            ),
            prefixWidget: AppAttachmentItem(onTap: () {}, containFile: true),
            infoText: 'ملف بصيغة Jpg أو pdf لا يتجاوز حجمه 5 ميجا بايت',
          ),
        ],
      ),
    );
  }

  void onNationalityChanged(String? value) {
    nationality = value?.getNationality ?? Nationality.egyptian;
  }
}
