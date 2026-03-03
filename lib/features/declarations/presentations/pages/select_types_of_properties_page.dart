import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reta/core/helpers/app_enum.dart';
import 'package:reta/core/helpers/fixed_assets.dart';
import 'package:reta/features/declarations/presentations/pages/units/unit_location_data_page.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../components/app_bar.dart';
import '../../../components/app_text.dart';
import '../components/select_types_of_properties_item.dart';
import '../cubit/applicant_cubit.dart';
import '../cubit/declaration/declaration_cubit.dart';
import '../cubit/declaration_lookups_cubit.dart';

class SelectTypesOfPropertiesPage extends StatelessWidget {
  final ApplicantType applicantType;
  final int declarationId;
  final Map<String, dynamic>? locationData;
  final Map<String, dynamic>? unitData;

  const SelectTypesOfPropertiesPage({
    super.key,
    required this.applicantType,
    required this.declarationId,
    this.locationData,
    this.unitData,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
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
                          onTap: () =>
                              onUnitTapped(UnitType.residential, context),
                        ),
                        SizedBox(height: 16.h),
                        SelectTypesOfPropertiesItem(
                          title: "الوحدات التجارية",
                          subTitle:
                              "وحدات مخصصة لمزاولة الأنشطة التجارية مثل المحلات والمعارض.",
                          icon: FixedAssets.instance.icon2,
                          onTap: () =>
                              onUnitTapped(UnitType.commercial, context),
                        ),
                        SizedBox(height: 16.h),
                        SelectTypesOfPropertiesItem(
                          title: "الوحدات الإدارية",
                          subTitle:
                              "وحدات مخصصة للأعمال الإدارية مثل المكاتب ومقار الشركات.",
                          icon: FixedAssets.instance.icon3,
                          onTap: () =>
                              onUnitTapped(UnitType.administrative, context),
                        ),
                        SizedBox(height: 16.h),
                        SelectTypesOfPropertiesItem(
                          title: "الوحدات الخدمية",
                          subTitle:
                              "وحدات تُستخدم لتقديم خدمات مثل العيادات والمدارس.",
                          icon: FixedAssets.instance.icon4,
                          onTap: () =>
                              onUnitTapped(UnitType.serviceUnit, context),
                        ),
                        SizedBox(height: 16.h),
                        SelectTypesOfPropertiesItem(
                          title: "التركيبات الثابتة",
                          subTitle:
                              "تركيبات مثبتة بشكل دائم مثل الأبراج أو الخزانات أو اللوحات.",
                          icon: FixedAssets.instance.icon5,
                          onTap: () => onUnitTapped(
                            UnitType.fixedInstallations,
                            context,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        SelectTypesOfPropertiesItem(
                          title: "أراضٍ فضاء مستغلة",
                          subTitle:
                              "أراضٍ غير مبنية ويتم استخدامها في نشاط فعلي.",
                          icon: FixedAssets.instance.icon6,
                          onTap: () =>
                              onUnitTapped(UnitType.vacantLand, context),
                        ),
                      ],
                    ),
                  ),
                ),
                if (locationData == null &&
                    ApplicantType.owner != applicantType &&
                    ApplicantType.sharedOwnership != applicantType)
                  SizedBox(height: 15.h),
                if (locationData == null &&
                    ApplicantType.owner != applicantType &&
                    ApplicantType.sharedOwnership != applicantType)
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
                            onTap: () =>
                                onUnitTapped(UnitType.serviceFacility, context),
                          ),
                          SizedBox(height: 16.h),
                          SelectTypesOfPropertiesItem(
                            title: "المنشآت الفندقية",
                            subTitle: "منشآت مخصصة للإقامة والخدمات السياحية.",
                            icon: FixedAssets.instance.icon8,
                            onTap: () =>
                                onUnitTapped(UnitType.hotelFacility, context),
                          ),
                          SizedBox(height: 16.h),
                          SelectTypesOfPropertiesItem(
                            title: "المنشآت الصناعية",
                            subTitle: "منشآت مخصصة للأنشطة الصناعية والإنتاج.",
                            icon: FixedAssets.instance.icon9,
                            onTap: () => onUnitTapped(
                              UnitType.industrialFacility,
                              context,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          SelectTypesOfPropertiesItem(
                            title: "المنشآت الإنتاجية",
                            subTitle:
                                "منشآت تقوم بأنشطة إنتاجية غير صناعية مباشرة مثل مزارع الدواجن.",
                            icon: FixedAssets.instance.icon10,
                            onTap: () => onUnitTapped(
                              UnitType.productionFacility,
                              context,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          SelectTypesOfPropertiesItem(
                            title: "منشآت بترولية",
                            subTitle: "منشآت مرتبطة بأنشطة قطاع البترول.",
                            icon: FixedAssets.instance.icon11,
                            onTap: () => onUnitTapped(
                              UnitType.petroleumFacility,
                              context,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          SelectTypesOfPropertiesItem(
                            title: "مناجم ومحاجر وملاحات",
                            subTitle:
                                "مواقع مخصصة لأعمال التعدين والمحاجر والملاحات.",
                            icon: FixedAssets.instance.icon12,
                            onTap: () => onUnitTapped(
                              UnitType.minesAndQuarries,
                              context,
                            ),
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
      ),
    );
  }

  void onUnitTapped(UnitType unitType, BuildContext context) {
    final applicantCubit = context.read<ApplicantCubit>();
    final declarationCubit = context.read<DeclarationCubit>();
    final lookupsCubit = context.read<DeclarationLookupsCubit>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: applicantCubit),
            BlocProvider.value(value: lookupsCubit),
            BlocProvider.value(value: declarationCubit),
          ],
          child: UnitLocationDataPage(
            unitType: unitType,
            applicantType: applicantType,
            declarationId: declarationId,
            locationData: locationData,
            unitData: unitData,
          ),
        ),
      ),
    );
  }
}
