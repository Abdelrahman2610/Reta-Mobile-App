import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/extensions/dimensions.dart';
import '../../../../core/helpers/fixed_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../components/app_text_form_field.dart';
import '../../../components/image_svg_custom_widget.dart';
import 'app_attachment_item.dart';

class PassportForm extends StatelessWidget {
  const PassportForm({
    super.key,
    this.fontSize,
    this.textColor,
    this.filledColor,
    required this.enabled,
    this.labelRequired = true,
    this.attachmentIconColor,
    this.controller,
    this.onFilePicked,
    this.filePath,
    required this.displayFile,
  });

  final double? fontSize;
  final Color? textColor;
  final Color? filledColor;
  final bool enabled;
  final bool labelRequired;
  final Color? attachmentIconColor;
  final TextEditingController? controller;
  final VoidCallback? onFilePicked;
  final String? filePath;
  final bool displayFile;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextFormField(
          labelText: 'رقم جواز السفر',
          labelRequired: labelRequired,
          labelColor: textColor ?? AppColors.neutralDarkDark,
          validator: (value) => value == null ? 'هذا الحقل مطلوب' : null,
          labelFontSize: fontSize ?? 14.sp,
          filledColor: filledColor,
          enabled: enabled,
          controller: controller,
        ),
        16.hs,
        AppTextFormField(
          labelText: 'مرفق جواز السفر',
          labelRequired: labelRequired,
          labelFontSize: fontSize ?? 14.sp,
          labelColor: textColor ?? AppColors.neutralDarkDark,
          readOnly: true,
          suffixWidget: ImageSvgCustomWidget(
            imgPath: FixedAssets.instance.attachmentWhiteIC,
            width: 16.w,
            height: 16.h,
            color: displayFile
                ? filePath != null
                      ? AppColors.highlightDarkest
                      : attachmentIconColor
                : attachmentIconColor,
          ),
          prefixWidget: AppAttachmentItem(
            onTap: onFilePicked,
            containFile: displayFile ? filePath != null : false,
          ),
          infoText: 'ملف بصيغة Jpg أو pdf لا يتجاوز حجمه 5 ميجا بايت',
          filledColor: filledColor,
          enabled: enabled,
        ),
      ],
    );
  }
}
