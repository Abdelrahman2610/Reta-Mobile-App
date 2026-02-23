import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/fixed_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../components/app_button.dart';
import '../../../components/image_svg_custom_widget.dart';

class CancelDeclarationButton extends StatelessWidget {
  final Function onCancel;

  const CancelDeclarationButton({super.key, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return AppButton(
      onTap: () {
        onCancel();
      },
      label: "إلغاء الإقرار",
      width: double.maxFinite,
      height: 48.h,
      borderColor: AppColors.errorDark,
      backgroundColor: Colors.white,
      textColor: AppColors.errorDark,
      fontSize: 12,
      fontWeight: FontWeight.w600,
      iconLeft: false,
      icon: ImageSvgCustomWidget(
        color: AppColors.errorDark,
        imgPath: FixedAssets.instance.closeIcon,
        height: 18.h,
        width: 18.w,
      ),
    );
  }
}
