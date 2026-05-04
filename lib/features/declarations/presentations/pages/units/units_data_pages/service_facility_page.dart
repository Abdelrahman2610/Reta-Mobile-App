import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:reta/core/helpers/fixed_assets.dart';
import 'package:reta/features/components/app_button.dart';
import 'package:reta/features/components/image_svg_custom_widget.dart';
import 'package:reta/features/declarations/presentations/components/warning_card.dart';
import 'package:reta/features/declarations/presentations/pages/units/units_data_pages/buildings/facility_building_location_data.dart';

import '../../../../../../core/helpers/extensions/dimensions.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../components/app_text_form_field.dart';
import '../../../../data/models/facility_building_info.dart';
import '../../../../data/models/map_location_result.dart';
import '../../../cubit/units/unit_data/unit_data_cubit.dart';
import '../../../cubit/units/unit_data/unit_data_state.dart';
import 'components/additional_documents_section.dart';
import 'components/building_container.dart';
import 'components/buildings_title.dart';
import 'components/exemption_section.dart';
import 'components/file_upload_field.dart';
import 'components/location_card.dart';
import 'components/tax_contact_section.dart';
import 'components/title_with_divider.dart';

class ServiceFacilityPage extends StatelessWidget {
  const ServiceFacilityPage({
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
      child: _ServiceFacilityView(
        mapLocationResult,
        isUrban: isUrban,
        locationData: locationData,
      ),
    );
  }
}

class _ServiceFacilityView extends StatelessWidget {
  const _ServiceFacilityView(
    this.mapLocationResult, {
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
          // ── اسم المنشأة ──────────────────────────
          AppTextFormField(
            labelText: 'إسم المنشأة',
            labelRequired: true,
            controller: cubit.facilityNameController,
            hintText: 'ادخل اسم المنشأة',
            validator: (v) => v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
          ),
          16.hs,

          // ── نوع المنشأة الخدمية (facility_type_id) ──────────────
          // BlocBuilder<UnitDataCubit, UnitDataState>(
          //   buildWhen: (prev, curr) =>
          //       prev.selectedFacilityActivity != curr.selectedFacilityActivity,
          //   builder: (context, state) => AppDropdownField<String>(
          //     labelText: 'نوع المنشأة الخدمية',
          //     labelRequired: true,
          //     hintText: 'اختر نوع المنشأة',
          //     value: state.selectedFacilityActivity,
          //     items: cubit.lookups.serviceFacilityTypes
          //         .map((t) => appDropDownOption(label: t.name))
          //         .toList(),
          //     onChanged: cubit.selectServiceFacilityType,
          //     validator: (v) => v == null ? 'هذا الحقل مطلوب' : null,
          //   ),
          // ),
          // 16.hs,

          // ── مساحة الأرض الكلية ──────────────────
          AppTextFormField(
            labelText: 'مساحة الأرض الكلية',
            labelRequired: true,
            controller: cubit.totalLandAreaFacilityController,
            hintText: 'المساحة بالمتر المربع',
            keyboardType: TextInputType.number,
            validator: (v) => v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
          ),
          16.hs,

          // ── نوع النشاط ───────────────────────────
          AppTextFormField(
            labelText: 'نوع النشاط',
            labelRequired: true,
            controller: cubit.activityTypeController,
            hintText: 'ادخل نوع النشاط',
            validator: (v) => v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
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
                prev.operatingLicenseFilePath != curr.operatingLicenseFilePath,
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

          // ── المباني ──────────────────────────────
          _BuildingsSection(
            cubit: cubit,
            mapLocationResult: mapLocationResult,
            isUrban: isUrban,
            locationData: locationData,
          ),
          16.hs,

          // ── مستندات داعمة أخرى ───────────────────
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
      buildWhen: (prev, curr) => prev.buildingsCount != curr.buildingsCount,
      builder: (context, state) {
        final isComplete =
            cubit.facilityBuildings[0].areaController.text.isNotEmpty;
        return BuildingContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // --- divider + title ------------------
              TitleWithDivider(title: 'المباني المضافة داخل المنشأة'),
              12.hs,

              // --- عدد المباني counter ------------------
              BuildingsTitle(),
              16.hs,
              LocationCard(
                hideEditButton: widget.locationData != null,
                mapLocationResult:
                    cubit.facilityBuildings.first.mapLocationResult ??
                    widget.mapLocationResult,
                title: 'المبنى الرئيسي (1)',
                buttonLabel: isComplete ? 'تعديل' : 'استكمال البيانات',
                onBtnTapped: () {
                  PersistentNavBarNavigator.pushNewScreen(
                    context,
                    screen: BlocProvider.value(
                      value: cubit,
                      child: FacilityBuildingLocationData(
                        mapLocationResult:
                            cubit.facilityBuildings.first.mapLocationResult ??
                            widget.mapLocationResult,
                        index: 0,
                        isUrban: widget.isUrban,
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
              // --- قائمة المباني (من المبنى الثاني فصاعداً) ------------------
              ...cubit.facilityBuildings.asMap().entries.skip(1).map((entry) {
                return _BuildingItemWidget(
                  index: entry.key,
                  building: entry.value,
                  cubit: cubit,
                  isLast: entry.key == cubit.facilityBuildings.length - 1,
                  canDelete: cubit.facilityBuildings.length > 1,
                  isUrban: widget.isUrban,
                  onReturned: _refresh,
                  locationData: widget.locationData,
                );
              }),

              25.hs,
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
                        cubit.incrementFacilityBuildings();
                        final newIndex = cubit.facilityBuildings.length - 1;
                        final result =
                            await PersistentNavBarNavigator.pushNewScreen(
                              context,
                              screen: BlocProvider.value(
                                value: cubit,
                                child: FacilityBuildingLocationData(
                                  mapLocationResult: null,
                                  index: newIndex,
                                  isUrban: widget.isUrban,
                                ),
                              ),
                              withNavBar: false,
                              pageTransitionAnimation:
                                  PageTransitionAnimation.slideUp,
                            );
                        if (result != true) {
                          cubit.decrementFacilityBuildings(newIndex);
                        }
                        _refresh();
                      }
                    : null,
              ),

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
    required this.isLast,
    required this.canDelete,
    required this.isUrban,
    required this.onReturned,
    required this.locationData,
  });

  final int index;
  final ServiceFacilityBuildingInfo building;
  final UnitDataCubit cubit;
  final bool isLast;
  final bool canDelete;
  final bool isUrban;
  final VoidCallback onReturned;
  final Map<String, dynamic>? locationData;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        LocationCard(
          hideEditButton: locationData != null,
          title: 'مبنى (${index + 1})',
          mapLocationResult: building.mapLocationResult,
          onBtnTapped: () {
            PersistentNavBarNavigator.pushNewScreen(
              context,
              screen: BlocProvider.value(
                value: cubit,
                child: FacilityBuildingLocationData(
                  mapLocationResult: building.mapLocationResult,
                  index: index,
                  isUrban: isUrban,
                ),
              ),
              withNavBar: false,
              pageTransitionAnimation: PageTransitionAnimation.slideUp,
            ).then((_) => onReturned());
          },
          onDeleteTapped: () => cubit.decrementFacilityBuildings(index),
        ),

        15.hs,
      ],
    );
  }
}
