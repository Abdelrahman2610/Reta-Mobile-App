import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/helpers/extensions/dimensions.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../components/app_container.dart';
import '../../../../../components/app_text.dart';
import '../../../../../components/app_text_form_field.dart';
import '../../../../data/models/vacant_land_item.dart';
import '../../../components/app_drop_down.dart';
import '../../../components/app_drop_down_option.dart';
import '../../../cubit/units/unit_data/unit_data_cubit.dart';
import '../../../cubit/units/unit_data/unit_data_state.dart';
import 'components/additional_documents_section.dart';
import 'components/file_upload_field.dart';
import 'components/units_add_delete_buttons.dart';

class VacantLandPage extends StatelessWidget {
  const VacantLandPage({super.key, required this.unitCubit});
  final UnitDataCubit unitCubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(value: unitCubit, child: const _VacantLandView());
  }
}

class _VacantLandView extends StatelessWidget {
  const _VacantLandView();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UnitDataCubit>();

    return Form(
      key: cubit.formKey,
      child: AppContainer(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            AppText(
              text: 'بيانات الأرض الفضاء المستغلة',
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.mainBlueIndigoDye,
            ),
            24.hs,

            // ── مساحة الأرض الكلية ──────────────────
            AppTextFormField(
              labelText: 'مساحة الأرض الكلية',
              labelRequired: true,
              controller: cubit.totalLandAreaController,
              hintText: 'المساحة بالمتر المربع',
              keyboardType: TextInputType.number,
              validator: (v) =>
                  v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
            ),
            16.hs,

            // ── وصف الاستغلال ────────────────────────
            AppText(
              text: 'وصف الإستغلال',
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.mainBlueIndigoDye,
            ),
            12.hs,

            // ── قائمة الاستغلالات ─────────────────────
            BlocBuilder<UnitDataCubit, UnitDataState>(
              buildWhen: (prev, curr) =>
                  prev.vacantLandItems != curr.vacantLandItems,
              builder: (context, state) {
                return Column(
                  children: [
                    ...state.vacantLandItems.asMap().entries.map((entry) {
                      return _VacantLandItemWidget(
                        index: entry.key,
                        item: entry.value,
                        cubit: cubit,
                        canDelete: state.vacantLandItems.length > 1,
                        vacantLandItemsLength: state.vacantLandItems.length,
                      );
                    }),
                    12.hs,
                  ],
                );
              },
            ),
            16.hs,

            // ── سند ملكية الأرض ───────────────────────
            BlocBuilder<UnitDataCubit, UnitDataState>(
              buildWhen: (prev, curr) =>
                  prev.ownershipDeedFullUrl != curr.ownershipDeedFullUrl,
              builder: (context, state) {
                return FileUploadField(
                  labelText: 'سند ملكية الأرض',
                  text: 'حمل ملف',
                  description: 'عقد مسجل/عقد ابتدائي/حكم قضائي/مستند رسمي',
                  backgroundColor: AppColors.highlightDarkest,
                  textColor: AppColors.white,
                  filePath: state.ownershipDeedFullUrl,
                  onFilePicked: () async {
                    final path = await cubit.pickFile();
                    if (path != null) cubit.setOwnershipDeedFile(path);
                  },
                  onFileRemoved: () => cubit.removeOwnershipDeedFile(),
                );
              },
            ),
            16.hs,

            // ── عقد الإيجار (إن وجد) ─────────────────
            BlocBuilder<UnitDataCubit, UnitDataState>(
              buildWhen: (prev, curr) =>
                  prev.leaseContractFilePath != curr.leaseContractFilePath,
              builder: (context, state) {
                return FileUploadField(
                  labelText: 'عقد الإيجار (إن وجد)',
                  text: 'حمل ملف',
                  backgroundColor: AppColors.highlightDarkest,
                  textColor: AppColors.white,
                  filePath: state.leaseContractFullUrl,
                  onFilePicked: () async {
                    final path = await cubit.pickFile();
                    if (path != null) cubit.setLeaseContractFile(path);
                  },
                  onFileRemoved: () => cubit.removeLeaseContractFile(),
                );
              },
            ),
            16.hs,

            // ── مستندات داعمة أخرى ───────────────────
            const AdditionalDocumentsSection(),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// Vacant Land Item Widget
// ─────────────────────────────────────────
class _VacantLandItemWidget extends StatelessWidget {
  const _VacantLandItemWidget({
    required this.index,
    required this.item,
    required this.cubit,
    required this.canDelete,
    required this.vacantLandItemsLength,
  });

  final int index;
  final VacantLandItem item;
  final UnitDataCubit cubit;
  final bool canDelete;
  final int vacantLandItemsLength;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.neutralLightLight,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // ── المساحة المستغلة ───────────────────
          AppTextFormField(
            labelText: 'المساحة المستغلة',
            labelRequired: true,
            controller: item.usedLandAreaController,
            hintText: 'المساحة بالمتر المربع',
            keyboardType: TextInputType.number,
            validator: (v) => v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
          ),
          16.hs,

          // ── نوع الاستغلال ──────────────────────
          BlocBuilder<UnitDataCubit, UnitDataState>(
            buildWhen: (prev, curr) =>
                prev.vacantLandItems != curr.vacantLandItems,
            builder: (context, state) {
              final currentItem = state.vacantLandItems.firstWhere(
                (i) => i.id == item.id,
                orElse: () => item,
              );
              return AppDropdownField<String>(
                labelText: 'نوع الاستغلال',
                labelRequired: true,
                hintText: 'اختر نوع الاستغلال',
                value: currentItem.selectedExploitationType,
                items: cubit.lookups.exploitationTypes
                    .map((t) => appDropDownOption(label: t.name))
                    .toList(),
                onChanged: (value) =>
                    cubit.selectVacantLandItemExploitationType(item.id, value),
                validator: (v) => v == null ? 'هذا الحقل مطلوب' : null,
              );
            },
          ),

          // ── نوع الاستغلال الآخر ────────────────
          BlocBuilder<UnitDataCubit, UnitDataState>(
            buildWhen: (prev, curr) =>
                prev.vacantLandItems != curr.vacantLandItems,
            builder: (context, state) {
              final currentItem = state.vacantLandItems.firstWhere(
                (i) => i.id == item.id,
                orElse: () => item,
              );
              if (currentItem.selectedExploitationType != 'أخرى') {
                return const SizedBox.shrink();
              }
              return Column(
                children: [
                  16.hs,
                  AppTextFormField(
                    labelText: 'نوع الإستغلال الآخر',
                    labelRequired: true,
                    controller: item.otherExploitationTypeController,
                    hintText: 'إدخال نوع الإستغلال الآخر',
                    validator: (v) =>
                        v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
                  ),
                ],
              );
            },
          ),
          16.hs,

          // ── هل تم التواصل مع الضرائب؟ ──────────
          BlocBuilder<UnitDataCubit, UnitDataState>(
            buildWhen: (prev, curr) =>
                prev.vacantLandItems != curr.vacantLandItems,
            builder: (context, state) {
              final currentItem = state.vacantLandItems.firstWhere(
                (i) => i.id == item.id,
                orElse: () => item,
              );
              return Column(
                children: [
                  AppDropdownField<String>(
                    labelText: 'هل تم التواصل مع الضرائب العقارية بخصوص الأرض؟',
                    labelRequired: true,
                    hintText: 'اختر',
                    value: currentItem.retaContactAboutUnit ? 'نعم' : 'لا',
                    items: [
                      'نعم',
                      'لا',
                    ].map((o) => appDropDownOption(label: o)).toList(),
                    onChanged: (value) => cubit.setVacantLandItemRetaContact(
                      item.id,
                      value == 'نعم',
                    ),
                    validator: (v) => v == null ? 'هذا الحقل مطلوب' : null,
                  ),
                  16.hs,

                  // ── كود حساب الوحدة ───────────────────
                  if (currentItem.retaContactAboutUnit)
                    Column(
                      children: [
                        AppTextFormField(
                          labelText: 'كود حساب الوحدة',
                          controller: item.accountCodeController,
                          hintText: 'ادخل كود حساب الوحدة',
                          keyboardType: TextInputType.number,
                          validator: (v) {
                            if (v == null || v.isEmpty) return null;
                            if (v.length != 14) return 'يجب أن يكون 14 رقماً';
                            if (!RegExp(r'^\d+$').hasMatch(v)) {
                              return 'يجب أن يحتوي على أرقام فقط';
                            }
                            return null;
                          },
                        ),
                        16.hs,
                      ],
                    ),
                ],
              );
            },
          ),

          // ── القيمة السوقية ──────────────────────
          AppTextFormField(
            labelText: 'القيمة السوقية',
            controller: item.marketValueController,
            hintText: 'ادخل القيمة السوقية',
            keyboardType: TextInputType.number,
          ),

          15.hs,
          // ── زرار إضافة استغلال ──────────────
          UnitsAddDeleteButtons(
            onAddTapped: cubit.addVacantLandItem,
            onDeleteTapped: () => cubit.removeVacantLandItem(item.id),
            isLast: index == vacantLandItemsLength - 1,
            canDelete: canDelete,
          ),
          15.hs,
        ],
      ),
    );
  }
}
