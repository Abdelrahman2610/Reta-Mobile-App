import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:reta/core/helpers/fixed_assets.dart';
import 'package:reta/features/components/app_text.dart';
import 'package:reta/features/components/image_svg_custom_widget.dart';
import 'package:reta/features/declarations/presentations/components/empty_data_widget.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../components/app_bar.dart';
import '../../../components/app_button.dart';
import '../../../components/circular_progress_indicator_platform_widget.dart';
import '../components/declarations_card_item.dart';
import '../cubit/declaration/declaration_cubit.dart';
import '../cubit/declaration/declaration_states.dart';
import 'select_applicant_type_page.dart';
import '../cubit/declaration_lookups_cubit.dart';

class DeclarationsPage extends StatelessWidget {
  const DeclarationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (_) => DeclarationCubit()..fetchList()..fetchLookups(),
      child: _DeclarationsView(),
    );
  }
}

class _DeclarationsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.neutralLightMedium,
        appBar: MainAppBar(
          backButtonAction: () {},
          title: "إقراراتي",
          backgroundColor: AppColors.mainBlueIndigoDye,
          backButtonIconColor: Colors.white,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 16.sp),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: BlocBuilder<DeclarationCubit, DeclarationState>(
            builder: (context, state) {
              if (state is DeclarationListLoading) {
                return CircularProgressIndicatorPlatformWidget();
              }
              if (state is DeclarationListLoaded) {
                return Column(
                  children: [
                    SizedBox(height: 31.h),
                    Row(
                      textDirection: TextDirection.rtl,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
                          text: 'إدارة الإقرارات المضافة إلى حسابي',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.mainBlueIndigoDye,
                        ),
                        AppButton(
                          onTap: () {
                            PersistentNavBarNavigator.pushNewScreen(
                              context,
                              screen: const SelectApplicantTypePage(),
                              withNavBar: true,
                              pageTransitionAnimation:
                                  PageTransitionAnimation.slideUp,
                            );
                          },
                          label: "إضافة إقرار",
                          width: 109.w,
                          height: 46.h,
                          borderColor: Colors.transparent,
                          backgroundColor: AppColors.mainOrange,
                          textColor: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          iconLeft: false,
                          icon: ImageSvgCustomWidget(
                            color: Colors.white,
                            imgPath: FixedAssets.instance.addIcon,
                            height: 18.h,
                            width: 18.w,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),
                    Expanded(
                      child: (state.declarationList ?? []).isEmpty
                          ? EmptyDataWidget(title: "لم يتم إضافة أي إقرار بعد")
                          : ListView.builder(
                              shrinkWrap: true,
                              primary: true,
                              itemCount: state.declarationList!.length,
                              padding: EdgeInsetsGeometry.only(bottom: 31.h),
                              itemBuilder: (_, index) {
                                return DeclarationsCardItem(
                                  item: state.declarationList![index],
                                );
                              },
                            ),
                    ),
                  ],
                );
              } else if (state is DeclarationListError) {
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
