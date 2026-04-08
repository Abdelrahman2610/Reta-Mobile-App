import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reta/core/helpers/extensions/dimensions.dart';

import '../helpers/fixed_assets.dart';
import '../theme/app_colors.dart';

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              20.hs,
              SizedBox(
                height: 250.h,
                width: 250.w,
                child: Image.asset('assets/images/logo.png'),
              ),
              Text(
                "مصلحة الضرائب العقارية",
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.mainBlueIndigoDye,
                ),
              ),
              100.hs,
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    FixedAssets.instance.securityIcon,
                    height: 71.h,
                    width: 71.w,
                  ),
                  10.ws,
                  Text(
                    "تعذر التحقق من أمان الجهاز",
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.mainBlueIndigoDye,
                    ),
                  ),
                ],
              ),
              60.hs,
              Text(
                "تم اكتشاف إعدادات غير آمنة على الجهاز"
                "\n"
                "(مثل تفعيل وضع المطور).",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.neutralDarkMedium,
                ),
              ),
              18.hs,
              Text(
                "يرجى إيقاف هذه الإعدادات ثم إعادة المحاولة.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.neutralDarkMedium,
                ),
              ),
              60.hs,
              Text(
                "تطبيق الضرائب العقارية",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.neutralDarkMedium,
                ),
              ),
              18.hs,
              Text(
                "الإصدار 1.0.0",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.neutralDarkLight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
