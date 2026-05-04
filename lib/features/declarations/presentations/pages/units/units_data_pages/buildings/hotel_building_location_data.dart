import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:reta/core/helpers/app_enum.dart';
import 'package:reta/features/components/app_button.dart';
import 'package:reta/features/components/app_container.dart';
import 'package:reta/features/components/app_scaffold.dart';
import 'package:reta/features/declarations/presentations/cubit/units/unit_data/unit_data_cubit.dart';
import 'package:reta/features/declarations/presentations/cubit/units/unit_data/unit_data_state.dart';
import 'package:reta/features/declarations/presentations/pages/units/units_data_pages/components/location_card.dart';

import '../../../../../../../core/helpers/extensions/dimensions.dart';
import '../../../../../../../core/helpers/extensions/unit_type.dart';
import '../../../../../../../core/helpers/fixed_assets.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../components/app_text.dart';
import '../../../../../../components/app_text_form_field.dart';
import '../../../../../../components/image_svg_custom_widget.dart';
import '../../../../../data/models/declarations_lookups.dart';
import '../../../../../data/models/hotel_sub_unit.dart';
import '../../../../../data/models/map_location_result.dart';
import '../../../../components/cancel_declaration_button.dart';
import '../../../../components/checkbox_with_title.dart';
import '../../../../components/submit_declaration_button.dart';
import '../../../../cubit/declaration_lookups_cubit.dart';
import '../../map_web_view_screen.dart';
import '../components/app_text_form_field_with_counter.dart';
import 'hotel_sub_unit_detail_page.dart';

class HotelBuildingLocationData extends StatefulWidget {
  const HotelBuildingLocationData({
    super.key,
    this.mapLocationResult,
    required this.index,
    required this.isUrban,
  });

  final MapLocationResult? mapLocationResult;
  final int index;
  final bool isUrban;

  @override
  State<HotelBuildingLocationData> createState() =>
      _HotelBuildingLocationDataState();
}

class _HotelBuildingLocationDataState extends State<HotelBuildingLocationData> {
  late final TextEditingController _floorsController;
  late final TextEditingController _roomsController;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<UnitDataCubit>();
    final building = cubit.hotelBuildings[widget.index];
    _floorsController = TextEditingController(
      text: building.floorsCount.toString(),
    );
    _roomsController = TextEditingController(
      text: building.roomsCount.toString(),
    );
  }

  @override
  void dispose() {
    _floorsController.dispose();
    _roomsController.dispose();
    super.dispose();
  }

  void _incrementFloors(building) {
    setState(() => building.floorsCount++);
    _floorsController.text = building.floorsCount.toString();
    _floorsController.selection = TextSelection.collapsed(
      offset: _floorsController.text.length,
    );
  }

  void _decrementFloors(building) {
    if (building.floorsCount > 1) {
      setState(() => building.floorsCount--);
      _floorsController.text = building.floorsCount.toString();
      _floorsController.selection = TextSelection.collapsed(
        offset: _floorsController.text.length,
      );
    }
  }

  void _incrementRooms(building) {
    setState(() => building.roomsCount++);
    _roomsController.text = building.roomsCount.toString();
    _roomsController.selection = TextSelection.collapsed(
      offset: _roomsController.text.length,
    );
  }

  void _decrementRooms(building) {
    if (building.roomsCount > 1) {
      setState(() => building.roomsCount--);
      _roomsController.text = building.roomsCount.toString();
      _roomsController.selection = TextSelection.collapsed(
        offset: _roomsController.text.length,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UnitDataCubit>();
    final building = cubit.hotelBuildings[widget.index];

    return AppScaffold(
      title: widget.index == 0
          ? 'وصف المبنى الرئيسي للمنشأة الفندقية'
          : 'وصف مباني المنشأة الفندقية',
      padding: EdgeInsets.zero,
      child: BlocBuilder<UnitDataCubit, UnitDataState>(
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 24.h,
                  ),
                  child: AppContainer(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 20.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        AppText(
                          text: 'بيانات الموقع',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.highlightDarkest,
                        ),
                        16.hs,
                        LocationCard(
                          mapLocationResult:
                              building.mapLocationResult ??
                              widget.mapLocationResult,
                          onBtnTapped: () async {
                            final result =
                                await Navigator.push<MapLocationResult?>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => MapWebViewScreen(
                                      urban: widget.isUrban ? 1 : 0,
                                      suffix: addSuffix(
                                        building.mapLocationResult ??
                                            widget.mapLocationResult,
                                        widget.isUrban,
                                        cubit.unitType,
                                        cubit.unitData != null
                                            ? cubit.unitData!['unit_id']
                                            : '-1',
                                      ),
                                    ),
                                  ),
                                );
                            if (result != null) {
                              setState(
                                () => building.mapLocationResult = result,
                              );
                            }
                          },
                        ),
                        16.hs,
                        AppTextFormField(
                          labelText: 'رقم العقار/المبني المتعارف عليه',
                          hintText: 'ادخل رقم العقار',
                          controller: building.knownBuildingNumber,
                        ),
                        16.hs,
                        AppTextFormFieldWithCounter(
                          title: 'عدد الغرف',
                          controller: _roomsController,
                          onChanged: (val) {
                            final parsed = int.tryParse(val);
                            if (parsed != null && parsed >= 1) {
                              setState(() => building.roomsCount = parsed);
                            }
                          },
                          onIncrementTapped: () => _incrementRooms(building),
                          onDecrementTapped: () => _decrementRooms(building),
                        ),
                        16.hs,
                        AppTextFormFieldWithCounter(
                          controller: _floorsController,
                          onChanged: (val) {
                            final parsed = int.tryParse(val);
                            if (parsed != null && parsed >= 1) {
                              setState(() => building.floorsCount = parsed);
                            }
                          },
                          onIncrementTapped: () => _incrementFloors(building),
                          onDecrementTapped: () => _decrementFloors(building),
                        ),

                        if (widget.index != 0) ...[
                          16.hs,
                          CheckBoxWithTitle(
                            label:
                                'العقار المحدد هو أقرب عقار للموقع الخاص بالوحدة محل الإقرار',
                            isSelected: building.isNearestProperty ?? false,
                            onSelectTapped: () => setState(
                              () => building.isNearestProperty =
                                  !(building.isNearestProperty ?? false),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),

              AppContainer(
                borderRadius: 0,
                padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 24.h),
                child: Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Expanded(
                      flex: 5,
                      child: SubmitDeclarationButton(
                        label: 'حفظ البيانات',
                        borderColor: AppColors.successDark,
                        withIcon: false,
                        onSubmit: () {
                          building.mapLocationResult ??=
                              widget.mapLocationResult;
                          Navigator.pop(context, true);
                        },
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      flex: 3,
                      child: CancelDeclarationButton(
                        label: 'إلغاء',
                        withIcon: true,
                        onCancel: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String? addSuffix(
    MapLocationResult? mapData,
    bool isUrban,
    UnitType unitType,
    String unitId,
  ) {
    final lookupsCubit = context.read<DeclarationLookupsCubit>();
    final propertyTypeId = lookupsCubit.lookups?.propertyTypes
        .firstWhere(
          (p) => p.name == unitType.label,
          orElse: () => DeclarationLookup(id: -1, name: ''),
        )
        .id;
    final int urban = isUrban ? 1 : 0;

    String suffix = '?urban=$urban';
    if (mapData != null) {
      final List<dynamic>? location =
          mapData.geometry?['geojson']?['coordinates'][0][0][0];
      if (location != null) {
        suffix += '&lng=${location[0]}&lat=${location[1]}&&unit=building';
      }
      if (unitId != '-1') {
        suffix += '&id=$unitId';
      }

      if (propertyTypeId != -1) {
        suffix += '&property_type_id=$propertyTypeId';
      }
      return suffix;
    }
    return '?urban=$urban';
  }
}

// ─────────────────────────────────────────
// Hotel Sub-Unit Card (per building)
// ─────────────────────────────────────────
class _HotelSubUnitCard extends StatefulWidget {
  const _HotelSubUnitCard({
    required this.index,
    required this.unit,
    required this.buildingIndex,
    required this.cubit,
    required this.canDelete,
  });

  final int index;
  final HotelSubUnit unit;
  final int buildingIndex;
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
          gradient: const RadialGradient(
            center: Alignment(-1.0, 0),
            radius: 4.0,
            colors: [
              Color(0xFFC8DFF5),
              Color(0xFFDDEAF8),
              Color(0xFFEDF4FB),
              Colors.white,
            ],
            stops: [0.0, 0.03, 0.25, 1.0],
          ),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppText(
              text: 'بيانات الوحدة (${widget.index + 1})',
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.neutralDarkDark,
              alignment: Alignment.center,
            ),
            12.hs,
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
                    child: GestureDetector(
                      onTap: () => widget.cubit.removeHotelSubUnitFromBuilding(
                        widget.buildingIndex,
                        widget.unit.id,
                      ),
                      child: ImageSvgCustomWidget(
                        imgPath: FixedAssets.instance.deleteIC,
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
