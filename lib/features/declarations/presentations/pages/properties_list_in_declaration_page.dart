import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:reta/core/helpers/app_enum.dart';
import 'package:reta/core/helpers/runtime_data.dart';
import 'package:reta/features/declarations/presentations/cubit/declaration/declaration_details_states.dart';
import 'package:reta/features/declarations/presentations/pages/provider_data_page.dart';
import 'package:reta/features/declarations/presentations/pages/select_applicant_type_page.dart';
import 'package:reta/features/declarations/presentations/pages/units/unit_location_data_page.dart';

import '../../../../core/helpers/extensions/applicant_type.dart';
import '../../../../core/helpers/extensions/unit_type.dart';
import '../../../../core/helpers/loading_popup.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/cubit/user_profile_cubit.dart';
import '../../../auth/presentation/cubit/user_profile_state.dart';
import '../../../components/app_bar.dart';
import '../../../components/circular_progress_indicator_platform_widget.dart';
import '../../../components/show_confirmation_dialog.dart';
import '../../data/models/declaration_details_model.dart';
import '../../data/models/declaration_model.dart';
import '../components/add_new_property_button.dart';
import '../components/cancel_declaration_button.dart';
import '../components/empty_data_widget.dart';
import '../components/properties_list_in_declaration_header.dart';
import '../components/property_item_in_declaration.dart';
import '../components/show_cancel_declaration_dialog.dart';
import '../components/show_submit_declaration_dialog.dart';
import '../components/submit_declaration_button.dart';
import '../components/unit_type_category_tab_widget.dart';
import '../cubit/declaration/declaration_details_cubit.dart';
import '../cubit/declaration_lookups_cubit.dart';

class PropertiesListInDeclarationPage extends StatelessWidget {
  final DeclarationModel declarationModel;
  final Function updateDeclarationList;

  const PropertiesListInDeclarationPage(
    this.declarationModel,
    this.updateDeclarationList, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (_) =>
          DeclarationDetailsCubit(declarationModel.id.toString())
            ..fetchDeclarationModel(),
      child: _PropertiesListInDeclarationView(
        declarationModel: declarationModel,
        updateDeclarationList: updateDeclarationList,
      ),
    );
  }
}

class _PropertiesListInDeclarationView extends StatelessWidget {
  final DeclarationModel declarationModel;
  final Function updateDeclarationList;

  const _PropertiesListInDeclarationView({
    required this.declarationModel,
    required this.updateDeclarationList,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<DeclarationDetailsCubit, DeclarationDetailsStates>(
      listener: (context, state) {
        _onStateChange(state, context);
      },
      child: Directionality(
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
              buildWhen: (previous, current) {
                return current is DeclarationDetailsLoading ||
                    current is DeclarationDetailsLoaded ||
                    current is DeclarationDetailsError;
              },
              builder: (context, state) {
                if (state is DeclarationDetailsLoading) {
                  return CircularProgressIndicatorPlatformWidget();
                }
                if (state is DeclarationDetailsLoaded) {
                  return Column(
                    children: [
                      BlocBuilder<UserProfileCubit, UserProfileState>(
                        builder: (context, userState) {
                          if (userState is! UserProfileLoaded) {
                            return const CircularProgressIndicatorPlatformWidget();
                          }
                          return PropertiesListInDeclarationHeader(
                            declarationModel.declarationTypeText ?? "",
                            declarationModel.statusId != "3",
                            onTap: () {
                              PersistentNavBarNavigator.pushNewScreen(
                                context,
                                screen: ProviderDataPage(
                                  declarationId: declarationModel.id ?? -1,
                                  applicantType:
                                      state
                                          .detailsModel
                                          ?.declarationTypeId
                                          .displayApplicant ??
                                      ApplicantType.owner,
                                  existingDeclaration: state.detailsModel,
                                  afterUpdating: () => context
                                      .read<DeclarationDetailsCubit>()
                                      .fetchDeclarationModel(),
                                  userModel: userState.userModel,
                                  applicantOtherName:
                                      state.detailsModel?.applicantRoleOther,
                                ),
                                withNavBar: true,
                                pageTransitionAnimation:
                                    PageTransitionAnimation.slideUp,
                              );
                            },
                          );
                        },
                      ),
                      if (declarationModel.statusId != "3")
                        SizedBox(height: 30.h),
                      if (declarationModel.statusId != "3")
                        AddNewPropertyButton(
                          onAdd: () {
                            PersistentNavBarNavigator.pushNewScreen(
                              context,
                              screen: SelectApplicantTypePage(
                                declarationId: declarationModel.id ?? -1,
                              ),
                              withNavBar: true,
                              pageTransitionAnimation:
                                  PageTransitionAnimation.slideUp,
                            );
                          },
                        ),
                      SizedBox(height: 10.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Row(
                          textDirection: TextDirection.rtl,
                          children: [
                            Expanded(
                              flex: 5,
                              child: SubmitDeclarationButton(
                                onSubmit: () {
                                  if (state.detailsModel?.unitsCount.total !=
                                      0) {
                                    showSubmitDeclarationDialog(
                                      RuntimeData.getCurrentContext()!,
                                      () {
                                        context
                                            .read<DeclarationDetailsCubit>()
                                            .submitDeclaration();
                                      },
                                    );
                                  }
                                },
                                isEnabled:
                                    state.detailsModel?.unitsCount.total != 0,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              flex: 3,
                              child: CancelDeclarationButton(
                                onCancel: () {
                                  showCancelDeclarationDialog(
                                    RuntimeData.getCurrentContext()!,
                                    () {
                                      context
                                          .read<DeclarationDetailsCubit>()
                                          .deleteDeclarationModel();
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 24.h),
                      if (state.detailsModel?.unitsCount.total != 0)
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
                            ? Padding(
                                padding: EdgeInsets.only(
                                  left: 20.w,
                                  right: 20.w,
                                  bottom: 20.h,
                                ),
                                child: EmptyDataWidget(
                                  title: "لم يتم إضافة أي عقار بعد",
                                ),
                              )
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
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 15.h),
                                    child: PropertyItemInDeclaration(
                                      onDelete: () {
                                        showDeletePropertyDialog(
                                          RuntimeData.getCurrentContext()!,
                                          () {
                                            context
                                                .read<DeclarationDetailsCubit>()
                                                .deleteDeclarationUnit(
                                                  state
                                                      .activeCategories[state
                                                          .selectedCategoryIndex]
                                                      .deleteLabel,
                                                  getId(
                                                        state
                                                            .activeCategories[state
                                                                .selectedCategoryIndex]
                                                            .deleteID,
                                                        index,
                                                        state
                                                                .detailsModel
                                                                ?.data ??
                                                            {},
                                                      ) ??
                                                      "-1",
                                                );
                                          },
                                          unitId: 5,
                                        );
                                      },
                                      onEdit: () async {
                                        final lookupsCubit = context
                                            .read<DeclarationLookupsCubit>();

                                        if (lookupsCubit.lookups == null) {
                                          await lookupsCubit.fetchLookups();
                                        }

                                        if (!context.mounted) return;

                                        PersistentNavBarNavigator.pushNewScreen(
                                          context,
                                          screen: MultiBlocProvider(
                                            providers: [
                                              BlocProvider.value(
                                                value: lookupsCubit,
                                              ),
                                            ],
                                            child: UnitLocationDataPage(
                                              applicantData:
                                                  state.detailsModel?.data,
                                              declarationId:
                                                  declarationModel.id ?? -1,
                                              unitType:
                                                  (summary['property_type_text']
                                                          as String)
                                                      .toUnitType,
                                              applicantType:
                                                  state
                                                      .detailsModel
                                                      ?.applicantRoleId
                                                      .displayApplicant ??
                                                  ApplicantType.owner,
                                              unitData:
                                                  state
                                                      .detailsModel
                                                      ?.data?[state
                                                      .activeCategories[state
                                                          .selectedCategoryIndex]
                                                      .key]['data'][index],
                                              otherName: state
                                                  .detailsModel
                                                  ?.applicantRoleOther,
                                            ),
                                          ),
                                          withNavBar: false,
                                          pageTransitionAnimation:
                                              PageTransitionAnimation.slideUp,
                                        );
                                      },
                                      propertyTypeText: getPropertyTypeText(
                                        summary,
                                      ),
                                      governorateText: getGovernorateText(
                                        summary,
                                      ),
                                      districtText: getDistrictText(summary),
                                      regionText: getRegionText(summary),
                                      realEstateFloorText:
                                          getRealEstateFloorText(summary),
                                      realEstateCode: getRealEstateCode(
                                        summary,
                                      ),
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

  _onStateChange(DeclarationDetailsStates state, BuildContext context) {
    if (state is DeclarationDeleteLoading ||
        state is DeclarationSubmitLoading) {
      loadingPopup(RuntimeData.getCurrentContext()!);
    } else if (state is DeclarationDeleteSuccess ||
        state is DeclarationSubmitSuccess) {
      updateDeclarationList();
      Navigator.of(RuntimeData.getCurrentContext()!).pop();
      Navigator.of(context).pop();
    } else if (state is DeclarationDeleteUnitSuccess) {
      context.read<DeclarationDetailsCubit>().fetchDeclarationModel();
      updateDeclarationList();
      Navigator.of(RuntimeData.getCurrentContext()!).pop();
    } else if (state is DeclarationDeleteError) {
      Navigator.of(RuntimeData.getCurrentContext()!).pop();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(state.message)));
    } else if (state is DeclarationSubmitError) {
      Navigator.of(RuntimeData.getCurrentContext()!).pop();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(state.message)));
    }
  }
}

String? getId(String title, int index, Map<String, dynamic> data) {
  if (data.isEmpty) {
    return null;
  }
  return data[title]['data'][index]['id'].toString();
}

Future<void> showDeletePropertyDialog(
  BuildContext context,
  Function onDelete, {
  required int unitId,
}) async {
  final confirmed = await showConfirmationDialog(
    context,
    title: 'تأكيد حذف العقار',
    message:
        'هل أنت متأكد من رغبتك في حذف هذا العقار من الإقرار؟\n'
        'سيتم إزالة جميع البيانات المرتبطة به.',
    confirmText: 'حذف العقار',
  );

  if (confirmed == true) {
    onDelete();
    // Call delete unit API with unitId
    debugPrint('Property $unitId deleted');
  }
}
