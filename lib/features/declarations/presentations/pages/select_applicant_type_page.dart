import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:reta/features/auth/data/models/user_models.dart';
import 'package:reta/features/declarations/presentations/pages/provider_data_page.dart';

import '../../../../core/helpers/app_enum.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/cubit/user_profile_cubit.dart';
import '../../../auth/presentation/cubit/user_profile_state.dart';
import '../../../components/app_bar.dart';
import '../../../components/app_text.dart';
import '../components/select_applicant_type_item.dart';

class SelectApplicantTypePage extends StatelessWidget {
  const SelectApplicantTypePage({super.key, required this.declarationId});

  final int declarationId;

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
                        if (state is! UserProfileLoaded) {
                          return const CircularProgressIndicator();
                        }
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
                              onPress: () => onApplicantTaped(
                                applicantType: ApplicantType.owner,
                                userModel: state.userModel,
                                context: context,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            SelectApplicantTypeItem(
                              title: "مالك على الشيوع",
                              subTitle:
                                  "تقديم الإقرار عن عقار مملوك بالاشتراك مع شركاء أو ورثة آخرين.",
                              onPress: () => onApplicantTaped(
                                applicantType: ApplicantType.sharedOwnership,
                                userModel: state.userModel,
                                context: context,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            SelectApplicantTypeItem(
                              title: "منتفع",
                              subTitle:
                                  "تقديم الإقرار عن عقار لك حق الانتفاع به وفق سند أو حق قانوني.",
                              onPress: () => onApplicantTaped(
                                applicantType: ApplicantType.beneficiary,
                                userModel: state.userModel,
                                context: context,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            SelectApplicantTypeItem(
                              title: "وكيل",
                              subTitle:
                                  "تقديم الإقرار نيابةً عن المكلف بموجب توكيل رسمي ساري.",
                              onPress: () => onApplicantTaped(
                                applicantType: ApplicantType.agent,
                                userModel: state.userModel,
                                context: context,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            SelectApplicantTypeItem(
                              title: "ممثل قانوني",
                              subTitle:
                                  "تقديم الإقرار بصفتك ممثلًا قانونيًا عن شخص أو جهة مكلفة.",

                              onPress: () => onApplicantTaped(
                                applicantType:
                                    ApplicantType.legalRepresentative,
                                userModel: state.userModel,
                                context: context,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            SelectApplicantTypeItem(
                              title: "أخرى",
                              subTitle:
                                  "تقديم الإقرار في حالات خاصة لا تندرج ضمن الصفات السابقة.",
                              isOther: true,
                              onPress: () => onApplicantTaped(
                                applicantType: ApplicantType.other,
                                userModel: state.userModel,
                                context: context,
                              ),
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

  void onApplicantTaped({
    required ApplicantType applicantType,
    required BuildContext context,
    required UserModel userModel,
  }) {
    PersistentNavBarNavigator.pushNewScreen(
      context,
      screen: ProviderDataPage(
        applicantType: ApplicantType.other,
        declarationId: declarationId,
        userModel: userModel,
      ),
      withNavBar: true,
      pageTransitionAnimation: PageTransitionAnimation.slideUp,
    );
  }
}
