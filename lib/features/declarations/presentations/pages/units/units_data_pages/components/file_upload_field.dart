import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reta/core/helpers/url_launcher.dart';

import '../../../../../../../core/helpers/fixed_assets.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../components/app_text_form_field.dart';
import '../../../../../../components/image_svg_custom_widget.dart';
import '../../../../components/app_attachment_item.dart';

class FileUploadField extends StatelessWidget {
  const FileUploadField({
    super.key,
    required this.labelText,
    required this.onFilePicked,
    required this.onFileRemoved,
    this.filePath,
    this.labelRequired = false,
    this.infoText =
        'ملف بصيغة JPG أو PNG أو PDF، على ألا يتجاوز حجمه 5 ميجا بايت.',
    this.text,
    this.backgroundColor,
    this.textColor,
    this.labelFontSize,
    this.description,
    this.isUserInfo = false,
    this.loadingWidget,
    this.deleteFileText,
  });

  final String labelText;
  final bool labelRequired;
  final String? filePath;
  final VoidCallback onFilePicked;
  final VoidCallback onFileRemoved;
  final String infoText;
  final String? text;
  final Color? backgroundColor;
  final Color? textColor;
  final double? labelFontSize;
  final String? description;
  final bool isUserInfo;
  final Widget? loadingWidget;
  final String? deleteFileText;

  @override
  Widget build(BuildContext context) {
    final hasFile = filePath != null && filePath!.isNotEmpty;
    return AppTextFormField(
      labelText: labelText,
      description: description,
      labelRequired: labelRequired,
      labelFontSize: labelFontSize,
      readOnly: true,
      suffixWidget: GestureDetector(
        onTap: () {
          if (filePath != null) {
            urlLauncher(filePath);
          }
        },
        child: ImageSvgCustomWidget(
          imgPath: FixedAssets.instance.attachmentWhiteIC,
          width: 16.w,
          height: 16.h,
          color: hasFile ? AppColors.errorDark : AppColors.neutralDarkLightest,
        ),
      ),
      prefixWidget:
          loadingWidget ??
          AppAttachmentItem(
            onTap: hasFile ? onFileRemoved : onFilePicked,
            text: text,
            backgroundColor: backgroundColor,
            textColor: textColor,
            containFile: hasFile,
            isUserInfo: isUserInfo,
            deleteFileText: deleteFileText,
          ),
      infoText: infoText,
    );
  }
}
