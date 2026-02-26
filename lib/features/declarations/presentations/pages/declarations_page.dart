import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reta/core/helpers/fixed_assets.dart';
import 'package:reta/features/components/app_text.dart';
import 'package:reta/features/components/image_svg_custom_widget.dart';
import 'package:reta/features/declarations/presentations/components/empty_data_widget.dart';
import 'package:reta/features/declarations/presentations/pages/properties_list_in_declaration_page.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../components/app_bar.dart';
import '../../../components/app_button.dart';
import '../cubit/declaration_lookups_cubit.dart';

class DeclarationsPage extends StatelessWidget {
  const DeclarationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (_) => DeclarationLookupsCubit()..fetchLookups(),
      child: const _DeclarationsView(),
    );
  }
}

class _DeclarationsView extends StatelessWidget {
  const _DeclarationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: Column(
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
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const PropertiesListInDeclarationPage(),
                      ),
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
              child: EmptyDataWidget(title: "لم يتم إضافة أي إقرار بعد"),
            ),
            SizedBox(height: 38.h),
          ],
        ),
      ),
    );
  }
}
