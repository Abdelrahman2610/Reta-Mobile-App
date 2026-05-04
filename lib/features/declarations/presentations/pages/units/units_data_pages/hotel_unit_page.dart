import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:reta/features/components/app_button.dart';
import 'package:reta/features/declarations/presentations/components/warning_card.dart';
import 'package:reta/features/declarations/presentations/pages/units/units_data_pages/buildings/hotel_building_location_data.dart';

import '../../../../../../core/helpers/extensions/dimensions.dart';
import '../../../../../../core/helpers/fixed_assets.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../components/app_text.dart';
import '../../../../../components/app_text_form_field.dart';
import '../../../../../components/image_svg_custom_widget.dart';
import '../../../../data/models/hotel_building_info.dart';
import '../../../../data/models/hotel_sub_unit.dart';
import '../../../../data/models/map_location_result.dart';
import '../../../components/app_drop_down.dart';
import '../../../components/app_drop_down_option.dart';
import '../../../cubit/units/unit_data/unit_data_cubit.dart';
import '../../../cubit/units/unit_data/unit_data_state.dart';
import 'buildings/hotel_sub_unit_detail_page.dart';
import 'components/additional_documents_section.dart';
import 'components/app_text_form_field_with_counter.dart';
import 'components/building_container.dart';
import 'components/buildings_title.dart';
import 'components/calendar_icon.dart';
import 'components/file_upload_field.dart';
import 'components/location_card.dart';
import 'components/tax_contact_section.dart';

class HotelFacilityPage extends StatelessWidget {
  const HotelFacilityPage({
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
      child: _HotelFacilityView(
        mapLocationResult: mapLocationResult,
        isUrban: isUrban,
        locationData: locationData,
      ),
    );
  }
}

class _HotelFacilityView extends StatefulWidget {
  const _HotelFacilityView({
    this.mapLocationResult,
    required this.isUrban,
    required this.locationData,
  });
  final MapLocationResult? mapLocationResult;
  final bool isUrban;
  final Map<String, dynamic>? locationData;

  @override
  State<_HotelFacilityView> createState() => _HotelFacilityViewState();
}

class _HotelFacilityViewState extends State<_HotelFacilityView> {
  TextEditingController _buildingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final cubit = context.read<UnitDataCubit>();
    final building = cubit.state.buildingsCount;
    _buildingController = TextEditingController(text: building.toString());
  }

  @override
  void dispose() {
    _buildingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UnitDataCubit>();

    return Form(
      key: cubit.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // ── الاسم التجاري (trade_name) ─────────
          AppTextFormField(
            labelText: 'الأسم التجاري للمنشأة الفندقية',
            labelRequired: true,
            controller: cubit.facilityNameController,
            hintText: 'ادخل الأسم التجاري للمنشأة الفندقية',
            validator: (v) => v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
          ),
          16.hs,

          // ── الإطلالة (view_type_id) ────────────
          BlocBuilder<UnitDataCubit, UnitDataState>(
            buildWhen: (prev, curr) =>
                prev.selectedHotelView != curr.selectedHotelView,
            builder: (context, state) => AppDropdownField<String>(
              labelText: 'الإطلالة',
              labelRequired: true,
              hintText: 'اختر الإطلالة',
              value: state.selectedHotelView,
              items: cubit.lookups.hotelViewTypes
                  .map((v) => appDropDownOption(label: v.name))
                  .toList(),
              onChanged: cubit.selectHotelView,
              validator: (v) => v == null ? 'هذا الحقل مطلوب' : null,
            ),
          ),
          16.hs,

          // ── تاريخ تراخيص التشغيل (license_date) ─
          AppTextFormField(
            labelText: 'تاريخ تراخيص التشغيل',
            labelRequired: true,
            controller: cubit.operatingLicenseDateController,
            hintText: 'ادخل تاريخ تراخيص التشغيل',
            readOnly: true,
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1990),
                lastDate: DateTime.now(),
                locale: const Locale('en'),
              );
              if (picked != null) {
                cubit.operatingLicenseDateController.text =
                    '${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}';
              }
            },
            suffixWidget: CalendarIcon(color: AppColors.neutralDarkLightest),
            validator: (v) => v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
          ),
          16.hs,

          // ── عدد المباني (buildings_count) ──────
          AppTextFormFieldWithCounter(
            title: 'عدد المباني',
            controller: TextEditingController(
              text: cubit.state.buildingsCount.toString(),
            ),
            onChanged: (val) {
              final parsed = int.tryParse(val);
              if (parsed != null && parsed >= 1) {
                cubit.emit(cubit.state.copyWith(buildingsCount: parsed));
              }
            },
            onIncrementTapped: () {
              int value = cubit.state.buildingsCount + 1;
              _buildingController.text = value.toString();
              _buildingController.selection = TextSelection.collapsed(
                offset: _buildingController.text.length,
              );

              if (value >= 1) {
                cubit.emit(cubit.state.copyWith(buildingsCount: value));
              }
              setState(() {});
            },
            onDecrementTapped: () {
              int value = cubit.state.buildingsCount - 1;
              _buildingController.text = value.toString();
              _buildingController.selection = TextSelection.collapsed(
                offset: _buildingController.text.length,
              );

              if (value >= 1) {
                cubit.emit(cubit.state.copyWith(buildingsCount: value));
              }
              setState(() {});
            },
          ),

          16.hs,

          // ── عدد الغرف (rooms_count) ────────────
          // AppTextFormField(
          //   labelText: 'عدد الغرف',
          //   labelRequired: true,
          //   controller: cubit.facilityRoomCountController,
          //   hintText: 'ادخل عدد الغرف',
          //   keyboardType: TextInputType.number,
          //   validator: (v) {
          //     return v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null;
          //   },
          // ),
          // 16.hs,

          // ── مستوى النجومية (star_rating_id) ────
          BlocBuilder<UnitDataCubit, UnitDataState>(
            buildWhen: (prev, curr) =>
                prev.selectedStarRating != curr.selectedStarRating,
            builder: (context, state) => AppDropdownField<String>(
              labelText: 'مستوى النجومية',
              labelRequired: true,
              hintText: 'اختر مستوى النجومية',
              value: state.selectedStarRating,
              items: cubit.lookups.starRatings
                  .map((s) => appDropDownOption(label: s.name))
                  .toList(),
              onChanged: cubit.selectStarRating,
              validator: (v) => v == null ? 'هذا الحقل مطلوب' : null,
            ),
          ),
          16.hs,

          // ── هل تم التواصل مع الضرائب؟ (reta_contact_about_unit) ─
          const TaxContactSection(
            customLabel:
                'هل تم التواصل مع الضرائب العقارية بخصوص المنشأة محل الإقرار سابقاً؟',
          ),
          16.hs,

          // ── كود حساب الوحدة (account_code) ────
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
                        ),
                        16.hs,
                      ],
                    )
                  : const SizedBox.shrink();
            },
          ),

          // ── صورة من التراخيص الإنشائية (copy_of_the_construction_permits) ─
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

          // ── صورة من ترخيص التشغيل (copy_of_the_operating_licenses) ─
          BlocBuilder<UnitDataCubit, UnitDataState>(
            buildWhen: (prev, curr) =>
                prev.operatingLicenseFilePath != curr.operatingLicenseFilePath,
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

          // ── شهادة بمستوى النجومية (certificate_of_stardom_level) ─
          BlocBuilder<UnitDataCubit, UnitDataState>(
            buildWhen: (prev, curr) =>
                prev.starCertificateFilePath != curr.starCertificateFilePath,
            builder: (context, state) => FileUploadField(
              labelText: 'شهادة بمستوى النجومية',
              text: 'حمل ملف',
              backgroundColor: AppColors.highlightDarkest,
              textColor: AppColors.white,
              filePath: state.starCertificateFullUrl,
              onFilePicked: () async {
                final path = await cubit.pickFile();
                if (path != null) cubit.setStarCertificateFile(path);
              },
              onFileRemoved: () => cubit.removeStarCertificateFile(),
            ),
          ),
          16.hs,

          // ── مستندات داعمة أخرى (supporting_documents) ──────────
          const AdditionalDocumentsSection(),
          16.hs,

          // ── المباني ──────────────────────────────
          _HotelBuildingsSection(
            cubit: cubit,
            mapLocationResult: widget.mapLocationResult,
            isUrban: widget.isUrban,
            locationData: widget.locationData,
          ),
          16.hs,

          // ── هل توجد وحدات تابعة؟ (has_sub_units) ───────────────
          BlocBuilder<UnitDataCubit, UnitDataState>(
            buildWhen: (prev, curr) => prev.hasSubUnits != curr.hasSubUnits,
            builder: (context, state) => AppDropdownField<String>(
              labelText: 'هل توجد وحدات تابعة للمنشأة الفندقية؟',
              labelRequired: true,
              hintText: 'اختر',
              value: state.hasSubUnits == null
                  ? null
                  : (state.hasSubUnits! ? 'نعم' : 'لا'),
              items: cubit.yesNoOptions
                  .map((o) => appDropDownOption(label: o))
                  .toList(),
              onChanged: (v) => cubit.setHasSubUnits(v == 'نعم'),
              validator: (v) => v == null ? 'هذا الحقل مطلوب' : null,
            ),
          ),
          16.hs,

          // ── وحدات المنشأة الفندقية (hotelUnits) ─────────────────────
          BlocBuilder<UnitDataCubit, UnitDataState>(
            buildWhen: (prev, curr) =>
                prev.hasSubUnits != curr.hasSubUnits ||
                prev.hotelSubUnitsUpdateCount != curr.hotelSubUnitsUpdateCount,
            builder: (context, state) {
              if (state.hasSubUnits != true) {
                return const SizedBox.shrink();
              }
              return BuildingContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    BuildingsTitle(title: 'وصف الوحدات'),
                    12.hs,
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.neutralLightLight,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Column(
                        children: state.hotelSubUnits.asMap().entries.map((e) {
                          return _HotelSubUnitCard(
                            index: e.key,
                            unit: e.value,
                            cubit: cubit,
                            canDelete: state.hotelSubUnits.length > 1,
                          );
                        }).toList(),
                      ),
                    ),
                    16.hs,
                    AppButton(
                      label: 'إضافة وحدة تابعة فندقية',
                      iconLeft: false,
                      icon: Icon(Icons.add, color: AppColors.white),
                      backgroundColor: AppColors.highlightDarkest,
                      textColor: AppColors.white,
                      height: 55.h,
                      fontWeight: FontWeight.w600,
                      onTap: () async {
                        final newUnit = HotelSubUnit();
                        final newIndex = state.hotelSubUnits.length;
                        final result =
                            await PersistentNavBarNavigator.pushNewScreen(
                              context,
                              screen: BlocProvider.value(
                                value: cubit,
                                child: HotelSubUnitDetailPage(
                                  unit: newUnit,
                                  index: newIndex,
                                ),
                              ),
                              withNavBar: false,
                              pageTransitionAnimation:
                                  PageTransitionAnimation.slideUp,
                            );
                        if (result == true) {
                          cubit.confirmAddHotelSubUnit(newUnit);
                        } else {
                          newUnit.dispose();
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// Hotel Buildings Section
// ─────────────────────────────────────────
class _HotelBuildingsSection extends StatefulWidget {
  const _HotelBuildingsSection({
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
  State<_HotelBuildingsSection> createState() => _HotelBuildingsSectionState();
}

class _HotelBuildingsSectionState extends State<_HotelBuildingsSection> {
  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final cubit = widget.cubit;
    return BlocBuilder<UnitDataCubit, UnitDataState>(
      buildWhen: (prev, curr) => prev.buildingsCount != curr.buildingsCount,
      builder: (context, state) {
        final bool isComplete =
            cubit.hotelBuildings.first.mapLocationResult != null;
        return BuildingContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              BuildingsTitle(),
              12.hs,
              LocationCard(
                hideEditButton: widget.locationData != null,
                mapLocationResult:
                    cubit.hotelBuildings.first.mapLocationResult ??
                    widget.mapLocationResult,
                title: 'المبنى الرئيسي (1)',
                buttonLabel: isComplete ? 'تعديل' : 'استكمال البيانات',
                onBtnTapped: () {
                  PersistentNavBarNavigator.pushNewScreen(
                    context,
                    screen: BlocProvider.value(
                      value: cubit,
                      child: HotelBuildingLocationData(
                        mapLocationResult: widget.mapLocationResult,
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
              ...cubit.hotelBuildings.asMap().entries.skip(1).map((entry) {
                return _HotelBuildingItemWidget(
                  index: entry.key,
                  building: entry.value,
                  cubit: cubit,
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
                        cubit.incrementHotelBuildings();
                        final newIndex = cubit.hotelBuildings.length - 1;
                        final result =
                            await PersistentNavBarNavigator.pushNewScreen(
                              context,
                              screen: BlocProvider.value(
                                value: cubit,
                                child: HotelBuildingLocationData(
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
                          await cubit.decrementHotelBuildings(newIndex);
                        }
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
// Hotel Building Item Widget
// ─────────────────────────────────────────
class _HotelBuildingItemWidget extends StatelessWidget {
  const _HotelBuildingItemWidget({
    required this.index,
    required this.building,
    required this.cubit,
    required this.isUrban,
    required this.onReturned,
    required this.locationData,
  });

  final int index;
  final HotelBuildingInfo building;
  final UnitDataCubit cubit;
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
                child: HotelBuildingLocationData(
                  mapLocationResult: building.mapLocationResult,
                  index: index,
                  isUrban: isUrban,
                ),
              ),
              withNavBar: false,
              pageTransitionAnimation: PageTransitionAnimation.slideUp,
            ).then((_) => onReturned());
          },
          onDeleteTapped: () => cubit.decrementHotelBuildings(index),
        ),
        15.hs,
      ],
    );
  }
}

// ─────────────────────────────────────────
// Hotel Sub-Unit Card
// ─────────────────────────────────────────

class _HotelSubUnitCard extends StatefulWidget {
  const _HotelSubUnitCard({
    required this.index,
    required this.unit,
    required this.cubit,
    required this.canDelete,
  });

  final int index;
  final HotelSubUnit unit;
  final UnitDataCubit cubit;
  final bool canDelete;

  @override
  State<_HotelSubUnitCard> createState() => _HotelSubUnitCardState();
}

class _HotelSubUnitCardState extends State<_HotelSubUnitCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(-1.0, 0),
            radius: 4.0,
            colors: [
              Color(0xFFC8DFF5),
              Color(0xFFDDEAF8),
              Color(0xFFEDF4FB),
              Colors.white,
            ],
            stops: const [0.0, 0.03, 0.25, 1.0],
          ),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── عنوان الكارت ──────────────────────
            AppText(
              text: 'بيانات الوحدة (${widget.index + 1})',
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.neutralDarkDark,
              alignment: Alignment.center,
            ),
            12.hs,

            // ── شبكة بيانات 2×2 ──────────────────
            Row(
              children: [
                Expanded(
                  child: _InfoCell(
                    label: 'رقم المبنى',
                    value: widget.unit.buildingNumber.text.isEmpty
                        ? '—'
                        : widget.unit.buildingNumber.text,
                  ),
                ),
                8.ws,
                Expanded(
                  child: _InfoCell(
                    label: 'رقم الوحدة',
                    value: widget.unit.unitNumber.text.isEmpty
                        ? '—'
                        : widget.unit.unitNumber.text,
                  ),
                ),
              ],
            ),
            8.hs,
            Row(
              children: [
                Expanded(
                  child: _InfoCell(
                    label: 'رقم الدور',
                    value: widget.unit.floorNumber ?? '—',
                  ),
                ),
                8.ws,
                Expanded(
                  child: _InfoCell(
                    label: 'نوع النشاط',
                    value: widget.unit.activityType.text.isEmpty
                        ? '—'
                        : widget.unit.activityType.text,
                  ),
                ),
              ],
            ),
            12.hs,

            // ── أزرار الحذف والتعديل ──────────────
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: 'تعديل',
                    backgroundColor: AppColors.highlightDarkest,
                    textColor: AppColors.white,
                    height: 44.h,
                    onTap: () {
                      PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: BlocProvider.value(
                          value: widget.cubit,
                          child: HotelSubUnitDetailPage(
                            unit: widget.unit,
                            index: widget.index,
                          ),
                        ),
                        withNavBar: false,
                        pageTransitionAnimation:
                            PageTransitionAnimation.slideUp,
                      );
                    },
                  ),
                ),
                if (widget.canDelete)
                  Padding(
                    padding: EdgeInsetsDirectional.only(start: 15.w),
                    child: Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: GestureDetector(
                        onTap: () =>
                            widget.cubit.removeHotelSubUnit(widget.unit.id),
                        child: ImageSvgCustomWidget(
                          imgPath: FixedAssets.instance.deleteIC,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCell extends StatelessWidget {
  const _InfoCell({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.neutralLightLight,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: label,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.neutralDarkMedium,
          ),
          4.hs,
          AppText(
            text: value,
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.neutralDarkDarkest,
          ),
        ],
      ),
    );
  }
}
