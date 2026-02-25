import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reta/core/theme/app_colors.dart';
import 'package:reta/features/components/app_bar.dart';
import 'package:reta/features/components/app_button.dart';
import 'package:reta/features/components/app_container.dart';

import '../../../../core/helpers/extensions/dimensions.dart';
import '../components/declaration_tabs.dart';
import '../components/user_information.dart';
import '../cubit/applicant_cubit.dart';
import '../cubit/applicant_states.dart';

class ProviderDataPage extends StatelessWidget {
  const ProviderDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    // final user = context.read<LoginCubit>().state.user;
    Map<String, dynamic> user = {
      "firstName": "Khaled",
      "lastName": "Abdelrazeq",
      "phone": "01024783981",
      "email": "khaled.abdelrazeq971@gmail.com",
      "nationality": "egyptian",
      "nationalId": "12345678912345",
      "nationalIdFileURL": "https:www.google.com",
    };
    return BlocProvider(
      create: (_) => ApplicantCubit()..initFromUser(user),
      lazy: false,
      child: const _ProviderDataView(),
    );
  }
}

class _ProviderDataView extends StatelessWidget {
  const _ProviderDataView({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ApplicantCubit>();
    return BlocListener<ApplicantCubit, ApplicantState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
        }
        if (state.successMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.successMessage!),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.neutralLightMedium,
        body: SingleChildScrollView(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              children: [
                MainAppBar(
                  title: 'بيانات الإقرار',
                  backgroundColor: AppColors.white,
                  backButtonIconColor: AppColors.neutralDarkDark,
                  titleTextStyle: TextStyle(
                    color: AppColors.neutralDarkDark,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                15.hs,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: [
                      DeclarationTabs(applicantType: cubit.applicantType),
                      10.hs,
                      UserInformation(cubit: cubit),
                      10.hs,
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
                          onTap: () => cubit.onNextTapped(context),
                        ),
                      ),
                      26.hs,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
