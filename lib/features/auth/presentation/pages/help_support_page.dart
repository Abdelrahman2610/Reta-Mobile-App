import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  static const String _email = 'epay@rta.gov.eg';
  static const String _phone = '0235356868';

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.neutralLightLightest,
        appBar: _buildAppBar(context),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 32.h),
              _buildIllustrationSection(),
              SizedBox(height: 32.h),
              _buildContactSection(context),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.neutralLightDarkest,
      elevation: 0,
      centerTitle: true,
      surfaceTintColor: AppColors.white,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_rounded,
          color: AppColors.mainBlueSecondary,
          size: 20.sp,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),

      title: Text(
        'المساعدة والدعم',
        style: AppTextStyles.actionXL.copyWith(
          color: AppColors.mainBlueSecondary,
        ),
      ),
    );
  }

  Widget _buildIllustrationSection() {
    return Container(
      width: double.infinity,
      color: AppColors.white,
      padding: EdgeInsets.symmetric(vertical: 32.h),
      child: Column(
        children: [
          Image.asset(
            'assets/images/hero_support.png',
            height: 260.h,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        children: [
          Expanded(
            child: _ContactCard(
              icon: Icons.phone,
              label: _phone,
              onTap: () => _launchPhone(context),
            ),
          ),
          SizedBox(width: 16.w),

          Expanded(
            child: _ContactCard(
              icon: Icons.email_outlined,
              label: _email,
              onTap: () => _launchEmail(context),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchEmail(BuildContext context) async {
    final uri = Uri(scheme: 'mailto', path: _email);
    if (!await launchUrl(uri)) {
      showError(context, 'تعذر فتح تطبيق البريد الإلكتروني');
    }
  }

  Future<void> _launchPhone(BuildContext context) async {
    final uri = Uri(scheme: 'tel', path: _phone);
    if (!await launchUrl(uri)) {
      showError(context, 'تعذر فتح تطبيق الهاتف');
    }
  }
}

void showError(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message, textDirection: TextDirection.rtl),
      backgroundColor: AppColors.errorDark,
      duration: const Duration(seconds: 2),
      action: SnackBarAction(
        label: 'حسناً',
        textColor: AppColors.white,
        onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
      ),
    ),
  );
}

class _ContactCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ContactCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 12.w),
        decoration: BoxDecoration(
          border: BoxBorder.all(color: AppColors.neutralLightDark),
          color: AppColors.neutralLightLight,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60.w,
              height: 60.w,
              decoration: BoxDecoration(
                color: AppColors.warningDark,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: AppColors.neutralLightLightest,
                size: 40.sp,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              label,
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr,
              style: AppTextStyles.actionM.copyWith(
                color: AppColors.neutralDarkDarkest,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
