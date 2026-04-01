import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reta/core/helpers/app_enum.dart';

import '../../../../core/helpers/extensions/dimensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../components/app_text_form_field.dart';
import '../pages/units/units_data_pages/components/file_upload_field.dart';

class NationalIDForm extends StatelessWidget {
  const NationalIDForm({
    super.key,
    this.fontSize,
    this.textColor,
    this.filledColor,
    this.enabled = true,
    this.labelRequired = true,
    this.containFile = true,
    this.isUserInfo = false,
    this.attachmentIconColor,
    this.controller,
    required this.onFilePicked,
    this.filePath,
    required this.displayFile,
    required this.onFileRemoved,
    this.userId,
  });

  final double? fontSize;
  final Color? textColor;
  final Color? filledColor;
  final bool enabled;
  final bool labelRequired;
  final bool containFile;
  final Color? attachmentIconColor;
  final TextEditingController? controller;
  final VoidCallback onFilePicked;
  final VoidCallback onFileRemoved;
  final String? filePath;
  final bool displayFile;
  final bool isUserInfo;
  final String? userId;

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
          keyboardType: TextInputType.number,
        ),
        16.hs,
        FileUploadField(
          labelText: 'مرفق الرقم القومي',
          filePath: filePath,
          labelRequired: labelRequired,
          onFilePicked: onFilePicked,
          onFileRemoved: onFileRemoved,
          isUserInfo: isUserInfo,
          userId: userId,
          attachmentType: UserAttachmentTypes.nationalId,
        ),
      ],
    );
  }
}
