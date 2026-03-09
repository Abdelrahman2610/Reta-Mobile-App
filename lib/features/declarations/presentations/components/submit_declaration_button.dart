import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/fixed_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../components/app_button.dart';
import '../../../components/image_svg_custom_widget.dart';

class SubmitDeclarationButton extends StatelessWidget {
  final VoidCallback onSubmit;
  final String? label;
  final bool withIcon;
  final Color? borderColor;
  final bool isEnabled;

  const SubmitDeclarationButton({
    super.key,
    required this.onSubmit,
    this.label,
    this.withIcon = true,
    this.isEnabled = true,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      onTap: () {
        onSubmit();
      },
      label: label ?? "تقديم الإقرار",
      width: double.maxFinite,
      height: 48.h,
      borderColor: !isEnabled
          ? AppColors.neutralLightDarkest
          : borderColor ?? AppColors.highlightDarkest,
      backgroundColor: !isEnabled
          ? AppColors.neutralLightDarkest
          : Colors.white,
      textColor: !isEnabled
          ? AppColors.neutralDarkLight
          : borderColor ?? AppColors.highlightDarkest,
      fontSize: 12,
      fontWeight: FontWeight.w600,
      iconLeft: false,
      icon: withIcon
          ? ImageSvgCustomWidget(
              color: !isEnabled
                  ? AppColors.neutralDarkLight
                  : AppColors.highlightDarkest,
              imgPath: FixedAssets.instance.sendIcon,
              height: 18.h,
              width: 18.w,
            )
          : SizedBox.shrink(),
    );
  }
}
