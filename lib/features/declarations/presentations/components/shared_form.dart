import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reta/features/declarations/presentations/components/shared_conventional_form.dart';
import 'package:reta/features/declarations/presentations/components/shared_natural_form.dart';

import '../../../../core/helpers/extensions/dimensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../components/app_container.dart';
import '../../../components/app_text.dart';
import '../../../components/app_text_form_field.dart';
import '../cubit/applicant_cubit.dart';
import '../cubit/applicant_states.dart';
import '../cubit/declaration_lookups_cubit.dart';
import '../pages/units/units_data_pages/components/file_upload_field.dart';
import 'app_drop_down.dart';
import 'app_drop_down_option.dart';

class SharedForm extends StatefulWidget {
  const SharedForm({
    super.key,
    required this.uploadDocumentTitle,
    required this.uploadDocumentDescription,
  });

  final String uploadDocumentTitle;
  final String uploadDocumentDescription;

  @override
  State<SharedForm> createState() => _SharedFormState();
}

class _SharedFormState extends State<SharedForm> {
  final _phoneFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();

  @override
  void dispose() {
    _phoneFocusNode.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

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
            key: const ValueKey('shared_form_builder'),
            buildWhen: (prev, curr) =>
                prev.taxpayerNationality != curr.taxpayerNationality ||
                prev.taxpayerTypes != curr.taxpayerTypes ||
                prev.taxpayerNationalIdFilePath !=
                    curr.taxpayerNationalIdFilePath ||
                prev.taxpayerPassportFilePath !=
                    curr.taxpayerPassportFilePath ||
                prev.taxpayerAuthorizationFullUrl !=
                    curr.taxpayerAuthorizationFullUrl,
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
                  16.hs,
                  AppTextFormField(
                    labelText: 'رقم الهاتف المحمول',
                    labelRequired: cubit.taxpayerTypes == 'اعتباري'
                        ? false
                        : true,
                    labelColor: AppColors.neutralDarkDark,
                    validator: (value) {
                      if ((value == null || value.isEmpty) &&
                          cubit.taxpayerTypes == 'طبيعي') {
                        return 'هذا الحقل مطلوب';
                      }
                      if ((value?.length ?? 0) > 0 && value?.length != 11) {
                        return 'رقم الهاتف يجب ان يكون ١١ رقم';
                      }
                      return null;
                    },
                    labelFontSize: 14.sp,
                    controller: cubit.taxpayerPhoneController,
                    focusNode: _phoneFocusNode,
                  ),
                  16.hs,
                  AppTextFormField(
                    labelText: 'البريد الإلكتروني',
                    labelColor: AppColors.neutralDarkDark,
                    labelFontSize: 14.sp,
                    controller: cubit.taxpayerEmailController,
                    focusNode: _emailFocusNode,
                  ),
                  16.hs,
                  FileUploadField(
                    labelText: widget.uploadDocumentTitle,
                    filePath: cubit.taxpayerAuthorizationUrl,
                    labelRequired: true,
                    onFilePicked: () async {
                      final path = await cubit.pickFile();
                      if (path != null) cubit.setLegalAuthorizationFile(path);
                    },
                    onFileRemoved: () =>
                        cubit.removeLegalAuthorizationFile.call(),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
