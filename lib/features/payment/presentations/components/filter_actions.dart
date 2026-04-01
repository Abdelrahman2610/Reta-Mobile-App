import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/extensions/dimensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../components/app_text.dart';
import 'filter_app_container.dart';

class FilterActions extends StatelessWidget {
  const FilterActions({
    super.key,
    required this.count,
    required this.onApplyTapped,
    required this.onCancelTapped,
  });

  final int count;
  final VoidCallback onApplyTapped;
  final VoidCallback onCancelTapped;

  @override
  Widget build(BuildContext context) {
    return FilterAppContainer(
      paddingVertical: 24.h,
      child: Row(
        children: [
          12.ws,
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: onApplyTapped,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.highlightDarkest,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 14.h),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(
                    text: 'تطبيق',
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  8.ws,
                  if (count > 0)
                    Container(
                      width: 22.w,
                      height: 22.w,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: AppText(
                        text: '$count',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        alignment: AlignmentDirectional.center,
                      ),
                    ),
                ],
              ),
            ),
          ),
          12.ws,
          Expanded(
            child: OutlinedButton(
              onPressed: onCancelTapped,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.mainBlueIndigoDye),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 14.h),
              ),
              child: AppText(
                text: 'إلغاء',
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.mainBlueIndigoDye,
                alignment: AlignmentDirectional.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
