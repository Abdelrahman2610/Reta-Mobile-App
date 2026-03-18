import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reta/features/components/inkwell_transparent.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../components/app_text.dart';
import '../../../components/title_with_value_text.dart';
import '../../data/models/declaration_model.dart';

class DeclarationsCardItem extends StatelessWidget {
  final DeclarationModel item;
  final Function updateDeclarationList;
  final VoidCallback onDeclarationCardTapped;

  const DeclarationsCardItem({
    super.key,
    required this.item,
    required this.updateDeclarationList,
    required this.onDeclarationCardTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15.h),
      child: InkwellTransparent(
        onTap: onDeclarationCardTapped,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              colors: [Color(0xFFFFFFFF), Color(0xFFF3F6FE), Color(0xFFE4ECFB)],
              stops: [0.1, 0.85, 1.0],
            ),
            border: Border.all(color: AppColors.neutralLightDark),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(
                      text: "إقرار ${item.declarationTypeText ?? ""}",
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.mainBlueIndigoDye,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: item.statusId == "1"
                            ? AppColors.neutralDarkLightest
                            : item.statusId == "2"
                            ? AppColors.successMedium
                            : AppColors.errorMedium,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        child: AppText(
                          text: item.statusText,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Expanded(
                      child: TitleWithValueText(
                        "صفة مقدم الطلب",
                        item.submitterType ?? "-",
                        valueColor: AppColors.neutralDarkMedium,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: TitleWithValueText(
                        "رقم الإقرار",
                        item.declarationNumber ?? "-",
                        valueColor: AppColors.neutralDarkMedium,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Expanded(
                      child: TitleWithValueText(
                        "عدد الوحدات",
                        item.unitsCount?.total.toString() ?? "-",
                        valueColor: AppColors.neutralDarkMedium,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: TitleWithValueText(
                        "آخر تحديث",
                        item.updateDate ?? "-",
                        valueColor: AppColors.neutralDarkMedium,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
