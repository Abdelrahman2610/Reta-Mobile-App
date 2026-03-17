import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reta/features/declarations/data/models/production_building.dart';

import '../../../../../../core/helpers/extensions/dimensions.dart';
import '../../../../../../core/helpers/fixed_assets.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../components/app_button.dart';
import '../../../../../components/app_check_box.dart';
import '../../../../../components/app_container.dart';
import '../../../../../components/app_text.dart';
import '../../../../../components/app_text_form_field.dart';
import '../../../../../components/image_svg_custom_widget.dart';
import '../../../components/app_drop_down.dart';
import '../../../components/app_drop_down_option.dart';
import '../../../cubit/units/unit_data/unit_data_cubit.dart';
import '../../../cubit/units/unit_data/unit_data_state.dart';
import 'components/additional_documents_section.dart';
import 'components/app_counter.dart';
import 'components/file_upload_field.dart';
import 'components/tax_contact_section.dart';
import 'components/title_with_divider.dart';

class ProductionFacilityUnitPage extends StatelessWidget {
  const ProductionFacilityUnitPage({super.key, required this.unitCubit});

  final UnitDataCubit unitCubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: unitCubit,
      child: const _ProductionFacilityUnitView(),
    );
  }
}

class _ProductionFacilityUnitView extends StatelessWidget {
  const _ProductionFacilityUnitView();

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
              text: 'بيانات المنشأة الإنتاجية',
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.mainBlueIndigoDye,
            ),
            24.hs,

            AppTextFormField(
              labelText: 'أسم المنشأة',
              labelRequired: true,
              controller: cubit.productionFacilityNameController,
              hintText: 'ادخل أسم المنشأة',
              validator: (v) =>
                  v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
            ),
            16.hs,
            AppTextFormField(
              labelText: 'نوع النشاط',
              labelRequired: true,
              controller: cubit.productionUsageTypeController,
              hintText: 'ادخل نوع النشاط',
              validator: (v) =>
                  v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
            ),
            16.hs,
            AppTextFormField(
              labelText: 'مساحة الأرض الكلية',
              labelRequired: true,
              controller: cubit.totalLandArea,
              keyboardType: TextInputType.number,
              hintText: 'المساحة الإجمالية بالمتر المربع',
              validator: (v) =>
                  v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
            ),
            16.hs,
            AppTextFormField(
              labelText: 'مساحة الأرض المستغلة',
              labelRequired: true,
              controller: cubit.totalLandUtilized,
              keyboardType: TextInputType.number,
              hintText: 'المساحة الإجمالية بالمتر المربع',
              validator: (v) =>
                  v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
            ),
            16.hs,
            AppTextFormField(
              labelText: 'القيمة السوقية للأرض',
              labelRequired: false,
              controller: cubit.bookValueController,
              keyboardType: TextInputType.number,
              hintText: 'إدخل القيمة السوقية للأرض',
            ),
            16.hs,
            TitleWithDivider(
              // title: 'ملحقات الفندق - وحدة (${widget.index + 1})',
              title: 'وصف المباني',
              fontSize: 16.sp,
            ),
            16.hs,

            // ── عدد المباني (buildings_count) ──────
            BlocBuilder<UnitDataCubit, UnitDataState>(
              buildWhen: (prev, curr) =>
                  prev.productionBuildingsCount !=
                  curr.productionBuildingsCount,
              builder: (context, state) => Column(
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
                        count: cubit.productionBuildings.length,
                        onDecrement: () => cubit.removeProductionBuilding(
                          cubit.productionBuildings.length - 1,
                        ),
                        onIncrement: cubit.addProductionBuilding,
                      ),
                    ],
                  ),

                  12.hs,

                  ...cubit.productionBuildings.asMap().entries.map(
                    (e) => _BuildingItem(
                      index: e.key,
                      building: e.value,
                      cubit: cubit,
                      isLast: e.key == cubit.productionBuildings.length - 1,
                      canDelete: cubit.productionBuildings.length > 1,
                    ),
                  ),
                ],
              ),
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
              buildWhen: (prev, curr) => prev.isExempt != curr.isExempt,
              builder: (context, state) {
                return Column(
                  children: [
                    GestureDetector(
                      onTap: cubit.changePrivateResidence,
                      child: Row(
                        children: [
                          AppCheckBox(isSelected: state.isExempt),
                          12.ws,
                          AppText(
                            text: 'تحمل على وزارة المالية؟',
                            fontWeight: FontWeight.w700,
                            fontSize: 14.sp,
                            color: AppColors.neutralDarkDark,
                          ),
                        ],
                      ),
                    ),
                    15.hs,
                    if (state.isExempt == true) ...[
                      AppDropdownField<String>(
                        labelText: 'النشاط المستفاد من التحمل',
                        labelRequired: true,
                        hintText: 'اختر النشاط',
                        value: state.selectedBurdenActivity,
                        items: cubit.lookups.productionBurdenActivityTypes
                            .map((b) => appDropDownOption(label: b.name))
                            .toList(),
                        onChanged: cubit.selectBurdenActivity,
                        validator: (v) => v == null ? 'هذا الحقل مطلوب' : null,
                      ),
                    ],
                    16.hs,
                  ],
                );
              },
            ),

            BlocBuilder<UnitDataCubit, UnitDataState>(
              buildWhen: (prev, curr) =>
                  prev.constructionLicenseFilePath !=
                  curr.constructionLicenseFilePath,
              builder: (context, state) => FileUploadField(
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
              ),
            ),
            16.hs,
            BlocBuilder<UnitDataCubit, UnitDataState>(
              buildWhen: (prev, curr) =>
                  prev.operationLicenseFilePath !=
                  curr.operationLicenseFilePath,
              builder: (context, state) => FileUploadField(
                labelText: 'صورة من ترخيص التشغيل',
                text: 'حمل ملف',
                backgroundColor: AppColors.highlightDarkest,
                textColor: AppColors.white,
                filePath: state.operatingLicenseFullUrl,
                onFilePicked: () async {
                  final path = await cubit.pickFile();
                  if (path != null) cubit.setOperationLicenseFile(path);
                },
                onFileRemoved: () => cubit.removeOperationLicenseFile(),
              ),
            ),
            16.hs,
            BlocBuilder<UnitDataCubit, UnitDataState>(
              buildWhen: (prev, curr) =>
                  prev.allocationContractFilePath !=
                  curr.allocationContractFilePath,
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

            // ── مستندات داعمة أخرى (supporting_documents) ──────────
            const AdditionalDocumentsSection(title: 'مستندات داعمة أخرى'),
            16.hs,
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
  final ProductionBuilding building;
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
            keyboardType: TextInputType.number,
            hintText: 'إدخل المساحة الإجمالية للمبنى',
            validator: (v) => v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
          ),
          15.hs,
          AppTextFormField(
            labelText: 'القيمة السوقية للمبنى',
            keyboardType: TextInputType.number,
            labelRequired: false,
            controller: widget.building.marketValue,
            hintText: 'القيمة السوقية للمبنى',
          ),
          15.hs,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: AppButton(
                  label: 'إضافة مبنى',
                  backgroundColor: AppColors.highlightDarkest,
                  icon: Icon(Icons.add, color: AppColors.white),
                  iconLeft: false,
                  onTap: widget.cubit.addProductionBuilding,
                  fontWeight: FontWeight.w600,
                ),
              ),
              15.ws,
              if (widget.canDelete)
                GestureDetector(
                  onTap: () =>
                      widget.cubit.removeProductionBuilding(widget.index),
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
