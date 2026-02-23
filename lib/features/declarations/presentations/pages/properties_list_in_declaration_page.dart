import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../components/app_bar.dart';
import '../components/add_new_property_button.dart';
import '../components/cancel_declaration_button.dart';
import '../components/properties_list_in_declaration_header.dart';
import '../components/property_item_in_declaration.dart';
import '../components/submit_declaration_button.dart';

class PropertiesListInDeclarationPage extends StatelessWidget {
  const PropertiesListInDeclarationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralLightMedium,
      appBar: MainAppBar(
        title: "قائمة العقارات داخل الإقرار",
        backgroundColor: AppColors.mainBlueIndigoDye,
        backButtonIconColor: Colors.white,
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 16.sp),
      ),
      body: SizedBox(
        child: Column(
          children: [
            PropertiesListInDeclarationHeader(),
            SizedBox(height: 30.h),
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
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: ListView(
                  children: [
                    PropertyItemInDeclaration(),
                    SizedBox(height: 15.h),
                    PropertyItemInDeclaration(),
                    SizedBox(height: 15.h),
                    PropertyItemInDeclaration(),
                    SizedBox(height: 20.h),
                  ],
                ),

                ///if list empty
                // EmptyDataWidget(title: "لم يتم إضافة أي عقار بعد"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
