import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reta/core/helpers/app_enum.dart';
import 'package:reta/features/components/app_loading.dart';
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
import '../../../data/models/declarations_lookups.dart';
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
    required this.declarationId,
    this.locationData,
    this.unitData,
    this.otherName,
    this.applicantData,
  });

  final String? otherName;
  final UnitType unitType;
  final ApplicantType applicantType;
  final int declarationId;
  final Map<String, dynamic>? locationData;
  final Map<String, dynamic>? unitData;
  final Map<String, dynamic>? applicantData;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UnitLocationCubit(
        unitType: unitType,
        applicantType: applicantType,
        declarationId: declarationId,
        locationData: locationData,
        unitData: unitData,
        otherName: otherName,
        applicantData: applicantData,
      ),
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
          title:
              'إقرار ${cubit.applicantType == ApplicantType.other ? (cubit.otherName ?? cubit.applicantType.label) : cubit.applicantType.label}',
          backgroundColor: AppColors.mainBlueIndigoDye,
          backButtonIconColor: Colors.white,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.neutralLightMedium,
        body: BlocBuilder<UnitLocationCubit, UnitLocationState>(
          builder: (context, state) {
            return AppLoadingOverlay(
              isLoading:
                  state.isLoadingGovernorates ||
                  state.isLoadingDistricts ||
                  state.isLoadingVillages,
              child: Form(
                key: cubit.formKey,
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: [
                      31.hs,
                      UnitTitle(title: cubit.unitType.displayLabel),
                      10.hs,
                      AppContainer(
                        height: 93,
                        child: Row(
                          children: [
                            DeclarationDataTab(
                              declarationsType:
                                  DeclarationsDataType.locationData,
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
                        child:
                            BlocBuilder<UnitLocationCubit, UnitLocationState>(
                              builder: (context, state) {
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
                                      items: state.isLoadingGovernorates
                                          ? []
                                          : state.governoratesList
                                                .map(
                                                  (g) => appDropDownOption(
                                                    label: g.name,
                                                  ),
                                                )
                                                .toList(),
                                      onChanged: (value) {
                                        final selected = state.governoratesList
                                            .firstWhere(
                                              (g) => g.name == value,
                                              orElse: () => DeclarationLookup(
                                                id: 0,
                                                name: '',
                                              ),
                                            );
                                        cubit.selectGovernorate(
                                          value,
                                          selected.id,
                                        );
                                      },
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
                                        (state.districtsList ?? [])
                                            .map((v) => v.name)
                                            .toList(),
                                      ),
                                      enabled:
                                          state.selectedGovernorate != null,
                                      filledColor:
                                          state.selectedGovernorate == null
                                          ? AppColors.neutralLightLight
                                          : null,
                                      items: (state.districtsList ?? [])
                                          .map(
                                            (d) => appDropDownOption(
                                              label: d.name,
                                            ),
                                          )
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
                                        controller:
                                            cubit.districtOtherController,
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
                                        (state.villagesList ?? [])
                                            .map((s) => s.name)
                                            .toList(),
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
                                                  (state
                                                          .districtOtherText
                                                          ?.isEmpty ??
                                                      false)))
                                          ? AppColors.neutralLightLight
                                          : null,

                                      items: (state.villagesList ?? [])
                                          .map(
                                            (s) => appDropDownOption(
                                              label: s.name,
                                            ),
                                          )
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
                                        controller:
                                            cubit.neighborhoodOtherController,
                                        onChanged:
                                            cubit.onNeighborhoodOtherChanged,
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
                                        (state.streetsList ?? [])
                                            .map((s) => s.name)
                                            .toList(),
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
                                                  (state
                                                          .neighborhoodOtherText
                                                          ?.isEmpty ??
                                                      false)))
                                          ? AppColors.neutralLightLight
                                          : null,
                                      items: (state.streetsList ?? [])
                                          .map(
                                            (s) => appDropDownOption(
                                              label: s.name,
                                            ),
                                          )
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
                                        (state.buildingList ?? [])
                                            .map((v) => v.name)
                                            .toList(),
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
                                                  (state
                                                          .streetOtherText
                                                          ?.isEmpty ??
                                                      false)))
                                          ? AppColors.neutralLightLight
                                          : null,
                                      items: (state.buildingList ?? [])
                                          .map(
                                            (b) => appDropDownOption(
                                              label: b.name,
                                            ),
                                          )
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
                                        controller:
                                            cubit.buildingNumberOtherController,
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
                              cubit.onNextButtonTapped(
                                context,
                                cubit.applicantType,
                                context.read<UnitLocationCubit>().otherName,
                              );
                            }
                          },
                        ),
                      ),
                      26.hs,
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String? _safeValue(String? value, List<String> items) {
    if (value == null) return null;
    return items.contains(value) ? value : null;
  }
}
