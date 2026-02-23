import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reta/core/helpers/fixed_assets.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../components/app_bar.dart';
import '../../../components/app_text.dart';
import '../components/select_types_of_properties_item.dart';

class SelectTypesOfPropertiesPage extends StatelessWidget {
  final bool showSpecialProperties;

  const SelectTypesOfPropertiesPage({
    super.key,
    this.showSpecialProperties = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralLightMedium,
      appBar: MainAppBar(
        title: "اختيار نوع العقار",
        backgroundColor: AppColors.mainBlueIndigoDye,
        backButtonIconColor: Colors.white,
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 16.sp),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 31.h),
              AppText(
                text: "حدد نوع الوحدة الذي ترغب في إضافته إلى الإقرار",
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.mainBlueSecondary,
              ),
              SizedBox(height: 10.h),

              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: BoxBorder.all(color: AppColors.color1),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 24.h,
                  ),
                  child: Column(
                    children: [
                      AppText(
                        text: 'سكنية وغير سكنية',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.color1,
                      ),
                      SizedBox(height: 10.h),
                      SelectTypesOfPropertiesItem(
                        title: "الوحدات السكنية",
                        subTitle: "وحدات مخصصة للسكن مثل الشقق والفيلات.",
                        icon: FixedAssets.instance.icon1,
                      ),
                      SizedBox(height: 16.h),
                      SelectTypesOfPropertiesItem(
                        title: "الوحدات التجارية",
                        subTitle:
                            "وحدات مخصصة لمزاولة الأنشطة التجارية مثل المحلات والمعارض.",
                        icon: FixedAssets.instance.icon2,
                      ),
                      SizedBox(height: 16.h),
                      SelectTypesOfPropertiesItem(
                        title: "الوحدات الإدارية",
                        subTitle:
                            "وحدات مخصصة للأعمال الإدارية مثل المكاتب ومقار الشركات.",
                        icon: FixedAssets.instance.icon3,
                      ),
                      SizedBox(height: 16.h),
                      SelectTypesOfPropertiesItem(
                        title: "الوحدات الخدمية",
                        subTitle:
                            "وحدات تُستخدم لتقديم خدمات مثل العيادات والمدارس.",
                        icon: FixedAssets.instance.icon4,
                      ),
                      SizedBox(height: 16.h),
                      SelectTypesOfPropertiesItem(
                        title: "التركيبات الثابتة",
                        subTitle:
                            "تركيبات مثبتة بشكل دائم مثل الأبراج أو الخزانات أو اللوحات.",
                        icon: FixedAssets.instance.icon5,
                      ),
                      SizedBox(height: 16.h),
                      SelectTypesOfPropertiesItem(
                        title: "أراضٍ فضاء مستغلة",
                        subTitle:
                            "أراضٍ غير مبنية ويتم استخدامها في نشاط فعلي.",
                        icon: FixedAssets.instance.icon6,
                      ),
                    ],
                  ),
                ),
              ),
              if (showSpecialProperties) SizedBox(height: 15.h),
              if (showSpecialProperties)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: BoxBorder.all(color: AppColors.warningDark),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 24.h,
                    ),
                    child: Column(
                      children: [
                        AppText(
                          text: 'منشآت ذات طبيعة خاصة',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.warningDark,
                        ),
                        SizedBox(height: 10.h),
                        SelectTypesOfPropertiesItem(
                          title: "المنشآت الخدمية",
                          subTitle:
                              "منشآت مستقلة تُستخدم لتقديم خدمات متخصصة مثل المدرارس والمستشفيات.",
                          icon: FixedAssets.instance.icon7,
                        ),
                        SizedBox(height: 16.h),
                        SelectTypesOfPropertiesItem(
                          title: "المنشآت الفندقية",
                          subTitle: "منشآت مخصصة للإقامة والخدمات السياحية.",
                          icon: FixedAssets.instance.icon8,
                        ),
                        SizedBox(height: 16.h),
                        SelectTypesOfPropertiesItem(
                          title: "المنشآت الصناعية",
                          subTitle: "منشآت مخصصة للأنشطة الصناعية والإنتاج.",
                          icon: FixedAssets.instance.icon9,
                        ),
                        SizedBox(height: 16.h),
                        SelectTypesOfPropertiesItem(
                          title: "المنشآت الإنتاجية",
                          subTitle:
                              "منشآت تقوم بأنشطة إنتاجية غير صناعية مباشرة مثل مزارع الدواجن.",
                          icon: FixedAssets.instance.icon10,
                        ),
                        SizedBox(height: 16.h),
                        SelectTypesOfPropertiesItem(
                          title: "منشآت بترولية",
                          subTitle: "منشآت مرتبطة بأنشطة قطاع البترول.",
                          icon: FixedAssets.instance.icon11,
                        ),
                        SizedBox(height: 16.h),
                        SelectTypesOfPropertiesItem(
                          title: "مناجم ومحاجر وملاحات",
                          subTitle:
                              "مواقع مخصصة لأعمال التعدين والمحاجر والملاحات.",
                          icon: FixedAssets.instance.icon12,
                        ),
                      ],
                    ),
                  ),
                ),
              SizedBox(height: 31.h),
            ],
          ),
        ),
      ),
    );
  }
}
