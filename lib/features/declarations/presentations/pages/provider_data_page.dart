import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reta/core/theme/app_colors.dart';
import 'package:reta/features/components/app_bar.dart';
import 'package:reta/features/components/app_container.dart';
import 'package:reta/features/components/app_text.dart';
import 'package:reta/features/components/app_text_form_field.dart';

import '../../../../core/helpers/extensions/dimensions.dart';
import '../../../components/drop_down_icon.dart';

class ProviderDataPage extends StatelessWidget {
  const ProviderDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          RetaAppBar(title: 'بيانات الإقرار'),
          15.hs,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                AppContainer(
                  height: 93,
                  child: AppText(
                    text: 'بيانات المقدم',
                    fontWeight: FontWeight.w700,
                    fontSize: 12.sp,
                    color: AppColors.neutralDarkDarkest,
                    alignment: AlignmentDirectional.center,
                  ),
                ),
                10.hs,
                AppContainer(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 24.h,
                  ),
                  child: Column(
                    children: [
                      AppText(
                        text: 'بيانات مقدم الطلب',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.mainBlueIndigoDye,
                      ),
                      24.hs,
                      AppTextFormField(
                        labelText: 'الإسم الأول',
                        enabled: false,
                        filledColor: AppColors.neutralLightLight,
                      ),
                      16.hs,
                      AppTextFormField(
                        labelText: 'باقي الإسم',
                        enabled: false,
                        filledColor: AppColors.neutralLightLight,
                      ),
                      16.hs,
                      AppTextFormField(
                        labelText: 'البريد الإلكتروني',
                        enabled: false,
                        filledColor: AppColors.neutralLightLight,
                      ),
                      16.hs,
                      AppTextFormField(
                        labelText: 'رقم الهاتف المحمول',
                        enabled: false,
                        filledColor: AppColors.neutralLightLight,
                      ),
                      16.hs,
                      AppTextFormField(
                        labelText: 'الجنسية',
                        enabled: false,
                        filledColor: AppColors.neutralLightLight,
                        suffixWidget: DropDownIcon(),
                      ),
                      16.hs,
                      AppTextFormField(
                        labelText: 'الرقم القومي',
                        enabled: false,
                        filledColor: AppColors.neutralLightLight,
                      ),
                      16.hs,
                      AppTextFormField(
                        labelText: 'الرقم القومي',
                        enabled: false,
                        filledColor: AppColors.neutralLightLight,
                        prefixWidget: Container(
                          decoration: BoxDecoration(
                            color: AppColors.neutralLightDarkest,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                      ),
                      16.hs,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
