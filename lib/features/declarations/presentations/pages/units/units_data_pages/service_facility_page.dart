import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/helpers/extensions/dimensions.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../components/app_container.dart';
import '../../../../../components/app_text.dart';
import '../../../../../components/app_text_form_field.dart';
import '../../../../data/models/building_info.dart';
import '../../../cubit/units/unit_data/unit_data_cubit.dart';
import '../../../cubit/units/unit_data/unit_data_state.dart';
import 'components/additional_documents_section.dart';
import 'components/app_counter.dart';
import 'components/exemption_section.dart';
import 'components/file_upload_field.dart';
import 'components/tax_contact_section.dart';
import 'components/title_with_divider.dart';
import 'components/units_add_delete_buttons.dart';

class ServiceFacilityPage extends StatelessWidget {
  const ServiceFacilityPage({super.key, required this.unitCubit});
  final UnitDataCubit unitCubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: unitCubit,
      child: const _ServiceFacilityView(),
    );
  }
}

class _ServiceFacilityView extends StatelessWidget {
  const _ServiceFacilityView();

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
              text: 'بيانات المنشأة الخدمية',
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.mainBlueIndigoDye,
            ),
            24.hs,

            // ── اسم المنشأة ──────────────────────────
            AppTextFormField(
              labelText: 'إسم المنشأة',
              labelRequired: true,
              controller: cubit.facilityNameController,
              hintText: 'المساحة بالمتر المربع',
              validator: (v) =>
                  v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
            ),
            16.hs,

            // ── مساحة الأرض الكلية ──────────────────
            AppTextFormField(
              labelText: 'مساحة الأرض الكلية',
              labelRequired: true,
              controller: cubit.totalLandAreaFacilityController,
              hintText: 'المساحة بالمتر المربع',
              keyboardType: TextInputType.number,
              validator: (v) =>
                  v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
            ),
            16.hs,

            // ── المباني ──────────────────────────────
            _BuildingsSection(cubit: cubit),
            16.hs,

            // ── نوع النشاط ───────────────────────────
            AppTextFormField(
              labelText: 'نوع النشاط',
              labelRequired: true,
              controller: cubit.activityTypeController,
              hintText: 'ادخل نوع النشاط',
              validator: (v) =>
                  v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
            ),
            16.hs,

            // ── هل تم التواصل مع الضرائب؟ ───────────
            const TaxContactSection(
              customLabel:
                  'هل تم التواصل مع الضرائب العقارية بخصوص المنشأة محل الإقرار سابقاً؟',
            ),
            16.hs,

            // ── كود حساب المنشأة ─────────────────────
            BlocBuilder<UnitDataCubit, UnitDataState>(
              buildWhen: (prev, curr) =>
                  prev.contactedTaxAuthority != curr.contactedTaxAuthority,
              builder: (context, state) {
                return (state.contactedTaxAuthority ?? false)
                    ? Column(
                        children: [
                          AppTextFormField(
                            labelText: 'كود حساب الوحدة',
                            controller: cubit.unitCodeController,
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
                      )
                    : SizedBox.shrink();
              },
            ),

            // ── هل الوحدة معفاة؟ ─────────────────────
            const ExemptionSection(isWithInfo: true),
            16.hs,

            // ── القيمة السوقية للمنشأة ────────────────
            AppTextFormField(
              labelText: 'القيمة السوقية للمنشأة',
              controller: cubit.marketValueController,
              hintText: 'ادخل القيمة السوقية للمنشأة',
              keyboardType: TextInputType.number,
            ),
            16.hs,

            // ── سند ملكية المنشأة ─────────────────────
            BlocBuilder<UnitDataCubit, UnitDataState>(
              buildWhen: (prev, curr) =>
                  prev.ownershipDeedFilePath != curr.ownershipDeedFilePath,
              builder: (context, state) => FileUploadField(
                labelText: 'سند ملكية المنشأة',
                text: 'حمل ملف',
                backgroundColor: AppColors.highlightDarkest,
                textColor: AppColors.white,
                filePath: state.ownershipDeedFullUrl,
                onFilePicked: () async {
                  final path = await cubit.pickFile();
                  if (path != null) cubit.setOwnershipDeedFile(path);
                },
                onFileRemoved: () => cubit.removeOwnershipDeedFile(),
              ),
            ),
            16.hs,

            // ── صورة من عقود الإيجار ─────────────────
            BlocBuilder<UnitDataCubit, UnitDataState>(
              buildWhen: (prev, curr) =>
                  prev.leaseContractFilePath != curr.leaseContractFilePath,
              builder: (context, state) => FileUploadField(
                labelText: 'صورة من عقود الإيجار',
                text: 'حمل ملف',
                backgroundColor: AppColors.highlightDarkest,
                textColor: AppColors.white,
                filePath: state.leaseContractFullUrl,
                onFilePicked: () async {
                  final path = await cubit.pickFile();
                  if (path != null) cubit.setLeaseContractFile(path);
                },
                onFileRemoved: () => cubit.removeLeaseContractFile(),
              ),
            ),
            16.hs,

            // ── صورة من تراخيص البناء ────────────────
            BlocBuilder<UnitDataCubit, UnitDataState>(
              buildWhen: (prev, curr) =>
                  prev.constructionLicenseFilePath !=
                  curr.constructionLicenseFilePath,
              builder: (context, state) => FileUploadField(
                labelText: 'صورة من تراخيص البناء',
                text: 'حمل ملف',
                backgroundColor: AppColors.highlightDarkest,
                textColor: AppColors.white,
                filePath: state.constructionLicenseFullUrl,
                onFilePicked: () async {
                  final path = await cubit.pickFile();
                  if (path != null) cubit.setConstructionLicenseFile(path);
                },
                onFileRemoved: () => cubit.removeConstructionLicenseFile(),
              ),
            ),
            16.hs,

            // ── صورة من تراخيص التشغيل ───────────────
            BlocBuilder<UnitDataCubit, UnitDataState>(
              buildWhen: (prev, curr) =>
                  prev.operatingLicenseFilePath !=
                  curr.operatingLicenseFilePath,
              builder: (context, state) => FileUploadField(
                labelText: 'صورة من تراخيص التشغيل',
                text: 'حمل ملف',
                backgroundColor: AppColors.highlightDarkest,
                textColor: AppColors.white,
                filePath: state.operatingLicenseFullUrl,
                onFilePicked: () async {
                  final path = await cubit.pickFile();
                  if (path != null) cubit.setOperatingLicenseFile(path);
                },
                onFileRemoved: () => cubit.removeOperatingLicenseFile(),
              ),
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
// Buildings Section
// ─────────────────────────────────────────
class _BuildingsSection extends StatelessWidget {
  const _BuildingsSection({required this.cubit});
  final UnitDataCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UnitDataCubit, UnitDataState>(
      buildWhen: (prev, curr) => prev.buildingsCount != curr.buildingsCount,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // --- divider + title ------------------
            TitleWithDivider(title: 'المباني المضافة داخل المنشأة'),
            12.hs,

            // --- عدد المباني counter ------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AppText(
                  text: 'عدد المباني',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.neutralDarkDark,
                ),
                AppText(
                  text: ' *',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.errorDark,
                ),
                const Spacer(),
                AppCounter(
                  count: cubit.buildings.length,
                  onDecrement: () =>
                      cubit.decrementBuildings(cubit.buildings.length - 1),
                  onIncrement: cubit.incrementBuildings,
                ),
              ],
            ),
            12.hs,

            // --- قائمة المباني ------------------
            ...cubit.buildings.asMap().entries.map((entry) {
              return _BuildingItemWidget(
                index: entry.key,
                building: entry.value,
                cubit: cubit,
                isLast: entry.key == cubit.buildings.length - 1,
                canDelete: cubit.buildings.length > 1,
              );
            }),

            // ---- إجمالي مساحة المباني ------------------
            12.hs,
            AppTextFormField(
              labelText: 'إجمالي مساحة المباني',
              controller: cubit.totalBuildingAreaController,
              enabled: false,
              filledColor: AppColors.neutralLightLight,
              hintText: 'يُحسب تلقائياً',
            ),
          ],
        );
      },
    );
  }
}

// ─────────────────────────────────────────
// Building Item Widget
// ─────────────────────────────────────────
class _BuildingItemWidget extends StatefulWidget {
  const _BuildingItemWidget({
    required this.index,
    required this.building,
    required this.cubit,
    required this.isLast,
    required this.canDelete,
  });

  final int index;
  final BuildingInfo building;
  final UnitDataCubit cubit;
  final bool isLast;
  final bool canDelete;

  @override
  State<_BuildingItemWidget> createState() => _BuildingItemWidgetState();
}

class _BuildingItemWidgetState extends State<_BuildingItemWidget> {
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
          10.hs, // Building number
          TitleWithDivider(
            title: 'مبنى (${widget.index + 1})',
            fontSize: 14.sp,
          ),
          15.hs,
          // Floor count
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AppText(
                text: 'عدد الأدوار',
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.neutralDarkDark,
              ),
              AppText(
                text: ' *',
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.errorDark,
              ),
              const Spacer(),
              AppCounter(
                count: widget.building.floorsCount,
                onDecrement: () {
                  if (widget.building.floorsCount > 1) {
                    setState(() => widget.building.floorsCount--);
                  }
                },
                onIncrement: () =>
                    setState(() => widget.building.floorsCount++),
              ),
            ],
          ),
          16.hs,

          // --- مساحة المبنى ------------------
          AppTextFormField(
            labelText: 'مساحة المبنى',
            labelRequired: true,
            controller: widget.building.areaController,
            hintText: 'المساحة بالمتر المربع',
            keyboardType: TextInputType.number,
            onChanged: (_) {
              widget.cubit.updateBuildingArea();
              setState(() {});
            },
            validator: (v) => v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
          ),
          15.hs,

          // --- زرار إضافة + حذف ------------------
          UnitsAddDeleteButtons(
            onAddTapped: widget.cubit.incrementBuildings,
            onDeleteTapped: () => widget.cubit.decrementBuildings(widget.index),
            isLast: widget.isLast,
            canDelete: widget.canDelete,
          ),
        ],
      ),
    );
  }
}
