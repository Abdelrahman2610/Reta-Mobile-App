import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reta/core/helpers/app_enum.dart';
import 'package:reta/core/helpers/extensions/unit_type.dart';
import 'package:reta/features/declarations/presentations/cubit/units/unit_data/unit_data_cubit.dart';
import 'package:reta/features/declarations/presentations/pages/units/units_data_pages/administrative_unit_page.dart';
import 'package:reta/features/declarations/presentations/pages/units/units_data_pages/commercial_unit_page.dart';
import 'package:reta/features/declarations/presentations/pages/units/units_data_pages/components/location_card.dart';
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
    required this.isUrban,
    required this.locationData,
  });

  final String? otherName;
  final ApplicantType applicantType;
  final UnitType unitType;
  final Map<String, dynamic>? applicantPayload;
  final Map<String, dynamic>? locationData;
  final MapLocationResult? mapLocationResult;
  final bool isUrban;

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
                              if (unitType == UnitType.residential ||
                                  unitType == UnitType.commercial ||
                                  unitType == UnitType.administrative ||
                                  unitType == UnitType.fixedInstallations ||
                                  unitType == UnitType.minesAndQuarries ||
                                  unitType == UnitType.vacantLand)
                                if (mapLocationResult != null) ...[
                                  LocationCard(
                                    mapLocationResult: mapLocationResult,
                                    hideEditButton: locationData != null,
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
                                  mapLocationResult: mapLocationResult,
                                  isUrban: isUrban,
                                  locationData: locationData,
                                ),
                                UnitType.hotelFacility => HotelFacilityPage(
                                  unitCubit: cubit,
                                  mapLocationResult: mapLocationResult,
                                  isUrban: isUrban,
                                  locationData: locationData,
                                ),
                                UnitType.industrialFacility =>
                                  IndustrialFacilityPage(
                                    unitCubit: cubit,
                                    mapLocationResult: mapLocationResult,
                                    isUrban: isUrban,
                                    locationData: locationData,
                                  ),
                                UnitType.productionFacility =>
                                  ProductionFacilityUnitPage(
                                    unitCubit: cubit,
                                    mapLocationResult: mapLocationResult,
                                    isUrban: isUrban,
                                    locationData: locationData,
                                  ),
                                UnitType.petroleumFacility =>
                                  PetroleumFacilityUnitPage(
                                    unitCubit: cubit,
                                    mapLocationResult: mapLocationResult,
                                    isUrban: isUrban,
                                    locationData: locationData,
                                  ),
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
                              cubit.onSaveDataTapped(
                                context,
                                unitType,
                                mapLocationResult,
                              );
                            }
                          },
                          onCancel: () => cubit.onCancelButtonTapped(context),
                          onSaveAndAddOther: () {
                            if (cubit.validate()) {
                              cubit.onSaveAndAddOther(
                                context,
                                unitType,
                                mapLocationResult,
                              );
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
}
