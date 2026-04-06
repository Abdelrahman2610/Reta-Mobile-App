import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:reta/core/helpers/extensions/applicant_type.dart';
import 'package:reta/features/declarations/presentations/pages/provider_data_page.dart';

import '../../../../core/helpers/app_enum.dart';
import '../../../../core/helpers/loading_popup.dart';
import '../../../../core/helpers/runtime_data.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/verification_dialog.dart';
import '../../../auth/presentation/cubit/user_profile_cubit.dart';
import '../../../auth/presentation/cubit/user_profile_state.dart';
import '../../../auth/presentation/pages/help_support_page.dart';
import '../../../components/app_bar.dart';
import '../../../components/app_text.dart';
import '../components/select_applicant_type_item.dart';

class SelectApplicantTypePage extends StatelessWidget {
  SelectApplicantTypePage({super.key, required this.declarationId});

  final int declarationId;
  String? otherTitle;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.neutralLightMedium,
        appBar: MainAppBar(
          title: "صفة مقدم الطلب",
          backgroundColor: AppColors.mainBlueIndigoDye,
          backButtonIconColor: Colors.white,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 16.sp),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 31.h),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 24.h,
                    ),
                    child: BlocBuilder<UserProfileCubit, UserProfileState>(
                      builder: (context, state) {
                        return Column(
                          children: [
                            AppText(
                              text: 'إختار صفة مقدم الطلب',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.mainBlueIndigoDye,
                            ),
                            SizedBox(height: 24.h),
                            SelectApplicantTypeItem(
                              title: "مالك",
                              subTitle:
                                  "تقديم الإقرار عن جميع العقارات المملوكة لك بصفتك المالك القانوني.",
                              onPress: () {
                                canApplicantCreateDeclaration(
                                  ApplicantType.owner.id.toString(),
                                  context,
                                  () {
                                    onApplicantTaped(
                                      applicantType: ApplicantType.owner,
                                      context: context,
                                    );
                                  },
                                );
                              },
                            ),
                            SizedBox(height: 16.h),
                            SelectApplicantTypeItem(
                              title: "مالك على الشيوع",
                              subTitle:
                                  "تقديم الإقرار عن عقار مملوك بالاشتراك مع شركاء أو ورثة آخرين.",
                              onPress: () => onApplicantTaped(
                                applicantType: ApplicantType.sharedOwnership,
                                context: context,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            SelectApplicantTypeItem(
                              title: "منتفع",
                              subTitle:
                                  "تقديم الإقرار عن عقار لك حق الانتفاع به وفق سند أو حق قانوني.",
                              onPress: () {
                                canApplicantCreateDeclaration(
                                  ApplicantType.beneficiary.id.toString(),
                                  context,
                                  () {
                                    onApplicantTaped(
                                      applicantType: ApplicantType.beneficiary,
                                      context: context,
                                    );
                                  },
                                );
                              },
                            ),
                            SizedBox(height: 16.h),
                            SelectApplicantTypeItem(
                              title: "وكيل",
                              subTitle:
                                  "تقديم الإقرار نيابةً عن المكلف بموجب توكيل رسمي ساري.",
                              onPress: () {
                                if (checkCanSubmitIfUserNotValid(context)) {
                                  onApplicantTaped(
                                    applicantType: ApplicantType.agent,
                                    context: context,
                                  );
                                }
                              },
                            ),
                            SizedBox(height: 16.h),
                            SelectApplicantTypeItem(
                              title: "مستغل",
                              subTitle:
                                  "تقديم الإقرار عن عقار تقوم باستغلاله أو الانتفاع به بموجب عقد أو سند قانوني.",
                              onPress: () {
                                canApplicantCreateDeclaration(
                                  ApplicantType.exploited.id.toString(),
                                  context,
                                  () {
                                    onApplicantTaped(
                                      applicantType: ApplicantType.exploited,
                                      context: context,
                                    );
                                  },
                                );
                              },
                            ),
                            SizedBox(height: 16.h),
                            SelectApplicantTypeItem(
                              title: "ممثل قانوني",
                              subTitle:
                                  "تقديم الإقرار بصفتك ممثلًا قانونيًا عن شخص أو جهة مكلفة.",

                              onPress: () {
                                if (checkCanSubmitIfUserNotValid(context)) {
                                  onApplicantTaped(
                                    applicantType:
                                        ApplicantType.legalRepresentative,
                                    context: context,
                                  );
                                }
                              },
                            ),
                            SizedBox(height: 16.h),
                            SelectApplicantTypeItem(
                              title: "أخرى",
                              subTitle:
                                  "تقديم الإقرار في حالات خاصة لا تندرج ضمن الصفات السابقة.",
                              isOther: true,
                              otherName: (otherName) {
                                otherTitle = otherName;
                              },
                              onPress: () {
                                if (checkCanSubmitIfUserNotValid(context)) {
                                  onApplicantTaped(
                                    applicantType: ApplicantType.other,
                                    context: context,
                                    applicantOtherName: otherTitle,
                                  );
                                }
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 31.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool checkCanSubmitIfUserNotValid(BuildContext context) {
    final userModel = context.read<UserProfileCubit>().userModelData;
    if (userModel != null && (userModel.phoneVerified ?? false) == false) {
      showVerificationDialog(context, userModel);
      return false;
    } else {
      return true;
    }
  }

  Future canApplicantCreateDeclaration(
    String id,
    context,
    Function nextStep,
  ) async {
    loadingPopup(RuntimeData.getCurrentContext()!);
    final result = await safeApiCall(() async {
      final response = await DioClient.instance.dio.post(
        ApiConstants.checkApplicantRole(id),
      );
      return response.data as Map<String, dynamic>;
    });
    Navigator.pop(RuntimeData.getCurrentContext()!);
    switch (result) {
      case ApiSuccess(:final data):
        if (data['data']['exists'] == true) {
          showError(
            context,
            "لا يمكن إختيار هذه الصفة لوجود إقرار عام آخر بنفس هذه الصفة على النظام في نفس الفترة",
          );
        } else {
          nextStep();
          return true;
        }
      case ApiError(:final message):
        showError(context, message);
        return false;
    }
  }

  void onApplicantTaped({
    required ApplicantType applicantType,
    required BuildContext context,
    String? applicantOtherName,
  }) {
    PersistentNavBarNavigator.pushNewScreen(
      context,
      screen: ProviderDataPage(
        applicantType: applicantType,
        declarationId: declarationId,
        applicantOtherName: applicantOtherName,
      ),
      withNavBar: true,
      pageTransitionAnimation: PageTransitionAnimation.slideUp,
    );
  }
}
