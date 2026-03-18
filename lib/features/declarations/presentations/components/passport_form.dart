import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/extensions/dimensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../components/app_text_form_field.dart';
import '../pages/units/units_data_pages/components/file_upload_field.dart';

class PassportForm extends StatelessWidget {
  const PassportForm({
    super.key,
    this.fontSize,
    this.textColor,
    this.filledColor,
    required this.enabled,
    this.labelRequired = true,
    this.isUserInfo = false,
    this.attachmentIconColor,
    this.controller,
    required this.onFilePicked,
    this.filePath,
    required this.displayFile,
    required this.onFileRemoved,
  });

  final double? fontSize;
  final Color? textColor;
  final Color? filledColor;
  final bool enabled;
  final bool labelRequired;
  final Color? attachmentIconColor;
  final TextEditingController? controller;
  final VoidCallback onFilePicked;
  final VoidCallback onFileRemoved;
  final String? filePath;
  final bool displayFile;
  final bool isUserInfo;

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
          keyboardType: TextInputType.text,
        ),
        16.hs,
        FileUploadField(
          labelText: 'مرفق جواز السفر',
          filePath: filePath,
          labelRequired: labelRequired,
          onFilePicked: onFilePicked,
          onFileRemoved: onFileRemoved,
          isUserInfo: isUserInfo,
        ),
      ],
    );
  }
}
