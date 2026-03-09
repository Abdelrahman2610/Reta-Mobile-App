import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/helpers/extensions/dimensions.dart';
import '../../core/helpers/fixed_assets.dart';
import '../../core/theme/app_colors.dart';
import 'app_text.dart';
import 'image_svg_custom_widget.dart';

class AppInfoDialog extends StatelessWidget {
  const AppInfoDialog({
    super.key,
    required this.title,
    required this.content,
    required this.context,
  });

  final String title;
  final String content;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ImageSvgCustomWidget(imgPath: FixedAssets.instance.infoIC),
              12.ws,
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppText(
                      text: title,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.neutralDarkDarkest,
                      textAlign: TextAlign.start,
                      maxLines: 2,
                    ),

                    AppText(
                      text: content,
                      fontSize: 14.sp,
                      color: AppColors.neutralDarkMedium,
                      maxLines: 3,
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ),
              ),
              12.ws,
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(
                  Icons.close,
                  color: AppColors.neutralDarkDark,
                  size: 20.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
