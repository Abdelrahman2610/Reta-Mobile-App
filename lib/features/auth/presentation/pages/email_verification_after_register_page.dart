import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'main_page.dart';

class EmailVerificationAfterRegisterPage extends StatelessWidget {
  final String email;

  const EmailVerificationAfterRegisterPage({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.neutralLightLight,
        appBar: AppBar(
          backgroundColor: AppColors.neutralLightLight,
          elevation: 0,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            'تأكيد البريد الإلكتروني',
            style: AppTextStyles.actionXL.copyWith(
              color: AppColors.mainBlueSecondary,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
          child: Column(
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: AppColors.mainBlueIndigoDye.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.mark_email_read_outlined,
                  size: 48,
                  color: AppColors.mainBlueIndigoDye,
                ),
              ),
              const SizedBox(height: 32),

              Text(
                'تحقق من بريدك الإلكتروني',
                textAlign: TextAlign.center,
                style: AppTextStyles.h3.copyWith(
                  color: AppColors.mainBlueIndigoDye,
                ),
              ),
              const SizedBox(height: 12),

              Text(
                'تم إرسال رابط التحقق إلى',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyM.copyWith(
                  color: AppColors.neutralDarkLight,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                email,
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.center,
                style: AppTextStyles.h5.copyWith(
                  color: AppColors.neutralDarkDarkest,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'يرجى فتح البريد الإلكتروني والضغط على الرابط لإتمام التحقق قبل تسجيل الدخول.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyM.copyWith(
                  color: AppColors.neutralDarkLight,
                ),
              ),

              const SizedBox(height: 32),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: AppColors.highlightDarkest.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.highlightDarkest.withOpacity(0.2),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 18,
                      color: AppColors.highlightDarkest,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'إذا لم تجد الرسالة في صندوق الوارد، تفقد مجلد البريد العشوائي (Spam).',
                        style: AppTextStyles.bodyM.copyWith(
                          color: AppColors.neutralDarkMedium,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 48),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (_) => const MainPage(isLoggedIn: false),
                      ),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.highlightDarkest,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'الذهاب إلى تسجيل الدخول',
                    style: AppTextStyles.actionL.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
