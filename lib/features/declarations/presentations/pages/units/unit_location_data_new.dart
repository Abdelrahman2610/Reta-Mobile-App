import 'package:dotted_border/dotted_border.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reta/core/helpers/app_enum.dart';
import 'package:reta/core/helpers/fixed_assets.dart';
import 'package:reta/features/components/app_loading.dart';
import 'package:reta/features/components/app_text_form_field.dart';
import 'package:reta/features/components/image_svg_custom_widget.dart';
import 'package:reta/features/declarations/presentations/pages/units/unit_location_data_page.dart';

import '../../../../../core/helpers/extensions/applicant_type.dart';
import '../../../../../core/helpers/extensions/dimensions.dart';
import '../../../../../core/helpers/extensions/unit_type.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../components/app_bar.dart';
import '../../../../components/app_button.dart';
import '../../../../components/app_container.dart';
import '../../../../components/app_text.dart';
import '../../../data/models/declarations_lookups.dart';
import '../../../data/models/map_location_result.dart';
import '../../components/checkbox_with_title.dart';
import '../../components/declaration_data_tab.dart';
import '../../components/units/unit_title.dart';
import '../../cubit/declaration_lookups_cubit.dart';
import '../../cubit/units/location/unit_location_cubit.dart';
import '../../cubit/units/location/unit_location_states.dart';
import 'map_web_view_screen.dart';

class UnitLocationDataPageNew extends StatelessWidget {
  const UnitLocationDataPageNew({
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
      child: switch (unitType) {
        UnitType.residential ||
        UnitType.commercial ||
        UnitType.administrative ||
        UnitType.serviceUnit ||
        UnitType.vacantLand ||
        UnitType.fixedInstallations => const UnitLocationDataPageBodyNew(),
        UnitType.serviceFacility ||
        UnitType.hotelFacility ||
        UnitType.industrialFacility ||
        UnitType.productionFacility ||
        UnitType.petroleumFacility ||
        UnitType.minesAndQuarries => const UnitLocationDataPageBodyOld(),
      },
    );
  }
}

class UnitLocationDataPageBodyNew extends StatefulWidget {
  const UnitLocationDataPageBodyNew({super.key});

  @override
  State<UnitLocationDataPageBodyNew> createState() =>
      UnitLocationDataPageStateNew();
}

class UnitLocationDataPageStateNew extends State<UnitLocationDataPageBodyNew> {
  MapLocationResult? _mapData;
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
                        child: BlocBuilder<UnitLocationCubit, UnitLocationState>(
                          builder: (context, state) {
                            return Column(
                              children: [
                                DottedBorder(
                                  options: RoundedRectDottedBorderOptions(
                                    radius: Radius.circular(12.r),
                                    color: AppColors.neutralLightDarkest,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20.w,
                                      vertical: 20.h,
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 16.w,
                                            vertical: 16.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.warningLight,
                                            borderRadius: BorderRadius.circular(
                                              16.r,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              ImageSvgCustomWidget(
                                                imgPath: FixedAssets
                                                    .instance
                                                    .warningInfoIC,
                                              ),
                                              16.ws,
                                              Expanded(
                                                child: AppText(
                                                  text:
                                                      'إذا كان العقار تابعًا لهيئة المجتمعات العمرانية، يرجى تحديد ذلك قبل فتح الخريطة.',
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors
                                                      .neutralDarkDarkest,
                                                  maxLines: 3,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        15.hs,
                                        CheckBoxWithTitle(
                                          label: 'هيئة المجتمعات العمرانية',
                                          isSelected: state.isUrban,
                                          onSelectTapped: cubit.onIsUrbanTapped,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                40.hs,
                                AppText(
                                  text:
                                      'يرجى تحديد موقع العقار من الخريطة لاستكمال إدخال البيانات.',
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.mainBlueIndigoDye,
                                  alignment: AlignmentDirectional.center,
                                  textAlign: TextAlign.center,
                                  maxLines: 3,
                                ),
                                20.hs,
                                AppButton(
                                  label: 'تحديد العقار من الخريطة',
                                  fontSize: 14,
                                  height: 50.h,
                                  fontWeight: FontWeight.w600,
                                  backgroundColor: AppColors.mainOrange,
                                  icon: ImageSvgCustomWidget(
                                    imgPath: FixedAssets.instance.mapIC,
                                  ),
                                  iconLeft: false,
                                  onTap: () async {
                                    final result =
                                        await Navigator.push<
                                          MapLocationResult?
                                        >(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => MapWebViewScreen(
                                              urban: state.isUrban ? 1 : 0,
                                              suffix: addSuffix(
                                                _mapData,
                                                state,
                                                cubit,
                                              ),
                                            ),
                                          ),
                                        );
                                    if (result != null) {
                                      cubit.setMapData(result);
                                      setState(() => _mapData = result);
                                    }
                                  },
                                ),
                                10.hs,
                                AppText(
                                  text:
                                      'سيتم فتح الخريطة لتحديد موقع العقار، ثم العودة لاستكمال البيانات.',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16.sp,
                                  color: AppColors.neutralDarkLight,
                                  maxLines: 3,
                                  alignment: Alignment.center,
                                  textAlign: TextAlign.center,
                                ),
                                40.hs,
                                DottedLine(),
                                54.hs,
                                AppTextFormField(
                                  labelText: 'رقم العقار/المبني المتعارف عليه ',
                                  hintText: 'ادخل رقم العقار',
                                  controller: cubit.knownBuildNumController,
                                  labelRequired: _mapData?.streetNumber == null,
                                  validator: (v) {
                                    if (_mapData?.streetNumber == null) {
                                      if (v == null || v.isEmpty) {
                                        return 'هذا الحقل مطلوب';
                                      }
                                      if (double.tryParse(v) == null) {
                                        return 'يجب إدخال رقم صحيح';
                                      }
                                      return null;
                                    }
                                    return null;
                                  },
                                ),
                                16.hs,
                                CheckBoxWithTitle(
                                  label:
                                      'العقار المحدد هو أقرب عقار للموقع الخاص بالوحدة محل الإقرار',
                                  isSelected: state.isNearestProperty,
                                  onSelectTapped:
                                      cubit.onIsNearestPropertyTapped,
                                ),
                                16.hs,
                                AppTextFormField(
                                  labelText: 'معلومات إضافية لوصف عنوان العقار',
                                  hintText: 'معلومات إضافية',
                                  maxLines: 7,
                                  minLines: 7,
                                  controller:
                                      cubit.addressAdditionalInfoController,
                                ),
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

  String? addSuffix(
    MapLocationResult? mapData,
    state,
    UnitLocationCubit cubit,
  ) {
    final lookupsCubit = context.read<DeclarationLookupsCubit>();
    final propertyTypeId = lookupsCubit.lookups?.propertyTypes
        .firstWhere(
          (p) => p.name == cubit.unitType.label,
          orElse: () => DeclarationLookup(id: -1, name: ''),
        )
        .id;
    final int urban = state.isUrban ? 1 : 0;

    String suffix = '?urban=$urban';
    if (mapData != null) {
      final List<dynamic> location =
          mapData.geometry?['geojson']?['coordinates'][0][0][0];
      suffix += '&lng=${location[0]}&lat=${location[1]}&&unit=unit';
      if (cubit.unitId != '-1') {
        suffix += '&id=${cubit.unitId}';
      }

      if (propertyTypeId != -1) {
        suffix += '&property_type_id=$propertyTypeId';
      }
      return suffix;
    }
    return '?urban=$urban';
  }
}
