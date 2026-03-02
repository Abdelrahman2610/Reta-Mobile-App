import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reta/features/declarations/presentations/components/shared_conventional_form.dart';
import 'package:reta/features/declarations/presentations/components/shared_natural_form.dart';

import '../../../../core/helpers/extensions/dimensions.dart';
import '../../../../core/helpers/fixed_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../components/app_container.dart';
import '../../../components/app_text.dart';
import '../../../components/app_text_form_field.dart';
import '../../../components/image_svg_custom_widget.dart';
import '../cubit/applicant_cubit.dart';
import '../cubit/applicant_states.dart';
import '../cubit/declaration_lookups_cubit.dart';
import 'app_attachment_item.dart';
import 'app_drop_down.dart';
import 'app_drop_down_option.dart';

class SharedForm extends StatelessWidget {
  const SharedForm({
    super.key,
    required this.uploadDocumentTitle,
    required this.uploadDocumentDescription,
  });

  final String uploadDocumentTitle;
  final String uploadDocumentDescription;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ApplicantCubit>();
    final lookups = context.read<DeclarationLookupsCubit>().lookups;
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
          BlocBuilder<ApplicantCubit, ApplicantState>(
            buildWhen: (prev, curr) =>
                (prev.taxpayerNationality != curr.taxpayerNationality) ||
                (prev.taxpayerTypes != curr.taxpayerTypes) ||
                (prev.taxpayerNationalIdFilePath !=
                    curr.taxpayerNationalIdFilePath) ||
                (prev.taxpayerPassportFilePath !=
                    curr.taxpayerPassportFilePath),
            builder: (context, state) {
              return Column(
                children: [
                  AppDropdownField<String>(
                    labelText: 'نوع المكلف بأداء الضريبة',
                    labelRequired: true,
                    hintText: 'اختر نوع المكلف',
                    value: cubit.taxpayerTypes,
                    items:
                        lookups?.taxpayerTypes
                            .map((t) => appDropDownOption(label: t.name))
                            .toList() ??
                        [],
                    onChanged: cubit.changeTaxpayerType,
                    validator: (value) =>
                        value == null ? 'هذا الحقل مطلوب' : null,
                  ),
                  16.hs,
                  if (cubit.taxpayerTypes == 'طبيعي')
                    SharedNaturalForm(
                      nationality: cubit.taxpayerNationality,
                      onNationalityChanged: cubit.changeNationality,
                      cubit: cubit,
                    ),
                  if (cubit.taxpayerTypes == 'اعتباري')
                    SharedConventionalForm(cubit: cubit),
                ],
              );
            },
          ),

          16.hs,
          AppTextFormField(
            labelText: 'رقم الهاتف المحمول',
            labelRequired: true,
            labelColor: AppColors.neutralDarkDark,
            validator: (value) => value == null ? 'هذا الحقل مطلوب' : null,
            labelFontSize: 14.sp,
            controller: cubit.taxpayerPhoneController,
          ),
          16.hs,
          AppTextFormField(
            labelText: 'البريد الإلكتروني',
            labelColor: AppColors.neutralDarkDark,
            labelFontSize: 14.sp,
            controller: cubit.taxpayerEmailController,
          ),
          16.hs,
          BlocBuilder<ApplicantCubit, ApplicantState>(
            buildWhen: (prev, curr) =>
                (prev.taxpayerAuthorizationFilePath !=
                curr.taxpayerAuthorizationFilePath),
            builder: (context, state) {
              return AppTextFormField(
                labelText: uploadDocumentTitle,
                labelRequired: true,
                readOnly: true,
                description: uploadDocumentDescription,
                labelColor: AppColors.neutralDarkDark,
                labelFontSize: 14.sp,
                suffixWidget: ImageSvgCustomWidget(
                  imgPath: FixedAssets.instance.attachmentWhiteIC,
                  width: 16.w,
                  height: 16.h,
                  color: AppColors.neutralDarkLightest,
                ),
                prefixWidget: AppAttachmentItem(
                  onTap: () async {
                    if (cubit.taxpayerAuthorizationFilePath == null) {
                      final path = await cubit.pickFile();
                      if (path != null) cubit.setLegalAuthorizationFile(path);
                    } else {
                      cubit.removeLegalAuthorizationFile.call();
                    }
                  },
                  containFile: cubit.taxpayerAuthorizationFilePath != null,
                ),
                infoText: 'ملف بصيغة Jpg أو pdf لا يتجاوز حجمه 5 ميجا بايت',
              );
            },
          ),
        ],
      ),
    );
  }
}
