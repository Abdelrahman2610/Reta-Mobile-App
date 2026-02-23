import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/extensions/dimensions.dart';
import '../../../../core/helpers/fixed_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../components/app_text_form_field.dart';
import '../../../components/image_svg_custom_widget.dart';
import 'app_attachment_item.dart';

class PassportForm extends StatelessWidget {
  const PassportForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextFormField(
          labelText: 'رقم جواز السفر',
          labelRequired: true,
          labelColor: AppColors.neutralDarkDark,
          validator: (value) => value == null ? 'هذا الحقل مطلوب' : null,
          labelFontSize: 14.sp,
        ),
        16.hs,
        AppTextFormField(
          labelText: 'مرفق جواز السفر',
          labelRequired: true,
          labelFontSize: 14.sp,
          labelColor: AppColors.neutralDarkDark,
          readOnly: true,
          suffixWidget: ImageSvgCustomWidget(
            imgPath: FixedAssets.instance.attachmentWhiteIC,
            width: 16.w,
            height: 16.h,
            color: AppColors.highlightDarkest,
          ),
          prefixWidget: AppAttachmentItem(onTap: () {}, containFile: true),
          infoText: 'ملف بصيغة Jpg أو pdf لا يتجاوز حجمه 5 ميجا بايت',
        ),
      ],
    );
  }
}
