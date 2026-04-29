import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reta/features/components/app_button.dart';
import 'package:reta/features/components/app_check_box.dart';

import '../../../../../../core/helpers/extensions/dimensions.dart';
import '../../../../../../core/helpers/fixed_assets.dart';
import '../../../../../../core/theme/app_colors.dart';
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          AppTextFormField(
            labelText: 'أسم المنشأة',
            labelRequired: true,
            controller: cubit.facilityNameController,
            hintText: 'ادخل أسم المنشأة',
            validator: (v) => v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
          ),
          16.hs,

          AppTextFormField(
            labelText: 'نوع النشاط',
            labelRequired: true,
            controller: cubit.activityTypeController,
            hintText: 'ادخل نوع النشاط',
            validator: (v) => v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
          ),
          16.hs,

          AppTextFormField(
            labelText: 'مساحة الأرض الكلية',
            labelRequired: true,
            controller: cubit.totalLandAreaFacilityController,
            hintText: 'المساحة الإجمالية بالمتر المربع',
            keyboardType: TextInputType.number,
            validator: (v) => v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
          ),
          16.hs,

          AppTextFormField(
            labelText: 'مساحة الأرض المستغلة',
            labelRequired: true,
            controller: cubit.exploitedLandAreaController,
            hintText: 'المساحة الإجمالية بالمتر المربع',
            keyboardType: TextInputType.number,
            validator: (v) {
              if (v == null || v.isEmpty) return 'هذا الحقل مطلوب';

              final total = double.tryParse(
                cubit.totalLandAreaFacilityController.text,
              );
              final exploited = double.tryParse(v);

              if (exploited == null) return 'يرجى إدخال رقم صحيح';
              if (total != null && exploited > total) {
                return 'يجب أن تكون المساحة المستغلة أصغر من أو تساوي المساحة الكلية';
              }

              return null;
            },
          ),
          16.hs,

          AppTextFormField(
            labelText: 'القيمة السوقية للأرض',
            controller: cubit.landMarketValueController,
            hintText: 'ادخل القيمة السوقية للأرض',
            keyboardType: TextInputType.number,
          ),
          16.hs,

          TitleWithDivider(title: 'وصف المباني'),
          12.hs,

          BlocBuilder<UnitDataCubit, UnitDataState>(
            buildWhen: (prev, curr) =>
                prev.industrialBuildingsCount != curr.industrialBuildingsCount,
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
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

          const TaxContactSection(
            customLabel:
                'هل تم التواصل مع الضرائب العقارية بخصوص المنشأة محل الإقرار سابقاً؟',
          ),
          16.hs,

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

          BlocBuilder<UnitDataCubit, UnitDataState>(
            buildWhen: (prev, curr) =>
                prev.constructionLicenseFullUrl !=
                curr.constructionLicenseFullUrl,
            builder: (context, state) {
              print(
                "MSG: UI: constructionLicenseFullUrl: ${state.constructionLicenseFilePath}",
              );
              return FileUploadField(
                labelText: 'صورة من التراخيص الإنشائية',
                text: 'حمل ملف',
                backgroundColor: AppColors.highlightDarkest,
                textColor: AppColors.white,
                filePath: state.constructionLicenseFullUrl,
                onFilePicked: () async {
                  final path = await cubit.pickFile();
                  if (path != null) cubit.setConstructionLicenseFile(path);
                },
                onFileRemoved: () => cubit.removeConstructionLicenseFile(),
              );
            },
          ),
          16.hs,

          BlocBuilder<UnitDataCubit, UnitDataState>(
            buildWhen: (prev, curr) =>
                prev.operatingLicenseFullUrl != curr.operatingLicenseFullUrl,
            builder: (context, state) => FileUploadField(
              labelText: 'صورة من ترخيص التشغيل',
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

          BlocBuilder<UnitDataCubit, UnitDataState>(
            buildWhen: (prev, curr) =>
                prev.allocationContractFullUrl !=
                curr.allocationContractFullUrl,
            builder: (context, state) => FileUploadField(
              labelText: 'صورة من عقد التخصيص',
              text: 'حمل ملف',
              backgroundColor: AppColors.highlightDarkest,
              textColor: AppColors.white,
              filePath: state.allocationContractFullUrl,
              onFilePicked: () async {
                final path = await cubit.pickFile();
                if (path != null) cubit.setAllocationContractFile(path);
              },
              onFileRemoved: () => cubit.removeAllocationContractFile(),
            ),
          ),
          16.hs,

          const AdditionalDocumentsSection(),
        ],
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

          AppTextFormField(
            labelText: 'المساحة الإجمالية للمبنى',
            labelRequired: true,
            controller: widget.building.totalArea,
            hintText: 'المساحة الإجمالية بالمتر المربع',
            keyboardType: TextInputType.number,
            validator: (v) => v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
          ),
          15.hs,

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
                locale: const Locale('en'),
              );
              if (picked != null) {
                setState(() {
                  widget.building.constructionDate.text =
                      '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
                });
              }
            },
            suffixWidget: CalendarIcon(color: AppColors.neutralDarkLightest),
            validator: (v) => v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
          ),
          15.hs,

          AppTextFormField(
            labelText: 'القيمة السوقية للمبنى',
            controller: widget.building.marketValue,
            hintText: 'ادخل القيمة السوقية للمبنى',
            keyboardType: TextInputType.number,
          ),
          15.hs,

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
