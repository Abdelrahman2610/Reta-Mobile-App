import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../components/app_button.dart';
import '../../data/models/declaration_details_model.dart';

class UnitTypeCategoryTabWidget extends StatelessWidget {
  int selectedIndex;
  final Function(int) onIndexPressed;
  final List<CategoryConfig> activeCategories;

  UnitTypeCategoryTabWidget(
    this.selectedIndex,
    this.onIndexPressed,
    this.activeCategories, {
    super.key,
  });

  // final List<String> _tabs = [
  //   'الوحدات السكنية',
  //   'الوحدات التجارية',
  //   'الوحدات الإدارية',
  //   'الوحدات الفندقية',
  //   'الوحدات الصناعية',
  //   'الوحدات الإنتاجية',
  //   'الوحدات البترولية',
  //   'المحاجر والمناجم',
  //   'الأراضي الفضاء',
  //   'المنشآت الثابتة',
  // ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: activeCategories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final isSelected = selectedIndex == index;
          return Column(
            children: [
              AppButton(
                onTap: () {
                  onIndexPressed(index);
                },
                label: activeCategories[index].label,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                textColor: isSelected
                    ? Colors.white
                    : AppColors.mainBlueIndigoDye,
                backgroundColor: !isSelected
                    ? AppColors.highlightLightest
                    : AppColors.mainBlueIndigoDye,
                borderColor: AppColors.neutralDarkLightest,
                height: 29.h,
                borderRadius: 12,
                width: 110.w,
              ),
            ],
          );
        },
      ),
    );
  }
}
