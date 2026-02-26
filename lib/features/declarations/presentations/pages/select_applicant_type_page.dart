import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../components/app_bar.dart';
import '../../../components/app_text.dart';
import '../components/select_applicant_type_item.dart';

class SelectApplicantTypePage extends StatelessWidget {
  const SelectApplicantTypePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralLightMedium,
      appBar: MainAppBar(
        title: "صفة مقدم الطلب",
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
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
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
                        text: 'إختار صفة مقدم الطلب',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.mainBlueIndigoDye,
                      ),
                      SizedBox(height: 24.h),
                      SelectApplicantTypeItem(
                        title: "مالك",
                        subTitle:
                            "تقديم الإقرار عن جميع العقارات المملوكة لك بصفتك المالك القانوني.",
                      ),
                      SizedBox(height: 16.h),
                      SelectApplicantTypeItem(
                        title: "مالك على الشيوع",
                        subTitle:
                            "تقديم الإقرار عن عقار مملوك بالاشتراك مع شركاء أو ورثة آخرين.",
                      ),
                      SizedBox(height: 16.h),
                      SelectApplicantTypeItem(
                        title: "منتفع",
                        subTitle:
                            "تقديم الإقرار عن عقار لك حق الانتفاع به وفق سند أو حق قانوني.",
                      ),
                      SizedBox(height: 16.h),
                      SelectApplicantTypeItem(
                        title: "وكيل",
                        subTitle:
                            "تقديم الإقرار نيابةً عن المكلف بموجب توكيل رسمي ساري.",
                      ),
                      SizedBox(height: 16.h),
                      SelectApplicantTypeItem(
                        title: "ممثل قانوني",
                        subTitle:
                            "تقديم الإقرار بصفتك ممثلًا قانونيًا عن شخص أو جهة مكلفة.",
                      ),
                      SizedBox(height: 16.h),
                      SelectApplicantTypeItem(
                        title: "أخرى",
                        subTitle:
                            "تقديم الإقرار في حالات خاصة لا تندرج ضمن الصفات السابقة.",
                        isOther: true,
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
