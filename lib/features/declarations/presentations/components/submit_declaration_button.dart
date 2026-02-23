import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/fixed_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../components/app_button.dart';
import '../../../components/image_svg_custom_widget.dart';

class SubmitDeclarationButton extends StatelessWidget {
  final Function onSubmit;

  const SubmitDeclarationButton({super.key, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return AppButton(
      onTap: () {
        onSubmit();
      },
      label: "تقديم الإقرار",
      width: double.maxFinite,
      height: 48.h,
      borderColor: AppColors.highlightDarkest,
      backgroundColor: Colors.white,
      textColor: AppColors.highlightDarkest,
      fontSize: 12,
      fontWeight: FontWeight.w600,
      iconLeft: false,
      icon: ImageSvgCustomWidget(
        color: AppColors.highlightDarkest,
        imgPath: FixedAssets.instance.sendIcon,
        height: 18.h,
        width: 18.w,
      ),
    );
  }
}
