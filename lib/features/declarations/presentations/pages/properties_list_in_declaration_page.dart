import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reta/features/declarations/presentations/cubit/declaration/declaration_details_states.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../components/app_bar.dart';
import '../../../components/circular_progress_indicator_platform_widget.dart';
import '../../data/models/declaration_details_model.dart';
import '../../data/models/declaration_model.dart';
import '../components/add_new_property_button.dart';
import '../components/cancel_declaration_button.dart';
import '../components/empty_data_widget.dart';
import '../components/properties_list_in_declaration_header.dart';
import '../components/property_item_in_declaration.dart';
import '../components/submit_declaration_button.dart';
import '../components/unit_type_category_tab_widget.dart';
import '../cubit/declaration/declaration_details_cubit.dart';

class PropertiesListInDeclarationPage extends StatelessWidget {
  final DeclarationModel declarationModel;

  const PropertiesListInDeclarationPage(this.declarationModel, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (_) =>
          DeclarationDetailsCubit(declarationModel.id.toString())
            ..fetchDeclarationModel(),
      child: _PropertiesListInDeclarationView(
        declarationModel: declarationModel,
      ),
    );
  }
}

class _PropertiesListInDeclarationView extends StatelessWidget {
  final DeclarationModel declarationModel;

  const _PropertiesListInDeclarationView({required this.declarationModel});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.neutralLightMedium,
        appBar: MainAppBar(
          title: "قائمة العقارات داخل الإقرار",
          backgroundColor: AppColors.mainBlueIndigoDye,
          backButtonIconColor: Colors.white,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 16.sp),
        ),
        body: SizedBox(
          child: BlocBuilder<DeclarationDetailsCubit, DeclarationDetailsStates>(
            builder: (context, state) {
              if (state is DeclarationDetailsLoading) {
                return CircularProgressIndicatorPlatformWidget();
              }
              if (state is DeclarationDetailsLoaded) {
                return Column(
                  children: [
                    PropertiesListInDeclarationHeader(
                      declarationModel.declarationTypeText ?? "",
                      declarationModel.statusId != "3",
                    ),
                    if (declarationModel.statusId != "3")
                      SizedBox(height: 30.h),
                    if (declarationModel.statusId != "3")
                      AddNewPropertyButton(onAdd: () {}),
                    SizedBox(height: 10.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Row(
                        textDirection: TextDirection.rtl,
                        children: [
                          Expanded(
                            flex: 5,
                            child: SubmitDeclarationButton(onSubmit: () {}),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            flex: 3,
                            child: CancelDeclarationButton(onCancel: () {}),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24.h),
                    UnitTypeCategoryTabWidget(state.selectedCategoryIndex, (
                      int index,
                    ) {
                      context
                          .read<DeclarationDetailsCubit>()
                          .updatedSelectedCategoryIndex(index);
                    }, state.activeCategories),
                    SizedBox(height: 4.h),
                    Expanded(
                      child: state.detailsModel?.unitsCount.total == 0
                          ? EmptyDataWidget(title: "لم يتم إضافة أي عقار بعد")
                          : ListView.builder(
                              itemCount: state.units == null
                                  ? 0
                                  : state.units.length,
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.w,
                                vertical: 20.h,
                              ),
                              itemBuilder: (_, index) {
                                final summary = getUnitSummary(
                                  state.units[index],
                                  state.activeCategories[state
                                      .selectedCategoryIndex],
                                );
                                log("summary: $summary");

                                return Padding(
                                  padding: EdgeInsets.only(bottom: 15.h),
                                  child: PropertyItemInDeclaration(
                                    onDelete: () {},
                                    onEdit: () {},
                                    propertyTypeText: getPropertyTypeText(
                                      summary,
                                    ),
                                    governorateText: getGovernorateText(
                                      summary,
                                    ),
                                    districtText: getDistrictText(summary),
                                    regionText: getRegionText(summary),
                                    realEstateFloorText: getRealEstateFloorText(
                                      summary,
                                    ),
                                    realEstateCode: getRealEstateCode(summary),
                                    unitUnitNum: getUnitUnitNum(summary),
                                    unitTypeText: getUnitTypeText(summary),
                                    canEditOrRemove:
                                        state.detailsModel?.statusId != "3",
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                );
              } else if (state is DeclarationDetailsError) {
                return Center(child: Text("حدث خطأ: ${state.message}"));
              }
              return Center(child: Text("حدث خطأ"));
            },
          ),
        ),
      ),
    );
  }

  String getPropertyTypeText(Map<String, dynamic> data) {
    return data['usage_type'] ?? "-";
  }

  String getGovernorateText(Map<String, dynamic> data) {
    return data['governorate_text'] ?? "-";
  }

  String getDistrictText(Map<String, dynamic> data) {
    return data['district_text'] ?? "-";
  }

  String getRegionText(Map<String, dynamic> data) {
    return data['region_other'] ?? data['region_text'] ?? "-";
  }

  String getRealEstateCode(Map<String, dynamic> data) {
    return data['real_estate_code'] ?? "-";
  }

  String getUnitTypeText(Map<String, dynamic> data) {
    return data['unit_type_text'] ?? "-";
  }

  String getUnitUnitNum(Map<String, dynamic> data) {
    return data['unit_unit_num'] ?? "-";
  }

  String getRealEstateFloorText(Map<String, dynamic> data) {
    return data['real_estate_floor_other_text'] ??
        data['real_estate_floor_text'] ??
        "-";
  }

  Map<String, dynamic> getUnitSummary(
    Map<String, dynamic> unit,
    CategoryConfig category,
  ) {
    return {for (final field in category.summaryFields) field: unit[field]};
  }
}
