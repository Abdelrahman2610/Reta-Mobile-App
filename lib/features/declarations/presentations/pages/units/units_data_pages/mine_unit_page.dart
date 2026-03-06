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
import 'components/tax_contact_section.dart';

class MineUnitPage extends StatelessWidget {
  const MineUnitPage({super.key, required this.unitCubit});

  final UnitDataCubit unitCubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(value: unitCubit, child: const _MineUnitView());
  }
}

class _MineUnitView extends StatelessWidget {
  const _MineUnitView();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UnitDataCubit>();

    return BlocBuilder<UnitDataCubit, UnitDataState>(
      builder: (context, state) {
        return Form(
          key: cubit.formKey,
          child: AppContainer(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AppText(
                  text: 'بيانات مناجم/محاجر/ملاحات',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.mainBlueIndigoDye,
                ),
                24.hs,
                AppDropdownField<String>(
                  labelText: 'نوع المنشأة',
                  labelRequired: true,
                  hintText: 'اختر نوع المنشأة',
                  value: state.selectedMineQuarryFacilityTypesValue,
                  items: cubit.lookups.mineQuarryFacilityTypesValue
                      .map((b) => appDropDownOption(label: b.name))
                      .toList(),
                  onChanged: cubit.selectedMineQuarryFacilityTypes,
                  validator: (v) => v == null ? 'هذا الحقل مطلوب' : null,
                ),
                16.hs,
                AppDropdownField<String>(
                  labelText: 'نوع المادة المستخرجة',
                  labelRequired: true,
                  hintText: 'اختر نوع المادة المستخرجة',
                  value: state.selectedMineQuarryMaterialsValue,
                  items: cubit.lookups.mineQuarryMaterialsValue
                      .map((b) => appDropDownOption(label: b.name))
                      .toList(),
                  onChanged: cubit.selectedMineQuarryMaterials,
                  validator: (v) => v == null ? 'هذا الحقل مطلوب' : null,
                ),
                16.hs,
                AppTextFormField(
                  labelText: 'المساحة المُرخص بها',
                  labelRequired: true,
                  controller: cubit.totalLandUtilized,
                  keyboardType: TextInputType.number,
                  hintText: 'المساحة الإجمالية بالمتر المربع',
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
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'هذا الحقل مطلوب';

                    final start = DateTime.tryParse(
                      cubit.contractStartDateController.text.trim(),
                    );
                    final end = DateTime.tryParse(v.trim());

                    if (start != null && end != null && end.isBefore(start)) {
                      return 'تاريخ النهاية يجب أن يكون بعد تاريخ البداية';
                    }
                    return null;
                  },
                ),
                16.hs,
                AppTextFormField(
                  labelText:
                      'القيمة الإيجارية السنوية أو الإنتفاع أو الإستغلال',
                  labelRequired: false,
                  controller: cubit.bookValueController,
                  keyboardType: TextInputType.number,
                  hintText: 'ادخل القيمة الإيجارية',
                ),
                16.hs,
                // ── هل تم التواصل مع الضرائب؟ (reta_contact_about_unit) ─
                const TaxContactSection(
                  customLabel:
                      'هل تم التواصل مع الضرائب العقارية بخصوص المنشأة محل الإقرار سابقاً؟',
                ),
                16.hs,

                // ── كود حساب المنشأة (account_code) ────
                BlocBuilder<UnitDataCubit, UnitDataState>(
                  buildWhen: (prev, curr) =>
                      prev.contactedTaxAuthority != curr.contactedTaxAuthority,
                  builder: (context, state) {
                    return (state.contactedTaxAuthority ?? false)
                        ? Column(
                            children: [
                              AppTextFormField(
                                labelText: 'كود حساب المنشأة',
                                controller: cubit.unitCodeController,
                                hintText: 'ادخل كود حساب المنشأة',
                                keyboardType: TextInputType.number,
                              ),
                              16.hs,
                            ],
                          )
                        : const SizedBox.shrink();
                  },
                ),
                BlocBuilder<UnitDataCubit, UnitDataState>(
                  buildWhen: (prev, curr) =>
                      prev.allocationContractFilePath !=
                      curr.allocationContractFilePath,
                  builder: (context, state) => FileUploadField(
                    labelText: 'سند الإنتفاع أو الإستغلال',
                    text: 'حمل ملف',
                    backgroundColor: AppColors.highlightDarkest,
                    textColor: AppColors.white,
                    filePath: state.allocationContractFilePath,
                    onFilePicked: () async {
                      final path = await cubit.pickFile();
                      if (path != null) cubit.setAllocationContractFile(path);
                    },
                    onFileRemoved: () => cubit.removeAllocationContractFile(),
                  ),
                ),
                16.hs,

                // ── مستندات داعمة أخرى (supporting_documents) ──────────
                const AdditionalDocumentsSection(title: 'مستندات داعمة أخرى'),
                16.hs,
              ],
            ),
          ),
        );
      },
    );
  }
}
