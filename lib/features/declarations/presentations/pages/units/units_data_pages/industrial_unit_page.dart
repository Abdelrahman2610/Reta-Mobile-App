import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:reta/core/helpers/fixed_assets.dart';
import 'package:reta/features/components/app_button.dart';
import 'package:reta/features/components/app_check_box.dart';
import 'package:reta/features/components/image_svg_custom_widget.dart';
import 'package:reta/features/declarations/presentations/pages/units/units_data_pages/buildings/industrial_building_location_data.dart';

import '../../../../../../core/helpers/extensions/dimensions.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../components/app_text.dart';
import '../../../../../components/app_text_form_field.dart';
import '../../../../data/models/map_location_result.dart';
import '../../../components/app_drop_down.dart';
import '../../../components/app_drop_down_option.dart';
import '../../../components/warning_card.dart';
import '../../../cubit/units/unit_data/unit_data_cubit.dart';
import '../../../cubit/units/unit_data/unit_data_state.dart';
import 'components/additional_documents_section.dart';
import 'components/building_container.dart';
import 'components/buildings_title.dart';
import 'components/file_upload_field.dart';
import 'components/location_card.dart';
import 'components/tax_contact_section.dart';

class IndustrialFacilityPage extends StatelessWidget {
  const IndustrialFacilityPage({
    super.key,
    required this.unitCubit,
    this.mapLocationResult,
    required this.isUrban,
    required this.locationData,
  });
  final UnitDataCubit unitCubit;
  final MapLocationResult? mapLocationResult;
  final bool isUrban;
  final Map<String, dynamic>? locationData;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: unitCubit,
      child: _IndustrialFacilityView(
        mapLocationResult: mapLocationResult,
        isUrban: isUrban,
        locationData: locationData,
      ),
    );
  }
}

class _IndustrialFacilityView extends StatelessWidget {
  const _IndustrialFacilityView({
    this.mapLocationResult,
    required this.isUrban,
    required this.locationData,
  });

  final MapLocationResult? mapLocationResult;
  final bool isUrban;
  final Map<String, dynamic>? locationData;

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

          // ── وصف المباني ───────────────────────────
          _BuildingsSection(
            cubit: cubit,
            mapLocationResult: mapLocationResult,
            isUrban: isUrban,
            locationData: locationData,
          ),
          16.hs,

          const AdditionalDocumentsSection(),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// Buildings Section
// ─────────────────────────────────────────
class _BuildingsSection extends StatefulWidget {
  const _BuildingsSection({
    required this.cubit,
    this.mapLocationResult,
    required this.isUrban,
    required this.locationData,
  });
  final UnitDataCubit cubit;
  final MapLocationResult? mapLocationResult;
  final bool isUrban;
  final Map<String, dynamic>? locationData;

  @override
  State<_BuildingsSection> createState() => _BuildingsSectionState();
}

class _BuildingsSectionState extends State<_BuildingsSection> {
  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final cubit = widget.cubit;
    return BlocBuilder<UnitDataCubit, UnitDataState>(
      buildWhen: (prev, curr) =>
          prev.industrialBuildingsCount != curr.industrialBuildingsCount,
      builder: (context, state) {
        final bool isComplete =
            cubit.industrialBuildings.first.buildingType != null &&
            cubit.industrialBuildings.first.totalArea.text.isNotEmpty &&
            cubit.industrialBuildings.first.constructionDate.text.isNotEmpty;
        return BuildingContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              BuildingsTitle(),
              16.hs,
              LocationCard(
                hideEditButton: widget.locationData != null,
                mapLocationResult:
                    cubit.industrialBuildings.first.mapLocationResult ??
                    widget.mapLocationResult,
                title: 'المبنى الرئيسي (1)',
                buttonLabel: isComplete ? 'تعديل' : 'استكمال البيانات',
                onBtnTapped: () {
                  PersistentNavBarNavigator.pushNewScreen(
                    context,
                    screen: BlocProvider.value(
                      value: cubit,
                      child: IndustrialBuildingLocationData(
                        index: 0,
                        isUrban: widget.isUrban,
                        isNew: false,
                      ),
                    ),
                    withNavBar: false,
                    pageTransitionAnimation: PageTransitionAnimation.slideUp,
                  ).then((_) => _refresh());
                },
              ),
              25.hs,
              if (!isComplete)
                WarningCard(
                  label: 'يجب استكمال بيانات المبنى الرئيسي لتستطيع المتابعه',
                ),
              16.hs,
              ...cubit.industrialBuildings.asMap().entries.skip(1).map((entry) {
                final index = entry.key;
                final building = entry.value;
                return _BuildingItemWidget(
                  index: index,
                  building: building,
                  cubit: cubit,
                  mapLocationResult: building.mapLocationResult,
                  isUrban: widget.isUrban,
                  onReturned: _refresh,
                  locationData: widget.locationData,
                );
              }),
              16.hs,
              AppButton(
                label: 'إضافة مبنى جديد',
                iconLeft: false,
                icon: ImageSvgCustomWidget(
                  imgPath: FixedAssets.instance.addIcon,
                  color: isComplete ? null : AppColors.neutralLightDarkest,
                ),
                backgroundColor: isComplete
                    ? AppColors.highlightDark
                    : AppColors.neutralLightDarkest,
                textColor: isComplete
                    ? Colors.white
                    : AppColors.neutralDarkLight,
                height: 55.h,
                onTap: isComplete
                    ? () async {
                        cubit.addIndustrialBuilding();
                        final newIndex = cubit.industrialBuildings.length - 1;
                        final result =
                            await PersistentNavBarNavigator.pushNewScreen(
                              context,
                              screen: BlocProvider.value(
                                value: cubit,
                                child: IndustrialBuildingLocationData(
                                  index: newIndex,
                                  isUrban: widget.isUrban,
                                  isNew: true,
                                ),
                              ),
                              withNavBar: false,
                              pageTransitionAnimation:
                                  PageTransitionAnimation.slideUp,
                            );

                        _refresh();
                      }
                    : null,
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────
// Building Item Widget
// ─────────────────────────────────────────
class _BuildingItemWidget extends StatelessWidget {
  const _BuildingItemWidget({
    required this.index,
    required this.building,
    required this.cubit,
    this.mapLocationResult,
    required this.isUrban,
    required this.onReturned,
    required this.locationData,
  });

  final int index;
  final dynamic building;
  final UnitDataCubit cubit;
  final MapLocationResult? mapLocationResult;
  final bool isUrban;
  final VoidCallback onReturned;
  final Map<String, dynamic>? locationData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: LocationCard(
        hideEditButton: locationData != null,
        title: 'مبنى (${index + 1})',
        mapLocationResult: building.mapLocationResult,
        onBtnTapped: () {
          PersistentNavBarNavigator.pushNewScreen(
            context,
            screen: BlocProvider.value(
              value: cubit,
              child: IndustrialBuildingLocationData(
                index: index,
                isUrban: isUrban,
                isNew: false,
              ),
            ),
            withNavBar: false,
            pageTransitionAnimation: PageTransitionAnimation.slideUp,
          ).then((_) => onReturned());
        },
        onDeleteTapped: cubit.industrialBuildings.length > 1
            ? () => cubit.deleteIndustrialBuilding(index)
            : null,
      ),
    );
  }
}
