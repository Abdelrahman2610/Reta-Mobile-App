import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reta/features/declarations/presentations/components/shared_ownership_form.dart';

import '../../../../core/helpers/app_enum.dart';
import '../../../../core/helpers/extensions/dimensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../components/app_bar.dart';
import '../../../components/app_button.dart';
import '../../../components/app_container.dart';
import '../components/declaration_tabs.dart';
import '../components/shared_form.dart';
import '../cubit/applicant_cubit.dart';

class TaxpayerDataPage extends StatelessWidget {
  const TaxpayerDataPage({super.key, required this.applicantType});

  final ApplicantType applicantType;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ApplicantCubit>();
    return Scaffold(
      backgroundColor: AppColors.neutralLightMedium,
      body: SingleChildScrollView(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: [
              MainAppBar(
                title: 'بيانات الإقرار',
                backgroundColor: AppColors.white,
                backButtonIconColor: AppColors.neutralDarkDark,
                titleTextStyle: TextStyle(
                  color: AppColors.neutralDarkDark,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              15.hs,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    DeclarationTabs(applicantType: applicantType),
                    10.hs,
                    switch (applicantType) {
                      ApplicantType.owner => SizedBox.shrink(),
                      ApplicantType.sharedOwnership => SharedOwnershipForm(),
                      ApplicantType.beneficiary => SizedBox.shrink(),
                      ApplicantType.agent => SharedForm(
                        uploadDocumentTitle:
                            'رفع سند إثبات صفة الوكيل (التوكيل الرسمي)',
                        uploadDocumentDescription:
                            'يجب أن يكون التوكيل ساريًا ومخوّلًا بتقديم الإقرار الضريبي.',
                      ),
                      ApplicantType.legalRepresentative => SharedForm(
                        uploadDocumentTitle: 'رفع سند التمثيل القانوني',
                        uploadDocumentDescription:
                            '(قرار تعيين/تفويض رسمي/حكم قضائي/أي مستند رسمي يثبت صفة التمثيل القانوني)',
                      ),
                      ApplicantType.other => SharedForm(
                        uploadDocumentTitle:
                            'رفع سند يوضح سبب التقديم بهذه الصفة',
                        uploadDocumentDescription:
                            'تفويض/قرار إداري/خطاب رسمي/أي مستند رسمي يوضح العلاقة بين مقدم الطلب والمكلّف بأداء الضريبة',
                      ),
                    },
                    10.hs,
                    AppContainer(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 24.h,
                      ),
                      child: AppButton(
                        label: 'التالي',
                        backgroundColor: AppColors.highlightDarkest,
                        textColor: AppColors.white,
                        fontSize: 12.sp,
                        alignment: Alignment.center,
                        onTap: cubit.onTaxpayerNextTapped,
                      ),
                    ),
                    26.hs,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
