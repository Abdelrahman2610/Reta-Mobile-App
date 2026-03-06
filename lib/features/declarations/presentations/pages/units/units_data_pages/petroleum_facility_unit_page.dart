import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/helpers/extensions/dimensions.dart';
import '../../../../../../core/helpers/fixed_assets.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../components/app_button.dart';
import '../../../../../components/app_container.dart';
import '../../../../../components/app_text.dart';
import '../../../../../components/app_text_form_field.dart';
import '../../../../../components/image_svg_custom_widget.dart';
import '../../../../data/models/petro_building.dart';
import '../../../cubit/units/unit_data/unit_data_cubit.dart';
import '../../../cubit/units/unit_data/unit_data_state.dart';
import 'components/additional_documents_section.dart';
import 'components/app_counter.dart';
import 'components/calendar_icon.dart';
import 'components/file_upload_field.dart';
import 'components/tax_contact_section.dart';
import 'components/title_with_divider.dart';

class PetroleumFacilityUnitPage extends StatelessWidget {
  const PetroleumFacilityUnitPage({super.key, required this.unitCubit});

  final UnitDataCubit unitCubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: unitCubit,
      child: const _PetroleumFacilityUnitView(),
    );
  }
}

class _PetroleumFacilityUnitView extends StatelessWidget {
  const _PetroleumFacilityUnitView();

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
              text: 'بيانات المنشأة البترولية',
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.mainBlueIndigoDye,
            ),
            24.hs,

            AppTextFormField(
              labelText: 'أسم المنشأة',
              labelRequired: true,
              controller: cubit.petroleumFacilityNameController,
              hintText: 'ادخل أسم المنشأة',
              validator: (v) =>
                  v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
            ),
            16.hs,
            AppTextFormField(
              labelText: 'نوع الإستخدام',
              labelRequired: true,
              controller: cubit.usageTypeController,
              hintText: 'ادخل نوع الإستخدام',
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
              labelText: 'التكلفة الدفترية للأرض',
              labelRequired: false,
              controller: cubit.bookValueController,
              keyboardType: TextInputType.number,
              hintText: 'إدخل التكلفة الدفترية للأرض',
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
                  prev.petroBuildingsCount != curr.petroBuildingsCount,
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
                        count: cubit.petroBuildings.length,
                        onDecrement: () => cubit.removePetroBuilding(
                          cubit.petroBuildings.length - 1,
                        ),
                        onIncrement: cubit.addPetroBuilding,
                      ),
                    ],
                  ),

                  12.hs,

                  ...cubit.petroBuildings.asMap().entries.map(
                    (e) => _BuildingItem(
                      index: e.key,
                      building: e.value,
                      cubit: cubit,
                      isLast: e.key == cubit.petroBuildings.length - 1,
                      canDelete: cubit.petroBuildings.length > 1,
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
            BlocBuilder<UnitDataCubit, UnitDataState>(
              buildWhen: (prev, curr) =>
                  prev.openingBudgetFilePath != curr.openingBudgetFilePath,
              builder: (context, state) => FileUploadField(
                labelText: 'صورة من الميزانية الافتتاحية',
                text: 'حمل ملف',
                backgroundColor: AppColors.highlightDarkest,
                textColor: AppColors.white,
                filePath: state.openingBudgetFilePath,
                onFilePicked: () async {
                  final path = await cubit.pickFile();
                  if (path != null) cubit.setOpeningBudgetFile(path);
                },
                onFileRemoved: () => cubit.removeOpeningBudgetFile(),
              ),
            ),
            16.hs,
            BlocBuilder<UnitDataCubit, UnitDataState>(
              buildWhen: (prev, curr) =>
                  prev.allBookBValueFilePath != curr.allBookBValueFilePath,
              builder: (context, state) => FileUploadField(
                labelText: 'صورة بالقيمة الدفترية لكافه الأصول',
                text: 'حمل ملف',
                backgroundColor: AppColors.highlightDarkest,
                textColor: AppColors.white,
                filePath: state.allBookBValueFilePath,
                onFilePicked: () async {
                  final path = await cubit.pickFile();
                  if (path != null) cubit.setAllBookBValueFile(path);
                },
                onFileRemoved: () => cubit.removeAllBookBValueFile(),
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
  final PetroBuilding building;
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

          AppTextFormField(
            labelText: 'نوع المبنى',
            labelRequired: true,
            controller: widget.building.buildingType,
            hintText: 'إدخل نوع المبنى',
            validator: (v) => v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
          ),
          15.hs,
          AppTextFormField(
            labelText: 'التكلفة الدفترية للمبنى',
            labelRequired: false,
            controller: widget.building.bookCostBuilding,
            hintText: 'إدخل التكلفة الدفترية للمبنى',
          ),
          15.hs,

          AppTextFormField(
            labelText: 'تاريخ الإنشاء للمبنى',
            labelRequired: true,
            controller: widget.building.buildingDate,
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
                  widget.building.buildingDate.text =
                      '${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}';
                });
              }
            },
            suffixWidget: CalendarIcon(color: AppColors.neutralDarkLightest),
            validator: (v) => v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
          ),
          15.hs,
          AppTextFormField(
            labelText: 'مساحة المبنى',
            labelRequired: true,
            controller: widget.building.totalArea,
            hintText: 'المساحة الإجمالية بالمتر المربع',
            keyboardType: TextInputType.number,
            validator: (v) => v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
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
                  onTap: widget.cubit.addPetroBuilding,
                  fontWeight: FontWeight.w600,
                ),
              ),
              15.ws,
              if (widget.canDelete)
                GestureDetector(
                  onTap: () => widget.cubit.removePetroBuilding(widget.index),
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
