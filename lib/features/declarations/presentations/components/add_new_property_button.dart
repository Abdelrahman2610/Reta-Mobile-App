import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/fixed_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../components/app_button.dart';
import '../../../components/image_svg_custom_widget.dart';

class AddNewPropertyButton extends StatelessWidget {
  final VoidCallback onAdd;
  final String? label;
  final EdgeInsets? padding;

  const AddNewPropertyButton({
    super.key,
    required this.onAdd,
    this.label,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 20.w),
      child: AppButton(
        onTap: onAdd,
        label: label ?? "إضافة عقار جديد",
        width: double.maxFinite,
        height: 48.h,
        borderColor: Colors.transparent,
        backgroundColor: AppColors.mainOrange,
        textColor: Colors.white,
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
        iconLeft: false,
        icon: ImageSvgCustomWidget(
          color: Colors.white,
          imgPath: FixedAssets.instance.addIcon,
          height: 18.h,
          width: 18.w,
        ),
      ),
    );
  }
}
