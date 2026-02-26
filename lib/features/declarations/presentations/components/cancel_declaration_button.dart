import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/fixed_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../components/app_button.dart';
import '../../../components/image_svg_custom_widget.dart';

class CancelDeclarationButton extends StatelessWidget {
  final VoidCallback onCancel;
  final String? label;
  final bool withIcon;
  final Color? borderColor;

  const CancelDeclarationButton({
    super.key,
    required this.onCancel,
    this.label,
    this.withIcon = true,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      onTap: () {
        onCancel();
      },
      label: label ?? "إلغاء الإقرار",
      width: double.maxFinite,
      height: 48.h,
      borderColor: borderColor ?? AppColors.errorDark,
      backgroundColor: Colors.white,
      textColor: borderColor ?? AppColors.errorDark,
      fontSize: 12,
      fontWeight: FontWeight.w600,
      iconLeft: false,
      icon: withIcon
          ? ImageSvgCustomWidget(
              color: AppColors.errorDark,
              imgPath: FixedAssets.instance.closeIcon,
              height: 18.h,
              width: 18.w,
            )
          : SizedBox.shrink(),
    );
  }
}
