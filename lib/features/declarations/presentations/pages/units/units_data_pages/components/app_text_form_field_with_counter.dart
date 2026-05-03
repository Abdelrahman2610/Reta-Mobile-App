import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../core/helpers/extensions/dimensions.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../components/app_text.dart';

class AppTextFormFieldWithCounter extends StatelessWidget {
  const AppTextFormFieldWithCounter({
    super.key,
    required this.controller,
    this.onChanged,
    this.onIncrementTapped,
    this.onDecrementTapped,
    this.title,
    this.labelRequired = true,
  });

  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onIncrementTapped;
  final VoidCallback? onDecrementTapped;
  final String? title;
  final bool labelRequired;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText(
              text: title ?? 'عدد الأدوار',
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.neutralDarkDark,
            ),
            if (labelRequired)
              AppText(
                text: ' *',
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.errorDark,
              ),
          ],
        ),
        8.hs,
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 11.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.highlightDarkest, width: 1.5),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.neutralDarkDarkest,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                  onChanged: onChanged,
                ),
              ),
              SizedBox(width: 8.w),
              GestureDetector(
                onTap: onIncrementTapped,
                child: Container(
                  width: 32.w,
                  height: 32.w,
                  decoration: BoxDecoration(
                    color: AppColors.highlightLightest,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.add,
                    size: 18.sp,
                    color: AppColors.highlightDarkest,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              GestureDetector(
                onTap: onDecrementTapped,
                child: Container(
                  width: 32.w,
                  height: 32.w,
                  decoration: BoxDecoration(
                    color: AppColors.decrementBG,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.remove,
                    size: 18.sp,
                    color: AppColors.neutralLightDarkest,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
