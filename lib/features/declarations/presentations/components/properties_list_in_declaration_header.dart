import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../components/app_text.dart';
import '../../../components/inkwell_transparent.dart';

class PropertiesListInDeclarationHeader extends StatelessWidget {
  final String title;
  final bool canEdit;
  final VoidCallback onTap;

  const PropertiesListInDeclarationHeader(
    this.title,
    this.canEdit, {
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            AppColors.mainBlueIndigoDye,

            const Color(0xFF0D2D7A),
            const Color(0xFF0A1F5C),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      child: Stack(
        children: [
          if (canEdit)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkwellTransparent(
                  onTap: onTap,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 16.5.h,
                    ),
                    child: AppText(
                      text: "تعديل",
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 17.h),
                child: AppText(
                  text: "إقرار $title",
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
