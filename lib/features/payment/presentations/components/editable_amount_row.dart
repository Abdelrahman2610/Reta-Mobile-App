import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reta/features/components/app_text_form_field.dart';

import '../../../../core/helpers/extensions/dimensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../components/app_text.dart';

class EditableAmountField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String label;
  final Color? backgroundColor;

  const EditableAmountField({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.label,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        AppText(
          text: label,
          fontSize: 12.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.mainBlueIndigoDye,
          textAlign: TextAlign.center,
          alignment: AlignmentDirectional.center,
        ),
        6.hs,
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: AppColors.neutralLightDarkest,
              width: 0.5,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: AppTextFormField(
                  controller: controller,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  onChanged: onChanged,
                  labelText: '',
                  hideLabel: true,
                  hideBorder: true,
                  textAlign: TextAlign.center,
                ),
              ),
              10.ws,
              Container(
                width: 0.5.w,
                height: 25.h,
                color: AppColors.neutralLightDarkest,
              ),
              10.ws,
              AppText(
                text: 'ج.م',
                fontSize: 11.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.neutralDarkMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
