import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/extensions/dimensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../components/app_container.dart';
import '../../../components/app_text.dart';
import '../../../components/app_text_form_field.dart';
import '../cubit/applicant_cubit.dart';
import 'nationality_form.dart';

class UserInformation extends StatelessWidget {
  const UserInformation({super.key, required this.cubit});

  final ApplicantCubit cubit;

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
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
            controller: cubit.applicantFirstNameController,
            labelColor: AppColors.neutralDarkLightest,
          ),
          16.hs,
          AppTextFormField(
            labelText: 'باقي الإسم',
            enabled: false,
            filledColor: AppColors.neutralLightLight,
            controller: cubit.applicantLastNameController,
            labelColor: AppColors.neutralDarkLightest,
          ),
          16.hs,
          AppTextFormField(
            labelText: 'البريد الإلكتروني',
            enabled: false,
            filledColor: AppColors.neutralLightLight,
            controller: cubit.applicantEmailController,
            labelColor: AppColors.neutralDarkLightest,
          ),
          16.hs,
          AppTextFormField(
            labelText: 'رقم الهاتف المحمول',
            enabled: false,
            filledColor: AppColors.neutralLightLight,
            controller: cubit.applicantPhoneController,
            labelColor: AppColors.neutralDarkLightest,
          ),
          16.hs,
          NationalityForm(
            nationality: cubit.applicantNationality,
            onNationalityChanged: (_) {},
            filledColor: AppColors.neutralLightLight,
            enabled: false,
            fontSize: 12.sp,
            textColor: AppColors.neutralDarkLightest,
            labelRequired: false,
            attachmentIconColor: AppColors.neutralDarkLightest,
            nationalIdController: cubit.applicantNationalIdController,
            onNationalIdFilePicked: () {},
            nationalIdFilePath: cubit.applicantNationalIdFilePath,
            passportController: cubit.applicantPassportNumberController,
            onPassportFilePicked: () {},
            passportFilePath: cubit.applicantPassportFilePath,
            displayFile: false,
          ),

          16.hs,
        ],
      ),
    );
  }
}
