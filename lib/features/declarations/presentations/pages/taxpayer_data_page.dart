import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reta/features/declarations/presentations/components/shared_ownership_form.dart';
import 'package:reta/features/declarations/presentations/cubit/applicant_states.dart';

import '../../../../core/helpers/app_enum.dart';
import '../../../../core/helpers/extensions/dimensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../components/app_bar.dart';
import '../../../components/app_button.dart';
import '../../../components/app_container.dart';
import '../../../components/app_loading.dart';
import '../../../components/app_text.dart';
import '../components/declaration_tabs.dart';
import '../components/shared_form.dart';
import '../cubit/applicant_cubit.dart';

class TaxpayerDataPage extends StatelessWidget {
  final bool handleCreateNewUnitFromDeclarationPropList;

  const TaxpayerDataPage({
    super.key,
    this.handleCreateNewUnitFromDeclarationPropList = false,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ApplicantCubit>();
    return Scaffold(
      backgroundColor: AppColors.neutralLightMedium,
      body: Form(
        key: cubit.formKey,
        child: MultiBlocListener(
          listeners: [
            BlocListener<ApplicantCubit, ApplicantState>(
              listenWhen: (prev, curr) =>
                  curr.errorMessage != null &&
                  prev.errorMessage != curr.errorMessage,
              listener: (context, state) {
                if (state.errorMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: AppText(
                        text: state.errorMessage!,
                        color: Colors.white,
                        alignment: AlignmentDirectional.center,
                        maxLines: 3,
                      ),
                      backgroundColor: AppColors.errorDark,
                    ),
                  );
                  cubit.clearError();
                }
              },
            ),
          ],
          child: Stack(
            children: [
              SingleChildScrollView(
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
                        onCancel: cubit.isEditMode
                            ? () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              }
                            : null,
                        onSave: cubit.isEditMode
                            ? () => cubit.saveTaxpayerEdit(context)
                            : null,
                      ),
                      15.hs,
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Column(
                          children: [
                            DeclarationTabs(applicantType: cubit.applicantType),
                            10.hs,
                            switch (cubit.applicantType) {
                              ApplicantType.owner => SizedBox.shrink(),
                              ApplicantType.sharedOwnership =>
                                SharedOwnershipForm(),
                              ApplicantType.beneficiary => SizedBox.shrink(),
                              ApplicantType.exploited => SizedBox.shrink(),
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
                            if (!cubit.isEditMode)
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
                                  onTap: () {
                                    if (cubit.validate()) {
                                      cubit.onTaxpayerNextTapped(
                                        context,
                                        handleCreateNewUnitFromDeclarationPropList:
                                            handleCreateNewUnitFromDeclarationPropList,
                                      );
                                    }
                                  },
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
              BlocSelector<ApplicantCubit, ApplicantState, bool>(
                selector: (state) => state.isLoading,
                builder: (context, isLoading) {
                  if (!isLoading) return const SizedBox.shrink();

                  if (FocusManager.instance.primaryFocus != null) {
                    return const SizedBox.shrink();
                  }
                  return const AppLoadingOverlay(
                    isLoading: true,
                    child: SizedBox.shrink(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
