import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/app_enum.dart';
import '../../../../core/helpers/extensions/dimensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../components/app_text_form_field.dart';
import '../cubit/applicant_cubit.dart';
import 'nationality_form.dart';

class SharedNaturalForm extends StatelessWidget {
  const SharedNaturalForm({
    super.key,
    required this.nationality,
    required this.onNationalityChanged,
    required this.cubit,
  });

  final Nationality nationality;
  final Function(String?) onNationalityChanged;
  final ApplicantCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextFormField(
          labelText: 'الإسم الأول للمكلف بأداء الضريبة',
          labelRequired: true,
          labelColor: AppColors.neutralDarkDark,
          validator: (value) {
            return (value == null || value.isEmpty) ? 'هذا الحقل مطلوب' : null;
          },
          labelFontSize: 14.sp,
          controller: cubit.taxpayerFirstNameController,
        ),
        16.hs,
        AppTextFormField(
          labelText: 'باقي الإسم للمكلف بأداء الضريبة',
          labelRequired: true,
          labelColor: AppColors.neutralDarkDark,
          validator: (value) {
            return (value == null || value.isEmpty) ? 'هذا الحقل مطلوب' : null;
          },
          labelFontSize: 14.sp,
          controller: cubit.taxpayerLastNameController,
        ),
        16.hs,
        NationalityForm(
          nationality: nationality,
          onNationalityChanged: onNationalityChanged,
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
          onNationalIdFileRemoved: () => cubit.removeNationalIdFile.call(),
          onPassportFileRemoved: () => cubit.removePassportFile.call(),
        ),
      ],
    );
  }
}
