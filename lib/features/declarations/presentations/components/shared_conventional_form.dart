import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/extensions/dimensions.dart';
import '../../../../core/helpers/fixed_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../components/app_text_form_field.dart';
import '../../../components/image_svg_custom_widget.dart';
import '../cubit/applicant_cubit.dart';
import '../cubit/applicant_states.dart';
import 'app_attachment_item.dart';

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
              (prev.taxpayerTaxCardFilePath != curr.taxpayerTaxCardFilePath),
          builder: (context, state) {
            return AppTextFormField(
              labelText: 'مرفق البطاقة الضريبة',
              labelRequired: true,
              labelFontSize: 14.sp,
              labelColor: AppColors.neutralDarkDark,
              readOnly: true,
              suffixWidget: ImageSvgCustomWidget(
                imgPath: FixedAssets.instance.attachmentWhiteIC,
                width: 16.w,
                height: 16.h,
                color: AppColors.highlightDarkest,
              ),
              prefixWidget: AppAttachmentItem(
                onTap: () async {
                  if (cubit.taxpayerTaxCardFilePath == null) {
                    final path = await cubit.pickFile();
                    if (path != null) cubit.setTaxCardFile(path);
                  } else {
                    cubit.removeTaxCardFile.call();
                  }
                },
                containFile: cubit.taxpayerTaxCardFilePath != null,
              ),
              infoText: 'ملف بصيغة Jpg أو pdf لا يتجاوز حجمه 5 ميجا بايت',
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
              (prev.taxpayerCommercialRegisterFilePath !=
              curr.taxpayerCommercialRegisterFilePath),
          builder: (context, state) {
            return AppTextFormField(
              labelText: 'مرفق السجل التجاري',
              labelRequired: true,
              labelFontSize: 14.sp,
              labelColor: AppColors.neutralDarkDark,
              readOnly: true,
              suffixWidget: ImageSvgCustomWidget(
                imgPath: FixedAssets.instance.attachmentWhiteIC,
                width: 16.w,
                height: 16.h,
                color: AppColors.highlightDarkest,
              ),
              prefixWidget: AppAttachmentItem(
                onTap: () async {
                  if (cubit.taxpayerCommercialRegisterFilePath == null) {
                    final path = await cubit.pickFile();
                    if (path != null) cubit.setCommercialRegisterFile(path);
                  } else {
                    cubit.removeCommercialRegisterFile.call();
                  }
                },
                containFile: cubit.taxpayerCommercialRegisterFilePath != null,
              ),
              infoText: 'ملف بصيغة Jpg أو pdf لا يتجاوز حجمه 5 ميجا بايت',
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
              (prev.taxpayerOtherAttachmentFilePath !=
              curr.taxpayerOtherAttachmentFilePath),
          builder: (context, state) {
            return AppTextFormField(
              labelText: 'مرفق آخر',
              labelRequired: true,
              labelFontSize: 14.sp,
              labelColor: AppColors.neutralDarkDark,
              readOnly: true,
              suffixWidget: ImageSvgCustomWidget(
                imgPath: FixedAssets.instance.attachmentWhiteIC,
                width: 16.w,
                height: 16.h,
                color: AppColors.highlightDarkest,
              ),
              prefixWidget: AppAttachmentItem(
                onTap: () async {
                  if (cubit.taxpayerOtherAttachmentFilePath == null) {
                    final path = await cubit.pickFile();
                    if (path != null) cubit.setOtherAttachmentFile(path);
                  } else {
                    cubit.removeOtherAttachmentFile.call();
                  }
                },
                containFile: cubit.taxpayerOtherAttachmentFilePath != null,
              ),
              infoText: 'ملف بصيغة Jpg أو pdf لا يتجاوز حجمه 5 ميجا بايت',
            );
          },
        ),
      ],
    );
  }
}
