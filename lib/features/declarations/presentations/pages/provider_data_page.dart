import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reta/core/helpers/app_enum.dart';
import 'package:reta/core/theme/app_colors.dart';
import 'package:reta/features/auth/data/models/user_models.dart';
import 'package:reta/features/auth/presentation/cubit/user_profile_cubit.dart';
import 'package:reta/features/components/app_bar.dart';
import 'package:reta/features/components/app_button.dart';
import 'package:reta/features/components/app_container.dart';

import '../../../../core/helpers/extensions/dimensions.dart';
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
  });

  final ApplicantType applicantType;
  final int declarationId;
  final DeclarationDetailsModel? existingDeclaration;
  final VoidCallback? afterUpdating;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<UserProfileCubit>().state;
    UserModel? userModel;
    if (state is UserProfileLoaded) {
      userModel = state.userModel;
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) {
            final cubit = ApplicantCubit(
              applicantType: applicantType,
              declarationId: declarationId,
              isEditMode: existingDeclaration != null,
              afterUpdating: afterUpdating,
            );

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
      child: BlocListener<UserProfileCubit, UserProfileState>(
        listenWhen: (prev, curr) =>
            curr is UserProfileLoaded /* أو UserProfileLoaded */,
        listener: (context, state) {
          final applicantCubit = context.read<ApplicantCubit>();

          UserModel? user;
          if (state is UserProfileLoaded) user = state.userModel;
          // لو عندك UserProfileLoaded وفيه userModel:
          // if (state is UserProfileLoaded) user = state.userModel;

          applicantCubit.initFromUser(user);

          // لو محتاج تعمل initFromDeclaration مرة واحدة
          if (existingDeclaration != null &&
              !applicantCubit.isEditMode /* أو flag عندك */ ) {
            applicantCubit.initFromDeclaration(existingDeclaration!);
          }
        },
        child: _ProviderDataView(),
      ),
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
