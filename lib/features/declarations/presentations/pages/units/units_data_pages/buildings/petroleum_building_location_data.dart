import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reta/core/helpers/app_enum.dart';
import 'package:reta/features/components/app_container.dart';
import 'package:reta/features/components/app_scaffold.dart';
import 'package:reta/features/declarations/presentations/cubit/units/unit_data/unit_data_cubit.dart';
import 'package:reta/features/declarations/presentations/cubit/units/unit_data/unit_data_state.dart';
import 'package:reta/features/declarations/presentations/pages/units/units_data_pages/components/location_card.dart';

import '../../../../../../../core/helpers/extensions/dimensions.dart';
import '../../../../../../../core/helpers/extensions/unit_type.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../components/app_text.dart';
import '../../../../../../components/app_text_form_field.dart';
import '../../../../../data/models/declarations_lookups.dart';
import '../../../../../data/models/map_location_result.dart';
import '../../../../components/cancel_declaration_button.dart';
import '../../../../components/checkbox_with_title.dart';
import '../../../../components/submit_declaration_button.dart';
import '../../../../cubit/declaration_lookups_cubit.dart';
import '../../map_web_view_screen.dart';
import '../components/calendar_icon.dart';

class PetroleumBuildingLocationData extends StatefulWidget {
  const PetroleumBuildingLocationData({
    super.key,
    required this.index,
    required this.isUrban,
    required this.isNew,
    this.mapLocationResult,
  });

  final int index;
  final bool isUrban;
  final bool isNew;
  final MapLocationResult? mapLocationResult;

  @override
  State<PetroleumBuildingLocationData> createState() =>
      _PetroleumBuildingLocationDataState();
}

class _PetroleumBuildingLocationDataState
    extends State<PetroleumBuildingLocationData> {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UnitDataCubit>();
    final building = cubit.petroBuildings[widget.index];

    return Material(
      child: AppScaffold(
        title: widget.index == 0
            ? 'وصف المبنى الرئيسي للمنشأة البترولية'
            : 'وصف مباني المنشأة البترولية',
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
                                        suffix: _buildSuffix(
                                          building.mapLocationResult,
                                          widget.isUrban,
                                          cubit.unitType,
                                          cubit.unitData != null
                                              ? cubit.unitData!['id'].toString()
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
                          AppTextFormField(
                            labelText: 'نوع المبنى',
                            labelRequired: true,
                            controller: building.buildingType,
                            hintText: 'إدخل نوع المبنى',
                            validator: (v) => v == null || v.isEmpty
                                ? 'هذا الحقل مطلوب'
                                : null,
                          ),
                          16.hs,
                          AppTextFormField(
                            labelText: 'التكلفة الدفترية للمبنى',
                            controller: building.bookCostBuilding,
                            keyboardType: TextInputType.number,
                            hintText: 'إدخل التكلفة الدفترية للمبنى',
                          ),
                          16.hs,
                          AppTextFormField(
                            labelText: 'تاريخ إنشاء المبنى',
                            labelRequired: true,
                            controller: building.buildingDate,
                            hintText: 'ادخل تاريخ إنشاء المبنى',
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
                                  building.buildingDate.text =
                                      '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
                                });
                              }
                            },
                            suffixWidget: CalendarIcon(
                              color: AppColors.neutralDarkLightest,
                            ),
                            validator: (v) => v == null || v.isEmpty
                                ? 'هذا الحقل مطلوب'
                                : null,
                          ),
                          16.hs,
                          AppTextFormField(
                            labelText: 'مساحة المبنى',
                            labelRequired: true,
                            hintText: 'المساحة الإجمالية بالمتر المربع',
                            controller: building.totalArea,
                            keyboardType: TextInputType.number,
                            validator: (v) => v == null || v.isEmpty
                                ? 'هذا الحقل مطلوب'
                                : null,
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
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.w,
                    vertical: 24.h,
                  ),
                  child: Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      Expanded(
                        flex: 5,
                        child: SubmitDeclarationButton(
                          label: 'حفظ البيانات',
                          borderColor: AppColors.successDark,
                          withIcon: false,
                          onSubmit: () async {
                            final nav = Navigator.of(context);
                            final saved = await cubit.savePetroleumBuilding(
                              widget.index,
                              widget.mapLocationResult,
                            );
                            if (saved) nav.pop(true);
                          },
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        flex: 3,
                        child: CancelDeclarationButton(
                          label: 'إلغاء',
                          withIcon: true,
                          onCancel: () async {
                            if (widget.isNew) {
                              await cubit.deletePetroleumBuilding(widget.index);
                            }
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  String? _buildSuffix(
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
