import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reta/core/helpers/app_enum.dart';
import 'package:reta/core/theme/app_colors.dart';
import 'package:reta/features/components/app_bar.dart';
import 'package:reta/features/components/app_button.dart';
import 'package:reta/features/components/app_container.dart';
import 'package:reta/features/components/app_text.dart';

import '../../../../core/helpers/extensions/dimensions.dart';
import '../../../auth/presentation/cubit/user_profile_cubit.dart';
import '../../../auth/presentation/cubit/user_profile_state.dart';
import '../../data/models/declaration_details_model.dart';
import '../components/declaration_tabs.dart';
import '../components/user_information.dart';
import '../cubit/applicant_cubit.dart';
import '../cubit/applicant_states.dart';
import '../cubit/declaration_lookups_cubit.dart';

class ProviderDataPage extends StatelessWidget {
  const ProviderDataPage({
    super.key,
    required this.applicantType,
    required this.declarationId,
    this.existingDeclaration,
    this.afterUpdating,
    this.applicantOtherName,
  });

  final ApplicantType applicantType;
  final int declarationId;
  final DeclarationDetailsModel? existingDeclaration;
  final VoidCallback? afterUpdating;
  final String? applicantOtherName;

  @override
  Widget build(BuildContext context) {
    final profileState = context.read<UserProfileCubit>().state;
    final user = profileState is UserProfileLoaded
        ? profileState.userModel
        : null;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) {
            final cubit = ApplicantCubit(
              applicantType: applicantType,
              declarationId: declarationId,
              isEditMode: existingDeclaration != null,
              afterUpdating: afterUpdating,
              applicantOtherName: applicantOtherName,
            )..initFromUser(user);

            if (existingDeclaration != null) {
              cubit.initFromDeclaration(existingDeclaration!);
            }

            if (existingDeclaration != null) {
              cubit.initFromDeclaration(existingDeclaration!);
            }

            return cubit;
          },
          lazy: false,
        ),
        BlocProvider(
          create: (_) => DeclarationLookupsCubit()..fetchLookups(),
          lazy: false,
        ),
      ],
      child: _ProviderDataView(),
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
              content: AppText(
                text: state.errorMessage!,
                color: AppColors.white,
                alignment: AlignmentDirectional.center,
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
        if (state.successMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: AppText(
                text: state.successMessage!,
                color: AppColors.white,
                alignment: AlignmentDirectional.center,
              ),
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
                  onCancel: cubit.isEditMode
                      ? () => Navigator.pop(context)
                      : null,
                  onSave:
                      cubit.isEditMode &&
                          cubit.applicantType != ApplicantType.owner &&
                          cubit.applicantType != ApplicantType.beneficiary
                      ? () => cubit.saveEdit(context)
                      : null,
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
                      if (!cubit.isEditMode)
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
