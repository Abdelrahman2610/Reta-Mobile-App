import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/extensions/dimensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../components/app_text_form_field.dart';
import '../cubit/applicant_cubit.dart';
import '../cubit/applicant_states.dart';
import '../pages/units/units_data_pages/components/file_upload_field.dart';

class SharedConventionalForm extends StatelessWidget {
  const SharedConventionalForm({super.key, required this.cubit});

  final ApplicantCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextFormField(
          labelText: 'إسم المكلف بأداء الضريبة',
          labelRequired: true,
          labelColor: AppColors.neutralDarkDark,
          validator: (value) => value == null ? 'هذا الحقل مطلوب' : null,
          labelFontSize: 14.sp,
          controller: cubit.taxpayerNameController,
        ),
        16.hs,
        AppTextFormField(
          labelText: 'رقم البطاقة الضريبة',
          labelColor: AppColors.neutralDarkDark,
          validator: (value) => value == null ? 'هذا الحقل مطلوب' : null,
          labelFontSize: 14.sp,
          controller: cubit.taxpayerTaxCardNumberController,
        ),
        16.hs,
        BlocBuilder<ApplicantCubit, ApplicantState>(
          buildWhen: (prev, curr) =>
              (prev.taxpayerTaxCardFullUrl != curr.taxpayerTaxCardFullUrl),
          builder: (context, state) {
            return FileUploadField(
              labelText: 'مرفق البطاقة الضريبة',
              filePath: cubit.taxpayerTaxCardUrl,
              labelRequired: true,
              onFilePicked: () async {
                final path = await cubit.pickFile();
                if (path != null) cubit.setTaxCardFile(path);
              },
              onFileRemoved: () => cubit.removeTaxCardFile.call(),
            );
          },
        ),
        16.hs,
        AppTextFormField(
          labelText: 'رقم السجل التجاري',
          labelColor: AppColors.neutralDarkDark,
          validator: (value) => value == null ? 'هذا الحقل مطلوب' : null,
          labelFontSize: 14.sp,
          controller: cubit.taxpayerCommercialRegisterController,
        ),
        16.hs,
        BlocBuilder<ApplicantCubit, ApplicantState>(
          buildWhen: (prev, curr) =>
              (prev.taxpayerCommercialRegisterFullUrl !=
              curr.taxpayerCommercialRegisterFullUrl),
          builder: (context, state) {
            return FileUploadField(
              labelText: 'مرفق السجل التجاري',
              filePath: cubit.taxpayerCommercialRegisterUrl,
              labelRequired: true,
              onFilePicked: () async {
                final path = await cubit.pickFile();
                if (path != null) cubit.setCommercialRegisterFile(path);
              },
              onFileRemoved: () => cubit.removeCommercialRegisterFile.call(),
            );
          },
        ),
        16.hs,
        AppTextFormField(
          labelText: 'إسم مرفق آخر',
          labelColor: AppColors.neutralDarkDark,
          validator: (value) => value == null ? 'هذا الحقل مطلوب' : null,
          labelFontSize: 14.sp,
          controller: cubit.taxpayerOtherAttachmentNameController,
        ),
        16.hs,
        BlocBuilder<ApplicantCubit, ApplicantState>(
          buildWhen: (prev, curr) =>
              (prev.taxpayerOtherAttachmentFullUrl !=
              curr.taxpayerOtherAttachmentFullUrl),
          builder: (context, state) {
            return FileUploadField(
              labelText: 'مرفق السجل التجاري',
              filePath: cubit.taxpayerOtherAttachmentUrl,
              labelRequired: true,
              onFilePicked: () async {
                final path = await cubit.pickFile();
                if (path != null) cubit.setOtherAttachmentFile(path);
              },
              onFileRemoved: () => cubit.removeOtherAttachmentFile.call(),
            );
          },
        ),
      ],
    );
  }
}
