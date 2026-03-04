import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/helpers/extensions/dimensions.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../components/app_container.dart';
import '../../../../../components/app_text.dart';
import '../../../../../components/app_text_form_field.dart';
import '../../../components/app_drop_down.dart';
import '../../../components/app_drop_down_option.dart';
import '../../../cubit/units/unit_data/unit_data_cubit.dart';
import '../../../cubit/units/unit_data/unit_data_state.dart';
import 'components/additional_documents_section.dart';
import 'components/calendar_icon.dart';
import 'components/file_upload_field.dart';
import 'components/floor_unit_section.dart';
import 'components/tax_contact_section.dart';

class FixedInstallationsPage extends StatelessWidget {
  const FixedInstallationsPage({super.key, required this.unitCubit});

  final UnitDataCubit unitCubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: unitCubit,
      child: _FixedInstallationsView(),
    );
  }
}

class _FixedInstallationsView extends StatelessWidget {
  const _FixedInstallationsView();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UnitDataCubit>();

    return Form(
      key: cubit.formKey,
      child: AppContainer(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: BlocBuilder<UnitDataCubit, UnitDataState>(
          builder: (context, state) {
            return Column(
              children: [
                AppText(
                  text: 'بيانات التركيبة الثابتة',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.mainBlueIndigoDye,
                ),
                24.hs,

                const FloorUnitSection(),
                16.hs,

                const TaxContactSection(
                  customLabel:
                      'هل تم التواصل مع الضرائب العقارية بخصوص التركيبة؟',
                ),
                16.hs,

                AppTextFormField(
                  labelText: 'كود حساب التركيبة',
                  controller: cubit.unitCodeController,
                  hintText: 'ادخل كود حساب التركيبة',
                ),
                16.hs,

                AppDropdownField<String>(
                  labelText: 'نوع التركيبة',
                  labelRequired: true,
                  hintText: 'اختر نوع التركيبة',
                  value: state.selectedInstallationType,
                  items: cubit.installationTypes
                      .map((t) => appDropDownOption(label: t))
                      .toList(),
                  onChanged: cubit.selectInstallationType,
                  validator: (v) => v == null ? 'هذا الحقل مطلوب' : null,
                ),
                16.hs,

                AppTextFormField(
                  labelText: 'نوع التركيب الآخر',
                  labelRequired: true,
                  controller: cubit.otherInstallationTypeController,
                  hintText: 'إدخال نوع التركيب الآخر',
                  validator: (v) =>
                      v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
                ),
                16.hs,

                AppDropdownField<String>(
                  labelText: 'هل المكلف بأداء الضريبة هو مالك التركيب؟',
                  labelRequired: true,
                  hintText: 'اختر',
                  value: state.isTaxpayerOwner == null
                      ? null
                      : state.isTaxpayerOwner!
                      ? kYes
                      : kNo,
                  items: cubit.yesNoOptions
                      .map((o) => appDropDownOption(label: o))
                      .toList(),
                  onChanged: (v) => cubit.setIsTaxpayerOwner(
                    v == kYes ? true : false,
                    context,
                  ),
                  validator: (v) => v == null ? 'هذا الحقل مطلوب' : null,
                ),
                16.hs,

                AppTextFormField(
                  labelText: (state.isTaxpayerOwner ?? false)
                      ? 'مالك التركيب'
                      : 'اسم مالك التركيب',
                  labelRequired: !(state.isTaxpayerOwner ?? false),
                  labelColor: (state.isTaxpayerOwner ?? false)
                      ? AppColors.neutralDarkLightest
                      : null,
                  enabled: !(state.isTaxpayerOwner ?? false),
                  filledColor: (state.isTaxpayerOwner ?? false)
                      ? AppColors.neutralLightLight
                      : null,
                  controller: cubit.installationOwnerController,
                  hintText: 'عادل عبد المقصود إبراهيم',
                  validator: (v) =>
                      v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
                ),
                16.hs,

                AppTextFormField(
                  labelText: 'تاريخ بداية التعاقد',
                  labelRequired: true,
                  controller: cubit.contractStartDateController,
                  hintText: 'ادخل تاريخ بداية التعاقد',
                  readOnly: true,
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      cubit.contractStartDateController.text =
                          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
                    }
                  },
                  suffixWidget: CalendarIcon(),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
                ),
                16.hs,

                AppTextFormField(
                  labelText: 'تاريخ نهاية التعاقد',
                  labelRequired: true,
                  controller: cubit.contractEndDateController,
                  hintText: 'ادخل تاريخ نهاية التعاقد',
                  readOnly: true,
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      cubit.contractEndDateController.text =
                          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
                    }
                  },
                  suffixWidget: CalendarIcon(),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
                ),
                16.hs,

                AppTextFormField(
                  labelText: 'القيمة الإيجارية السنوية',
                  controller: cubit.annualRentalValueController,
                  hintText: 'ادخل القيمة الإيجارية السنوية',
                  keyboardType: TextInputType.number,
                ),
                16.hs,

                BlocBuilder<UnitDataCubit, UnitDataState>(
                  buildWhen: (prev, curr) =>
                      prev.ownershipDeedFilePath != curr.ownershipDeedFilePath,
                  builder: (context, state) {
                    return FileUploadField(
                      labelText: 'سند الملكية، الإنتفاع أو الإستغلال',
                      text: 'حمل ملف',
                      backgroundColor: AppColors.highlightDarkest,
                      textColor: AppColors.white,
                      filePath: state.ownershipDeedFilePath,
                      onFilePicked: () async {
                        final path = await cubit.pickFile();
                        if (path != null) {
                          cubit.setOwnershipDeedFile(path);
                        }
                      },
                      onFileRemoved: () => cubit.removeOwnershipDeedFile(),
                    );
                  },
                ),
                16.hs,

                const AdditionalDocumentsSection(),
              ],
            );
          },
        ),
      ),
    );
  }
}
