import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../components/app_text.dart';

class FiltrationTitle extends StatelessWidget {
  const FiltrationTitle({
    super.key,
    required this.title,
    required this.onResetTapped,
  });

  final String title;
  final VoidCallback onResetTapped;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(width: 36),
        AppText(
          text: title,
          fontSize: 17.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.labelsVibrantPrimary,
        ),
        GestureDetector(
          onTap: onResetTapped,
          child: Container(
            width: 40.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.close,
              size: 18,
              color: AppColors.bottomSheetContent,
            ),
          ),
        ),
      ],
    );
  }
}
