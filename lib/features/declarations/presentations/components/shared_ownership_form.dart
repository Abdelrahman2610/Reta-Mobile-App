import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/extensions/dimensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../components/app_container.dart';
import '../../../components/app_text.dart';
import '../../../components/app_text_form_field.dart';
import '../cubit/applicant_cubit.dart';
import '../cubit/applicant_states.dart';
import '../pages/units/units_data_pages/components/file_upload_field.dart';
import 'nationality_form.dart';

class SharedOwnershipForm extends StatelessWidget {
  const SharedOwnershipForm({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ApplicantCubit>();
    return AppContainer(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      child: Column(
        children: [
          AppText(
            text: 'بيانات المكلف بأداء الضريبة',
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.mainBlueIndigoDye,
          ),
          24.hs,
          AppTextFormField(
            labelText: 'إسم المكلف بأداء الضريبة',
            controller: cubit.taxpayerNameController,
            labelRequired: true,
            labelColor: AppColors.neutralDarkDark,
            validator: (v) => v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
            labelFontSize: 14.sp,
            prefixWidget: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.only(start: 16.w),
                  child: AppText(
                    text: 'ورثة/شركاء',
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                    color: AppColors.neutralDarkLightest,
                  ),
                ),
              ],
            ),
          ),
          16.hs,
          BlocBuilder<ApplicantCubit, ApplicantState>(
            buildWhen: (prev, curr) =>
                (prev.taxpayerNationality != curr.taxpayerNationality) ||
                (prev.taxpayerNationalIdFilePath !=
                    curr.taxpayerNationalIdFilePath) ||
                (prev.taxpayerPassportFilePath !=
                    curr.taxpayerPassportFilePath),
            builder: (context, state) {
              return NationalityForm(
                nationality:
                    state.taxpayerNationality ?? cubit.taxpayerNationality,
                onNationalityChanged: cubit.changeNationality,
                nationalIdController: cubit.taxpayerNationalIdController,
                onNationalIdFilePicked: () async {
                  if (cubit.taxpayerNationalIdFilePath == null) {
                    final path = await cubit.pickFile();
                    if (path != null) cubit.setNationalIdFile(path);
                  }
                },
                nationalIdFilePath: cubit.taxpayerNationalIdUrl,
                passportController: cubit.taxpayerPassportNumberController,
                onPassportFilePicked: () async {
                  if (cubit.taxpayerPassportFilePath == null) {
                    final path = await cubit.pickFile();
                    if (path != null) cubit.setPassportFile(path);
                  }
                },
                passportFilePath: cubit.taxpayerPassportUrl,
                attachmentIconColor: AppColors.neutralDarkLightest,
                onNationalIdFileRemoved: () =>
                    cubit.removeNationalIdFile.call(),
                onPassportFileRemoved: () => cubit.removePassportFile.call(),
              );
            },
          ),

          16.hs,
          BlocBuilder<ApplicantCubit, ApplicantState>(
            buildWhen: (prev, curr) =>
                prev.ownershipProofDocumentPath !=
                curr.ownershipProofDocumentPath,
            builder: (context, state) {
              return FileUploadField(
                labelText: 'رفع سند الملكية على الشيوع/ إعلام الوراثة',
                filePath: state.ownershipProofDocumentPath,
                labelRequired: true,
                onFilePicked: () async {
                  final path = await cubit.pickFile();
                  if (path != null) cubit.setOwnershipProofDocumentFile(path);
                },
                onFileRemoved: () =>
                    cubit.removeOwnershipProofDocumentFile.call(),
              );
            },
          ),
        ],
      ),
    );
  }
}
