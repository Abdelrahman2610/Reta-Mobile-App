import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:reta/core/helpers/fixed_assets.dart';
import 'package:reta/features/components/app_button.dart';
import 'package:reta/features/components/image_svg_custom_widget.dart';
import 'package:reta/features/declarations/presentations/pages/units/units_data_pages/buildings/petroleum_building_location_data.dart';

import '../../../../../../core/helpers/extensions/dimensions.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../components/app_text_form_field.dart';
import '../../../../data/models/map_location_result.dart';
import '../../../components/warning_card.dart';
import '../../../cubit/units/unit_data/unit_data_cubit.dart';
import '../../../cubit/units/unit_data/unit_data_state.dart';
import 'components/additional_documents_section.dart';
import 'components/building_container.dart';
import 'components/buildings_title.dart';
import 'components/file_upload_field.dart';
import 'components/location_card.dart';
import 'components/tax_contact_section.dart';

class PetroleumFacilityUnitPage extends StatelessWidget {
  const PetroleumFacilityUnitPage({
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
      child: _PetroleumFacilityUnitView(
        mapLocationResult: mapLocationResult,
        isUrban: isUrban,
        locationData: locationData,
      ),
    );
  }
}

class _PetroleumFacilityUnitView extends StatelessWidget {
  const _PetroleumFacilityUnitView({
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
            controller: cubit.petroleumFacilityNameController,
            hintText: 'ادخل أسم المنشأة',
            validator: (v) => v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
          ),
          16.hs,
          AppTextFormField(
            labelText: 'نوع الإستخدام',
            labelRequired: true,
            controller: cubit.usageTypeController,
            hintText: 'ادخل نوع الإستخدام',
            validator: (v) => v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
          ),
          16.hs,
          AppTextFormField(
            labelText: 'مساحة الأرض الكلية',
            labelRequired: true,
            controller: cubit.totalLandArea,
            keyboardType: TextInputType.number,
            hintText: 'المساحة الإجمالية بالمتر المربع',
            validator: (v) => v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
          ),
          16.hs,
          AppTextFormField(
            labelText: 'مساحة الأرض المستغلة',
            labelRequired: true,
            controller: cubit.totalLandUtilized,
            keyboardType: TextInputType.number,
            hintText: 'المساحة الإجمالية بالمتر المربع',
            validator: (v) => v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
          ),
          16.hs,
          AppTextFormField(
            labelText: 'التكلفة الدفترية للأرض',
            controller: cubit.bookValueController,
            keyboardType: TextInputType.number,
            hintText: 'إدخل التكلفة الدفترية للأرض',
          ),
          16.hs,

          // ── هل تم التواصل مع الضرائب؟ ───────────
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
                prev.openingBudgetFilePath != curr.openingBudgetFilePath,
            builder: (context, state) => FileUploadField(
              labelText: 'صورة من الميزانية الافتتاحية',
              text: 'حمل ملف',
              backgroundColor: AppColors.highlightDarkest,
              textColor: AppColors.white,
              filePath: state.openingBudgetFullUrl,
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
              filePath: state.allBookBValueFullUrl,
              onFilePicked: () async {
                final path = await cubit.pickFile();
                if (path != null) cubit.setAllBookBValueFile(path);
              },
              onFileRemoved: () => cubit.removeAllBookBValueFile(),
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
          prev.petroBuildingsCount != curr.petroBuildingsCount,
      builder: (context, state) {
        final bool isComplete =
            cubit.petroBuildings.first.totalArea.text.isNotEmpty &&
            cubit.petroBuildings.first.buildingDate.text.isNotEmpty;
        return BuildingContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              BuildingsTitle(),
              16.hs,
              LocationCard(
                hideEditButton: widget.locationData != null,
                mapLocationResult:
                    cubit.petroBuildings.first.mapLocationResult ??
                    widget.mapLocationResult,
                title: 'المبنى الرئيسي (1)',
                buttonLabel: isComplete ? 'تعديل' : 'استكمال البيانات',
                onBtnTapped: () {
                  PersistentNavBarNavigator.pushNewScreen(
                    context,
                    screen: BlocProvider.value(
                      value: cubit,
                      child: PetroleumBuildingLocationData(
                        index: 0,
                        isUrban: widget.isUrban,
                        isNew: false,
                        mapLocationResult: widget.mapLocationResult,
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
              ...cubit.petroBuildings.asMap().entries.skip(1).map((entry) {
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
                        cubit.addPetroBuilding();
                        final newIndex = cubit.petroBuildings.length - 1;
                        final result =
                            await PersistentNavBarNavigator.pushNewScreen(
                              context,
                              screen: BlocProvider.value(
                                value: cubit,
                                child: PetroleumBuildingLocationData(
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
              child: PetroleumBuildingLocationData(
                index: index,
                isUrban: isUrban,
                isNew: false,
              ),
            ),
            withNavBar: false,
            pageTransitionAnimation: PageTransitionAnimation.slideUp,
          ).then((_) => onReturned());
        },
        onDeleteTapped: cubit.petroBuildings.length > 1
            ? () => cubit.deletePetroleumBuilding(index)
            : null,
      ),
    );
  }
}
