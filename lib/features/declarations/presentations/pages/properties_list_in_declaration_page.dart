import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reta/features/declarations/presentations/cubit/declaration/declaration_details_states.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../components/app_bar.dart';
import '../../../components/circular_progress_indicator_platform_widget.dart';
import '../../data/models/declaration_model.dart';
import '../components/add_new_property_button.dart';
import '../components/cancel_declaration_button.dart';
import '../components/properties_list_in_declaration_header.dart';
import '../components/property_item_in_declaration.dart';
import '../components/submit_declaration_button.dart';
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
                    if (declarationModel.statusId != "3")
                      PropertiesListInDeclarationHeader(),
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

                    Expanded(
                      child: ListView.builder(
                        itemCount: state.detailsModel?.unitsCount.total,
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 20.h,
                        ),
                        itemBuilder: (_, index) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 15.h),
                            child: PropertyItemInDeclaration(),
                          );
                        },
                      ),

                      ///if list empty
                      // EmptyDataWidget(title: "لم يتم إضافة أي عقار بعد"),
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
}
