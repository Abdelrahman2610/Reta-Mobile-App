// lib/features/declarations/presentations/pages/units/units_data_pages/industrial_facility_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reta/features/components/app_button.dart';
import 'package:reta/features/components/app_check_box.dart';

import '../../../../../../core/helpers/extensions/dimensions.dart';
import '../../../../../../core/helpers/fixed_assets.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../components/app_container.dart';
import '../../../../../components/app_text.dart';
import '../../../../../components/app_text_form_field.dart';
import '../../../../../components/image_svg_custom_widget.dart';
import '../../../../data/models/industrial_building.dart';
import '../../../components/app_drop_down.dart';
import '../../../components/app_drop_down_option.dart';
import '../../../cubit/units/unit_data/unit_data_cubit.dart';
import '../../../cubit/units/unit_data/unit_data_state.dart';
import 'components/additional_documents_section.dart';
import 'components/app_counter.dart';
import 'components/calendar_icon.dart';
import 'components/file_upload_field.dart';
import 'components/tax_contact_section.dart';
import 'components/title_with_divider.dart';

class IndustrialFacilityPage extends StatelessWidget {
  const IndustrialFacilityPage({super.key, required this.unitCubit});
  final UnitDataCubit unitCubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: unitCubit,
      child: const _IndustrialFacilityView(),
    );
  }
}

class _IndustrialFacilityView extends StatelessWidget {
  const _IndustrialFacilityView();

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
              text: 'بيانات المنشأة الصناعية',
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.mainBlueIndigoDye,
            ),
            24.hs,

            // ── اسم المنشأة (facility_name) ────────
            AppTextFormField(
              labelText: 'أسم المنشأة',
              labelRequired: true,
              controller: cubit.facilityNameController,
              hintText: 'ادخل أسم المنشأة',
              validator: (v) =>
                  v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
            ),
            16.hs,

            // ── نوع النشاط (activity_type) ─────────
            AppTextFormField(
              labelText: 'نوع النشاط',
              labelRequired: true,
              controller: cubit.activityTypeController,
              hintText: 'ادخل نوع النشاط',
              validator: (v) =>
                  v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
            ),
            16.hs,

            // ── مساحة الأرض الكلية (total_land_area) ─
            AppTextFormField(
              labelText: 'مساحة الأرض الكلية',
              labelRequired: true,
              controller: cubit.totalLandAreaFacilityController,
              hintText: 'المساحة الإجمالية بالمتر المربع',
              keyboardType: TextInputType.number,
              validator: (v) =>
                  v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
            ),
            16.hs,

            // ── مساحة الأرض المستغلة (used_land_area) ─
            AppTextFormField(
              labelText: 'مساحة الأرض المستغلة',
              labelRequired: true,
              controller: cubit.exploitedLandAreaController,
              hintText: 'المساحة الإجمالية بالمتر المربع',
              keyboardType: TextInputType.number,
              validator: (v) =>
                  v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
            ),
            16.hs,

            // ── القيمة السوقية للأرض (market_value) ─
            AppTextFormField(
              labelText: 'القيمة السوقية للأرض',
              controller: cubit.landMarketValueController,
              hintText: 'ادخل القيمة السوقية للأرض',
              keyboardType: TextInputType.number,
            ),
            16.hs,

            // ── وصف المباني ───────────────────────
            TitleWithDivider(title: 'وصف المباني'),
            12.hs,

            // ── قائمة المباني (من cubit.industrialBuildings) ─────────
            BlocBuilder<UnitDataCubit, UnitDataState>(
              buildWhen: (prev, curr) =>
                  prev.industrialBuildingsCount !=
                  curr.industrialBuildingsCount,
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // عدد المباني counter
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
                          count: cubit.industrialBuildings.length,
                          onDecrement: () => cubit.removeIndustrialBuilding(
                            cubit.industrialBuildings.length - 1,
                          ),
                          onIncrement: cubit.addIndustrialBuilding,
                        ),
                      ],
                    ),
                    12.hs,

                    // قائمة المباني
                    ...cubit.industrialBuildings.asMap().entries.map(
                      (e) => _BuildingItem(
                        index: e.key,
                        building: e.value,
                        cubit: cubit,
                        isLast: e.key == cubit.industrialBuildings.length - 1,
                        canDelete: cubit.industrialBuildings.length > 1,
                      ),
                    ),
                  ],
                );
              },
            ),
            16.hs,

            // ── هل تم التواصل مع الضرائب؟ ─────────
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

            // ── تحمل على وزارة المالية (ministry_burden) ─
            BlocBuilder<UnitDataCubit, UnitDataState>(
              buildWhen: (prev, curr) =>
                  prev.ministryBurden != curr.ministryBurden ||
                  prev.selectedBurdenActivity != curr.selectedBurdenActivity,
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        AppCheckBox(
                          isSelected: state.ministryBurden ?? false,
                          onTap: cubit.toggleMinistryBurden,
                        ),
                        12.ws,
                        AppText(
                          text: 'تحمل على وزارة المالية؟',
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.neutralDarkDark,
                        ),
                      ],
                    ),

                    // ── النشاط المستفاد (burden_activity_id) ─
                    if (state.ministryBurden == true) ...[
                      16.hs,
                      AppDropdownField<String>(
                        labelText: 'النشاط المستفاد من التحمل',
                        labelRequired: true,
                        hintText: 'اختر النشاط',
                        value: state.selectedBurdenActivity,
                        items: cubit.lookups.burdenActivityTypes
                            .map((b) => appDropDownOption(label: b.name))
                            .toList(),
                        onChanged: cubit.selectBurdenActivity,
                        validator: (v) => v == null ? 'هذا الحقل مطلوب' : null,
                      ),
                    ],
                  ],
                );
              },
            ),
            16.hs,

            // ── صورة من التراخيص الإنشائية (construction_license) ─
            BlocBuilder<UnitDataCubit, UnitDataState>(
              buildWhen: (prev, curr) =>
                  prev.constructionLicenseFilePath !=
                  curr.constructionLicenseFilePath,
              builder: (context, state) => FileUploadField(
                labelText: 'صورة من التراخيص الإنشائية',
                text: 'حمل ملف',
                backgroundColor: AppColors.highlightDarkest,
                textColor: AppColors.white,
                filePath: state.constructionLicenseFilePath,
                onFilePicked: () async {
                  final path = await cubit.pickFile();
                  if (path != null) cubit.setConstructionLicenseFile(path);
                },
                onFileRemoved: () => cubit.removeConstructionLicenseFile(),
              ),
            ),
            16.hs,

            // ── صورة من ترخيص التشغيل (operation_license) ─────────
            BlocBuilder<UnitDataCubit, UnitDataState>(
              buildWhen: (prev, curr) =>
                  prev.operatingLicenseFilePath !=
                  curr.operatingLicenseFilePath,
              builder: (context, state) => FileUploadField(
                labelText: 'صورة من ترخيص التشغيل',
                text: 'حمل ملف',
                backgroundColor: AppColors.highlightDarkest,
                textColor: AppColors.white,
                filePath: state.operatingLicenseFilePath,
                onFilePicked: () async {
                  final path = await cubit.pickFile();
                  if (path != null) cubit.setOperatingLicenseFile(path);
                },
                onFileRemoved: () => cubit.removeOperatingLicenseFile(),
              ),
            ),
            16.hs,

            // ── صورة من عقد التخصيص (allocation_contract) ──────────
            BlocBuilder<UnitDataCubit, UnitDataState>(
              buildWhen: (prev, curr) =>
                  prev.allocationContractFilePath !=
                  curr.allocationContractFilePath,
              builder: (context, state) => FileUploadField(
                labelText: 'صورة من عقد التخصيص',
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

            // ── مستندات داعمة أخرى ─────────────────
            const AdditionalDocumentsSection(title: 'مستندات داعمة أخرى'),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// Building Item Widget
// ─────────────────────────────────────────

class _BuildingItem extends StatefulWidget {
  const _BuildingItem({
    required this.index,
    required this.building,
    required this.cubit,
    required this.isLast,
    required this.canDelete,
  });

  final int index;
  final IndustrialBuilding building;
  final UnitDataCubit cubit;
  final bool isLast;
  final bool canDelete;

  @override
  State<_BuildingItem> createState() => _BuildingItemState();
}

class _BuildingItemState extends State<_BuildingItem> {
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
          TitleWithDivider(
            title: 'مبنى (${widget.index + 1})',
            fontSize: 14.sp,
          ),
          15.hs,

          // ── نوع المبنى (building_type_id) ──────
          AppDropdownField<String>(
            labelText: 'نوع المبنى',
            labelRequired: true,
            hintText: 'اختر نوع المبنى',
            value: widget.building.buildingType,
            items: widget.cubit.lookups.buildingTypes
                .map((b) => appDropDownOption(label: b.name))
                .toList(),
            onChanged: (v) => setState(() => widget.building.buildingType = v),
            validator: (v) => v == null ? 'هذا الحقل مطلوب' : null,
          ),
          16.hs,

          // ── عدد الأدوار (floors_count) ─────────
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

          // ── المساحة الإجمالية للمبنى (total_area) ─
          AppTextFormField(
            labelText: 'المساحة الإجمالية للمبنى',
            labelRequired: true,
            controller: widget.building.totalArea,
            hintText: 'المساحة الإجمالية بالمتر المربع',
            keyboardType: TextInputType.number,
            validator: (v) => v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
          ),
          15.hs,

          // ── تاريخ الإنشاء للمبنى (construction_date) ─
          AppTextFormField(
            labelText: 'تاريخ الإنشاء للمبنى',
            labelRequired: true,
            controller: widget.building.constructionDate,
            hintText: 'ادخل تاريخ الإنشاء للمبنى',
            readOnly: true,
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                setState(() {
                  widget.building.constructionDate.text =
                      '${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}';
                });
              }
            },
            suffixWidget: CalendarIcon(color: AppColors.neutralDarkLightest),
            validator: (v) => v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
          ),
          15.hs,

          // ── القيمة السوقية للمبنى (market_value) ─
          AppTextFormField(
            labelText: 'القيمة السوقية للمبنى',
            controller: widget.building.marketValue,
            hintText: 'ادخل القيمة السوقية للمبنى',
            keyboardType: TextInputType.number,
          ),
          15.hs,

          // ── زرار إضافة + حذف ──────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (widget.isLast)
                Expanded(
                  child: AppButton(
                    label: 'إضافة مبنى',
                    backgroundColor: AppColors.highlightDarkest,
                    icon: Icon(Icons.add, color: AppColors.white),
                    iconLeft: false,
                    onTap: widget.cubit.addIndustrialBuilding,
                    fontWeight: FontWeight.w600,
                  ),
                )
              else
                const SizedBox.shrink(),
              if (widget.isLast && widget.canDelete) 15.ws,
              if (widget.canDelete)
                GestureDetector(
                  onTap: () =>
                      widget.cubit.removeIndustrialBuilding(widget.index),
                  child: ImageSvgCustomWidget(
                    imgPath: FixedAssets.instance.deleteIC,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
