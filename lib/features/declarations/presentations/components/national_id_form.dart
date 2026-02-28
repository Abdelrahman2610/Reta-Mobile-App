import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/extensions/dimensions.dart';
import '../../../../core/helpers/fixed_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../components/app_text_form_field.dart';
import '../../../components/image_svg_custom_widget.dart';
import 'app_attachment_item.dart';

class NationalIDForm extends StatelessWidget {
  const NationalIDForm({
    super.key,
    this.fontSize,
    this.textColor,
    this.filledColor,
    this.enabled = true,
    this.labelRequired = true,
    this.containFile = true,
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
  final bool containFile;
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
          labelText: 'الرقم القومي',
          labelRequired: labelRequired,
          labelColor: textColor ?? AppColors.neutralDarkDark,
          validator: (v) {
            if (v == null || v.isEmpty) return 'هذا الحقل مطلوب';
            if (v.length != 14) return 'الرقم القومي يجب أن يكون 14 رقماً';
            return null;
          },
          labelFontSize: fontSize ?? 14.sp,
          enabled: enabled,
          filledColor: filledColor,
          controller: controller,
        ),
        16.hs,
        AppTextFormField(
          labelText: 'مرفق الرقم القومي',
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
          enabled: enabled,
          filledColor: filledColor,
        ),
      ],
    );
  }
}
