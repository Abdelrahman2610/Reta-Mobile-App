import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../components/app_text.dart';

class TitleWithDivider extends StatelessWidget {
  const TitleWithDivider({super.key, required this.title, this.fontSize});

  final String title;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: AppText(
            text: title,
            fontSize: fontSize ?? 16.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.neutralDarkMedium,
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}
