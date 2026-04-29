import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reta/core/helpers/app_enum.dart';
import 'package:reta/core/helpers/extensions/unit_type.dart';
import 'package:reta/features/components/app_button.dart';
import 'package:reta/features/declarations/presentations/cubit/units/unit_data/unit_data_cubit.dart';
import 'package:reta/features/declarations/presentations/pages/units/units_data_pages/administrative_unit_page.dart';
import 'package:reta/features/declarations/presentations/pages/units/units_data_pages/commercial_unit_page.dart';
import 'package:reta/features/declarations/presentations/pages/units/units_data_pages/components/unit_buttons.dart';
import 'package:reta/features/declarations/presentations/pages/units/units_data_pages/fixed_installation_unit_page.dart';
import 'package:reta/features/declarations/presentations/pages/units/units_data_pages/hotel_unit_page.dart';
import 'package:reta/features/declarations/presentations/pages/units/units_data_pages/industrial_unit_page.dart';
import 'package:reta/features/declarations/presentations/pages/units/units_data_pages/mine_unit_page.dart';
import 'package:reta/features/declarations/presentations/pages/units/units_data_pages/petroleum_facility_unit_page.dart';
import 'package:reta/features/declarations/presentations/pages/units/units_data_pages/production_facility_unit_page.dart';
import 'package:reta/features/declarations/presentations/pages/units/units_data_pages/residential_unit_page.dart';
import 'package:reta/features/declarations/presentations/pages/units/units_data_pages/service_facility_page.dart';
import 'package:reta/features/declarations/presentations/pages/units/units_data_pages/service_unit_page.dart';
import 'package:reta/features/declarations/presentations/pages/units/units_data_pages/vacant_land_page.dart';

import '../../../../../core/helpers/extensions/applicant_type.dart';
import '../../../../../core/helpers/extensions/dimensions.dart';
import '../../../../../core/helpers/loading_popup.dart';
import '../../../../../core/helpers/runtime_data.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../components/app_bar.dart';
import '../../../../components/app_container.dart';
import '../../../../components/app_text.dart';
import '../../../data/models/map_location_result.dart';
import '../../components/declaration_data_tab.dart';
import '../../components/units/unit_title.dart';
import '../../cubit/units/unit_data/unit_data_state.dart';

class UnitData extends StatelessWidget {
  const UnitData({
    super.key,
    required this.applicantType,
    required this.unitType,
    this.otherName,
    this.applicantPayload,
    this.mapLocationResult,
  });

  final String? otherName;
  final ApplicantType applicantType;
  final UnitType unitType;
  final Map<String, dynamic>? applicantPayload;
  final MapLocationResult? mapLocationResult;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UnitDataCubit>();
    return BlocProvider.value(
      value: cubit,
      child: BlocListener<UnitDataCubit, UnitDataState>(
        listenWhen: (prev, curr) => prev.errorMessage != curr.errorMessage,
        listener: (BuildContext context, UnitDataState state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: AppText(
                  text: state.errorMessage!,
                  maxLines: 3,
                  color: AppColors.white,
                  alignment: Alignment.center,
                ),
                backgroundColor: AppColors.errorDark,
              ),
            );

            cubit.clearError();
          }
        },
        child: BlocConsumer<UnitDataCubit, UnitDataState>(
          listenWhen: (prev, curr) =>
              prev.isLoading != curr.isLoading ||
              prev.isFloorLoading != curr.isFloorLoading,
          listener: (context, state) async {
            if (state.isLoading || state.isFloorLoading) {
              loadingPopup(RuntimeData.getCurrentContext()!);
            }
            if (!state.isLoading && !state.isFloorLoading) {
              Navigator.pop(RuntimeData.getCurrentContext()!);
            }
          },
          buildWhen: (prev, curr) => prev.isLoading != curr.isLoading,
          builder: (context, state) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                backgroundColor: AppColors.neutralLightMedium,
                appBar: MainAppBar(
                  title: 'إقرار ${otherName ?? applicantType.label}',
                  backgroundColor: AppColors.mainBlueIndigoDye,
                  backButtonIconColor: Colors.white,
                  titleTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                body: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      children: [
                        31.hs,
                        UnitTitle(title: unitType.unitLabel),
                        10.hs,
                        AppContainer(
                          height: 93,
                          child: Row(
                            children: [
                              DeclarationDataTab(
                                declarationsType:
                                    DeclarationsDataType.locationData,
                                isSelected: false,
                                isFinished: true,
                              ),
                              DeclarationDataTab(
                                declarationsType: unitType.tabEnum,
                                isSelected: true,
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
                          child: Column(
                            children: [
                              AppText(
                                text: unitType.title,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.mainBlueIndigoDye,
                              ),
                              24.hs,
                              if (mapLocationResult != null) ...[
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20.w,
                                    vertical: 20.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
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
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.08),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      AppText(
                                        text: 'بيانات الموقع',
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.neutralDarkDark,
                                      ),
                                      10.hs,
                                      Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12.w,
                                          vertical: 12.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.white,
                                          borderRadius: BorderRadius.circular(
                                            6.r,
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            AppText(
                                              text: 'العنوان',
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  AppColors.neutralDarkMedium,
                                            ),
                                            4.hs,
                                            AppText(
                                              text: buildAddress(
                                                mapLocationResult,
                                              ),
                                              textAlign: TextAlign.right,
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w600,
                                              maxLines: 3,
                                              color:
                                                  AppColors.neutralDarkDarkest,
                                            ),
                                          ],
                                        ),
                                      ),
                                      20.hs,
                                      AppButton(
                                        label: 'تعديل',
                                        backgroundColor:
                                            AppColors.highlightDarkest,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                        textColor:
                                            AppColors.neutralLightLightest,
                                        height: 50.h,
                                        onTap: () => Navigator.pop(context),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              switch (unitType) {
                                UnitType.residential => ResidentialUnitPage(
                                  unitCubit: cubit,
                                  applicantType: applicantType,
                                ),
                                UnitType.commercial => CommercialUnitPage(
                                  unitCubit: cubit,
                                  applicantType: applicantType,
                                ),
                                UnitType.administrative =>
                                  AdministrativeUnitPage(unitCubit: cubit),
                                UnitType.serviceUnit => ServiceUnitPage(
                                  unitCubit: cubit,
                                ),
                                UnitType.fixedInstallations =>
                                  FixedInstallationsPage(unitCubit: cubit),
                                UnitType.vacantLand => VacantLandPage(
                                  unitCubit: cubit,
                                ),
                                UnitType.serviceFacility => ServiceFacilityPage(
                                  unitCubit: cubit,
                                ),
                                UnitType.hotelFacility => HotelFacilityPage(
                                  unitCubit: cubit,
                                ),
                                UnitType.industrialFacility =>
                                  IndustrialFacilityPage(unitCubit: cubit),
                                UnitType.productionFacility =>
                                  ProductionFacilityUnitPage(unitCubit: cubit),
                                UnitType.petroleumFacility =>
                                  PetroleumFacilityUnitPage(unitCubit: cubit),
                                UnitType.minesAndQuarries => MineUnitPage(
                                  unitCubit: cubit,
                                ),
                              },
                            ],
                          ),
                        ),

                        16.hs,

                        UnitButtons(
                          cubit: cubit,
                          onSaveData: () {
                            if (cubit.validate()) {
                              cubit.onSaveDataTapped(context, unitType);
                            }
                          },
                          onCancel: () => cubit.onCancelButtonTapped(context),
                          onSaveAndAddOther: () {
                            if (cubit.validate()) {
                              cubit.onSaveAndAddOther(context, unitType);
                            }
                          },
                          unitType: unitType,
                        ),
                        26.hs,
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String buildAddress(MapLocationResult? mapLocation) {
    if (mapLocation == null) return '';
    final parts = <String>[];

    if (mapLocation.governorate != null) parts.add(mapLocation.governorate!);
    if (mapLocation.neighborhood != null) parts.add(mapLocation.neighborhood!);
    if (mapLocation.policeStation != null) {
      parts.add(mapLocation.policeStation!);
    }
    if (mapLocation.street != null) parts.add(mapLocation.street!);
    if (mapLocation.streetNumber != null) {
      parts.add(mapLocation.streetNumber.toString());
    }

    return parts.join('، ');
  }
}
