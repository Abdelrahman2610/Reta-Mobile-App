import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/app_colors.dart';
import 'app_text.dart';

class RetaAppBar extends StatelessWidget {
  const RetaAppBar({super.key, this.onBackTapped, this.title});

  final VoidCallback? onBackTapped;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 135.h,
      alignment: AlignmentDirectional.bottomCenter,
      padding: EdgeInsets.only(left: 24.w, right: 24.w, top: 70.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(1, 10),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: onBackTapped ?? () => Navigator.pop(context),
            child: Icon(Icons.arrow_back_ios),
          ),
          AppText(
            text: title,
            fontSize: 16.sp,
            color: AppColors.neutralDarkDark,
            fontWeight: FontWeight.w600,
          ),
          SizedBox.shrink(),
        ],
      ),
    );
  }
}
