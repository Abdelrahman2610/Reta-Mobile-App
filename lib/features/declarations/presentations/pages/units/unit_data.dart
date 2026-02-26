import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reta/core/helpers/app_enum.dart';
import 'package:reta/features/declarations/presentations/cubit/units/unit_data/unit_data_cubit.dart';
import 'package:reta/features/declarations/presentations/pages/units/units_data_pages/administrative_unit_page.dart';
import 'package:reta/features/declarations/presentations/pages/units/units_data_pages/commercial_unit_page.dart';
import 'package:reta/features/declarations/presentations/pages/units/units_data_pages/fixed_installation_unit_page.dart';
import 'package:reta/features/declarations/presentations/pages/units/units_data_pages/residential_unit_page.dart';
import 'package:reta/features/declarations/presentations/pages/units/units_data_pages/service_unit_page.dart';

import '../../../../../core/helpers/extensions/applicant_type.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../components/app_bar.dart';

class UnitData extends StatelessWidget {
  const UnitData({
    super.key,
    required this.applicantType,
    required this.unitType,
  });

  final ApplicantType applicantType;
  final UnitType unitType;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UnitDataCubit>();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.neutralLightMedium,
        appBar: MainAppBar(
          title: 'إقرار ${applicantType.label}',
          backgroundColor: AppColors.mainBlueIndigoDye,
          backButtonIconColor: Colors.white,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        body: switch (unitType) {
          UnitType.residential => ResidentialUnitPage(
            unitCubit: cubit,
            applicantType: applicantType,
          ),
          UnitType.commercial => CommercialUnitPage(
            unitCubit: cubit,
            applicantType: applicantType,
          ),
          UnitType.administrative => AdministrativeUnitPage(unitCubit: cubit),
          UnitType.serviceUnit => ServiceUnitPage(
            applicantType: applicantType,
            unitCubit: cubit,
          ),
          // TODO: Handle this case.
          UnitType.fixedInstallations => FixedInstallationsPage(
            applicantType: applicantType,
            unitCubit: cubit,
          ),
          // TODO: Handle this case.
          UnitType.vacantLand => throw UnimplementedError(),
          // TODO: Handle this case.
          UnitType.serviceFacility => throw UnimplementedError(),
          // TODO: Handle this case.
          UnitType.hotelFacility => throw UnimplementedError(),
          // TODO: Handle this case.
          UnitType.industrialFacility => throw UnimplementedError(),
          // TODO: Handle this case.
          UnitType.productionFacility => throw UnimplementedError(),
          // TODO: Handle this case.
          UnitType.petroleumFacility => throw UnimplementedError(),
          // TODO: Handle this case.
          UnitType.minesAndQuarries => throw UnimplementedError(),
        },
      ),
    );
  }
}
