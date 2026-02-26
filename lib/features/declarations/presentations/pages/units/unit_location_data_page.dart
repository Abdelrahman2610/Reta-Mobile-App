import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reta/core/helpers/app_enum.dart';
import 'package:reta/features/declarations/presentations/components/app_drop_down.dart';

import '../../../../../core/helpers/extensions/applicant_type.dart';
import '../../../../../core/helpers/extensions/dimensions.dart';
import '../../../../../core/helpers/extensions/unit_type.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../components/app_bar.dart';
import '../../../../components/app_button.dart';
import '../../../../components/app_container.dart';
import '../../../../components/app_text.dart';
import '../../../../components/app_text_form_field.dart';
import '../../components/app_drop_down_option.dart';
import '../../components/declaration_data_tab.dart';
import '../../components/units/unit_title.dart';
import '../../cubit/units/location/unit_location_cubit.dart';
import '../../cubit/units/location/unit_location_states.dart';

class UnitLocationDataPage extends StatelessWidget {
  const UnitLocationDataPage({
    super.key,
    required this.unitType,
    required this.applicantType,
  });

  final UnitType unitType;
  final ApplicantType applicantType;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          UnitLocationCubit(unitType: unitType, applicantType: applicantType),
      child: _UnitLocationDataPage(),
    );
  }
}

class _UnitLocationDataPage extends StatelessWidget {
  const _UnitLocationDataPage();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UnitLocationCubit>();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: MainAppBar(
          title: 'إقرار ${cubit.applicantType.label}',
          backgroundColor: AppColors.mainBlueIndigoDye,
          backButtonIconColor: Colors.white,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.neutralLightMedium,
        body: Form(
          key: cubit.formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                31.hs,
                UnitTitle(title: cubit.unitType.label),
                10.hs,
                AppContainer(
                  height: 93,
                  child: Row(
                    children: [
                      DeclarationDataTab(
                        declarationsType: DeclarationsDataType.locationData,
                        isSelected: true,
                        isFinished: false,
                      ),
                      DeclarationDataTab(
                        declarationsType: DeclarationsDataType.unitData,
                        isSelected: false,
                        isFinished: false,
                      ),
                    ],
                  ),
                ),
                10.hs,
                AppContainer(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 24.h,
                  ),
                  child: BlocBuilder<UnitLocationCubit, UnitLocationState>(
                    builder: (context, state) {
                      final districtsItems = cubit.getDistricts(
                        state.selectedGovernorate,
                      );
                      final neighborhoodItems = cubit.getNeighborhoods(
                        state.selectedDistrict,
                      );
                      final streetItems = cubit.getStreets(
                        state.selectedNeighborhood,
                      );
                      final buildingItems = cubit.getBuildingNumbers(
                        state.selectedStreet,
                      );
                      return Column(
                        children: [
                          AppText(
                            text: 'بيانات الموقع',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.mainBlueIndigoDye,
                          ),
                          24.hs,

                          AppDropdownField<String>(
                            labelText: 'المحافظة',
                            labelRequired: true,
                            hintText: 'اختر المحافظة',
                            value: state.selectedGovernorate,
                            items: cubit.governorates
                                .map((g) => appDropDownOption(label: g))
                                .toList(),
                            onChanged: cubit.selectGovernorate,
                            validator: (v) =>
                                v == null ? 'هذا الحقل مطلوب' : null,
                          ),
                          16.hs,

                          AppDropdownField<String>(
                            labelText: 'المأمورية',
                            labelRequired: true,
                            hintText: 'اختر المأمورية المتاحة',
                            value: _safeValue(
                              state.selectedDistrict,
                              districtsItems,
                            ),
                            enabled: state.selectedGovernorate != null,
                            filledColor: state.selectedGovernorate == null
                                ? AppColors.neutralLightLight
                                : null,
                            items: cubit
                                .getDistricts(state.selectedGovernorate)
                                .map((d) => appDropDownOption(label: d))
                                .toList(),
                            onChanged: cubit.selectDistrict,
                            validator: (v) =>
                                v == null ? 'هذا الحقل مطلوب' : null,
                          ),
                          16.hs,
                          if (state.isDistrictOther) ...[
                            AppTextFormField(
                              labelText: 'اسم المأمورية',
                              labelRequired: true,
                              controller: cubit.districtOtherController,
                              onChanged: cubit.onDistrictOtherChanged,
                              hintText: 'ادخل اسم المأمورية',
                              validator: (v) => v == null || v.isEmpty
                                  ? 'هذا الحقل مطلوب'
                                  : null,
                            ),
                            16.hs,
                          ],

                          AppDropdownField<String>(
                            labelText: 'الشياخة',
                            labelRequired: true,
                            hintText: 'اختر الشياخة',
                            value: _safeValue(
                              state.selectedNeighborhood,
                              neighborhoodItems,
                            ),
                            enabled:
                                state.selectedDistrict != null &&
                                (!state.isDistrictOther ||
                                    cubit
                                        .districtOtherController
                                        .text
                                        .isNotEmpty),
                            filledColor:
                                (state.selectedDistrict == null ||
                                    (state.isDistrictOther &&
                                        (state.districtOtherText?.isEmpty ??
                                            false)))
                                ? AppColors.neutralLightLight
                                : null,
                            items: cubit
                                .getNeighborhoods(state.selectedDistrict)
                                .map((n) => appDropDownOption(label: n))
                                .toList(),
                            onChanged: cubit.selectNeighborhood,
                            validator: (v) =>
                                v == null ? 'هذا الحقل مطلوب' : null,
                          ),
                          16.hs,
                          if (state.isNeighborhoodOther) ...[
                            AppTextFormField(
                              labelText: 'اسم الشياخة أو المنطقة',
                              labelRequired: true,
                              controller: cubit.neighborhoodOtherController,
                              onChanged: cubit.onNeighborhoodOtherChanged,
                              hintText: 'ادخل اسم الشياخة / المنطقة',
                              validator: (v) => v == null || v.isEmpty
                                  ? 'هذا الحقل مطلوب'
                                  : null,
                            ),
                            16.hs,
                          ],

                          AppDropdownField<String>(
                            labelText: 'الشارع',
                            labelRequired: true,
                            hintText: 'اختر الشارع',
                            value: _safeValue(
                              state.selectedStreet,
                              streetItems,
                            ),
                            enabled:
                                state.selectedNeighborhood != null &&
                                (!state.isNeighborhoodOther ||
                                    cubit
                                        .neighborhoodOtherController
                                        .text
                                        .isNotEmpty),
                            filledColor:
                                (state.selectedNeighborhood == null ||
                                    (state.isNeighborhoodOther &&
                                        (state.neighborhoodOtherText?.isEmpty ??
                                            false)))
                                ? AppColors.neutralLightLight
                                : null,
                            items: cubit
                                .getStreets(state.selectedNeighborhood)
                                .map((s) => appDropDownOption(label: s))
                                .toList(),
                            onChanged: cubit.selectStreet,
                            validator: (v) =>
                                v == null ? 'هذا الحقل مطلوب' : null,
                          ),
                          16.hs,
                          if (state.isStreetOther) ...[
                            AppTextFormField(
                              labelText: 'الشارع',
                              labelRequired: true,
                              controller: cubit.streetOtherController,
                              onChanged: cubit.onStreetOtherChanged,
                              hintText: 'ادخل اسم الشارع',
                              validator: (v) => v == null || v.isEmpty
                                  ? 'هذا الحقل مطلوب'
                                  : null,
                            ),
                            16.hs,
                          ],

                          AppDropdownField<String>(
                            labelText: 'رقم العقار',
                            labelRequired: true,
                            hintText: 'اختر رقم العقار',
                            value: _safeValue(
                              state.selectedBuildingNumber,
                              buildingItems,
                            ),
                            enabled:
                                state.selectedStreet != null &&
                                (!state.isStreetOther ||
                                    cubit
                                        .streetOtherController
                                        .text
                                        .isNotEmpty),
                            filledColor:
                                (state.selectedStreet == null ||
                                    (state.isStreetOther &&
                                        (state.streetOtherText?.isEmpty ??
                                            false)))
                                ? AppColors.neutralLightLight
                                : null,
                            items: cubit
                                .getBuildingNumbers(
                                  state.selectedStreet ??
                                      cubit.streetOtherController.text.trim(),
                                )
                                .map((b) => appDropDownOption(label: b))
                                .toList(),
                            onChanged: cubit.selectBuildingNumber,
                            validator: (v) =>
                                v == null ? 'هذا الحقل مطلوب' : null,
                          ),
                          16.hs,
                          if (state.isBuildingNumberOther) ...[
                            AppTextFormField(
                              labelText: 'رقم العقار',
                              labelRequired: true,
                              controller: cubit.buildingNumberOtherController,
                              hintText: 'ادخل رقم العقار',
                              keyboardType: TextInputType.number,
                              validator: (v) => v == null || v.isEmpty
                                  ? 'هذا الحقل مطلوب'
                                  : null,
                            ),
                            16.hs,
                          ],
                        ],
                      );
                    },
                  ),
                ),
                16.hs,
                AppContainer(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 24.h,
                  ),
                  child: AppButton(
                    label: 'التالي',
                    backgroundColor: AppColors.highlightDarkest,
                    textColor: AppColors.white,
                    fontSize: 12.sp,
                    alignment: Alignment.center,
                    onTap: () {
                      if (cubit.validate()) {
                        cubit.onNextButtonTapped(context, cubit.applicantType);
                      }
                    },
                  ),
                ),
                26.hs,
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? _safeValue(String? value, List<String> items) {
    if (value == null) return null;
    return items.contains(value) ? value : null;
  }
}
