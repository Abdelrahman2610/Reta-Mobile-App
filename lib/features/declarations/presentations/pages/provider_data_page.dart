import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reta/core/helpers/app_enum.dart';
import 'package:reta/core/theme/app_colors.dart';
import 'package:reta/features/components/app_bar.dart';
import 'package:reta/features/components/app_button.dart';
import 'package:reta/features/components/app_container.dart';

import '../../../../core/helpers/extensions/dimensions.dart';
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
  });

  final ApplicantType applicantType;
  final int declarationId;

  @override
  Widget build(BuildContext context) {
    // final user = context.read<LoginCubit>().state.user;
    // Map<String, dynamic> user = {
    //   "firstName": "Khaled",
    //   "lastName": "Abdelrazeq",
    //   "phone": "01024783981",
    //   "email": "khaled.abdelrazeq971@gmail.com",
    //   "nationality": "egyptian",
    //   "nationalId": "12345678912345",
    //   "nationalIdFileURL": "https:www.google.com",
    // };

    Map<String, dynamic> user = {
      "id": 1,
      "user_id": "1",
      "first_name": "احمد",
      "second_name": "محمد",
      "third_name": "محمد",
      "fourth_name": "علي",
      "nationality_id": "63",
      "national_id": "28612250100491",
      "passport_num": null,
      "factory_num": "987654335",
      "governorate_id": "1",
      "district_id": "1",
      "village_id": "1",
      "street_id": "1",
      "street_other": null,
      "real_estate_num": "12",
      "mobile": "01223872695",
      "deleted_at": null,
      "created_at": "2026-01-29 19:32:41",
      "updated_at": "2026-02-05 00:44:28",
      "gender": "ذكر",
      "birth_place": "القاهرة",
      "birth_date": "1986-12-25",
      "last_name": null,
      "mobile_verified_at": null,
      "ocr_verified": 0,
      "full_name": "احمد محمد محمد علي",
      "nationality": {
        "id": 63,
        "name": "مصر",
        "code": "EG",
        "order": -1,
        "deleted_at": null,
        "created_at": "2026-01-29 19:32:39",
        "updated_at": "2026-01-29 19:32:39",
      },
      "governorate": {
        "id": 1,
        "name": "القاهرة",
        "code": "01",
        "order": 0,
        "deleted_at": null,
        "created_at": "2026-01-29T17:32:40.000000Z",
        "updated_at": "2026-01-29T17:32:40.000000Z",
      },
      "national_id_file": [
        {
          "id": 450,
          "url":
              "public/national-id/qFDOMpVB9Ugn5rU8duQeoRp3nbVnrzf3LAauzU6G.pdf",
          "attachmentable_type": "App\\Models\\Users\\Profile",
          "attachmentable_id": "1",
          "field_name": "national-id",
          "created_at": "2026-02-04T22:44:28.907000Z",
          "updated_at": "2026-02-04T22:44:28.907000Z",
          "title": null,
          "original_file_name": null,
          "deleted_at": null,
          "full_url":
              "https://dev-rta-services.etax.com.eg/reta-services/public/api/files/public/national-id/qFDOMpVB9Ugn5rU8duQeoRp3nbVnrzf3LAauzU6G.pdf",
          "name": null,
          "path":
              "public/national-id/qFDOMpVB9Ugn5rU8duQeoRp3nbVnrzf3LAauzU6G.pdf",
        },
      ],
      "passport_num_file": [],
    };
    //TODO: Remove this MultiBlocProvider and uncomment BlocProvider
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ApplicantCubit(
            applicantType: applicantType,
            declarationId: declarationId,
          )..initFromUser(user),
          lazy: false,
        ),
        BlocProvider(
          create: (_) => DeclarationLookupsCubit()..fetchLookups(),
          lazy: false,
        ),
      ],
      child: const _ProviderDataView(),
    );

    //   return BlocProvider(
    //   create: (_) =>
    //       ApplicantCubit(applicantType: applicantType)..initFromUser(user),
    //   lazy: false,
    //   child: const _ProviderDataView(),
    // );
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
