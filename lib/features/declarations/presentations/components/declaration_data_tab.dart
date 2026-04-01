import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/app_enum.dart';
import '../../../../core/helpers/extensions/provider_data_type.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../components/app_text.dart';

class DeclarationDataTab extends StatelessWidget {
  const DeclarationDataTab({
    super.key,
    this.onTap,
    required this.declarationsType,
    required this.isSelected,
    required this.isFinished,
  });

  final VoidCallback? onTap;
  final DeclarationsDataType declarationsType;
  final bool isSelected;
  final bool isFinished;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          color: isFinished
              ? AppColors.highlightLightest
              : isSelected
              ? AppColors.transparent
              : AppColors.neutralLightLight,
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 24.w,
                height: 24.h,
                decoration: BoxDecoration(
                  color: isFinished
                      ? AppColors.highlightLight
                      : isSelected
                      ? AppColors.highlightDarkest
                      : AppColors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected || isFinished
                        ? AppColors.transparent
                        : AppColors.neutralLightDarkest,
                    width: 0.5,
                  ),
                ),
                child: isFinished
                    ? Icon(
                        Icons.check,
                        color: AppColors.highlightDarkest,
                        size: 15.w,
                      )
                    : AppText(
                        text: declarationsType.displayIndex,
                        fontWeight: FontWeight.w600,
                        fontSize: 10.sp,
                        color: isSelected
                            ? AppColors.white
                            : AppColors.neutralDarkLightest,
                        alignment: AlignmentDirectional.center,
                      ),
              ),
              AppText(
                text: declarationsType.displayText,
                fontWeight: FontWeight.w700,
                fontSize: 12.sp,
                color: isSelected
                    ? AppColors.neutralDarkDarkest
                    : AppColors.neutralDarkLightest,
                alignment: AlignmentDirectional.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
